import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../assets/strings.dart';
import '../classes/fetch_data.dart';
import '../classes/put_data.dart';
import '../classes/reader_class.dart';

class EditProfileBloc {
  final Reader reader;
  File? newImageFile;
  bool isLoading = false;
  late Future<Reader> userFuture;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  EditProfileBloc({required this.reader}) {
    userFuture = fetch();
    _initializeControllers();
  }

  Future<void> _initializeControllers() async {
    final userToEdit = await userFuture;
    nameController.text = userToEdit.name ?? "no name";
    emailController.text = userToEdit.email;
    phoneController.text = userToEdit.phoneNumber ?? "no number";
  }

  Future<Reader> fetch() async {
    var fetchData = FetchData<Reader>(Reader.fromJson);
    var editedEmail = reader.email.replaceAll('.', '-');
    return await fetchData.fetchOne(
      UriStrings.getOneUserByEmailUri + editedEmail
    );
  }

  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 85,
    );

    if (pickedFile != null) {
      newImageFile = File(pickedFile.path);
    }
  }

  Future<Reader?> saveChanges() async {
    if (isLoading) return null;
    
    isLoading = true;

    try {
      String? imageBase64;
      if (newImageFile != null) {
        final bytes = await newImageFile!.readAsBytes();
        imageBase64 = base64Encode(bytes);
      }

      final readerEdited = Reader(
        id: reader.id, 
        email: emailController.text,
        name: nameController.text,
        phoneNumber: phoneController.text,
        role: reader.role,
        registrationDate: reader.registrationDate,
        photoBase64: imageBase64 ?? reader.photoBase64,
      );
      
      return await put(readerEdited);
      
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
    }
  }

  ImageProvider? getAvatarImage() {
    if (newImageFile != null) {
      return FileImage(newImageFile!);
    } else if (reader.photoBase64 != null) {
      return MemoryImage(base64Decode(reader.photoBase64!));
    } else {
      return const AssetImage('assets/images/default_avatar.png');
    }
  }

  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
  }
}

Future<Reader> put(Reader reader) async {
  final putData = PutData<Reader>(Reader.fromJson);
  final response = await putData.putItem(
    UriStrings.addControllerName(UriStrings.putByIdUri, 'User'), 
    reader
  );
  return json.decode(response.body);
}