import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../assets/strings.dart';
import '../classes/put_data.dart';
import '../classes/reader_class.dart';

class EditProfilePage extends StatefulWidget {
  final Reader reader;

  const EditProfilePage({Key? key, required this.reader}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  File? _newImageFile;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.reader.name);
    _emailController = TextEditingController(text: widget.reader.email);
    _phoneController = TextEditingController(text: widget.reader.phoneNumber);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 85,
    );

    if (pickedFile != null) {
      setState(() {
        _newImageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveChanges() async {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Введите имя')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Подготовка данных для отправки
      String? imageBase64;
      if (_newImageFile != null) {
        final bytes = await _newImageFile!.readAsBytes();
        imageBase64 = base64Encode(bytes);
      }

      // API вызов для сохранения изменений
      Reader readerEdited = Reader(
        id: widget.reader.id, 
        email: _emailController.text,
        name: _nameController.text,
        phoneNumber: _phoneController.text,
        role: widget.reader.role,
        registrationDate: widget.reader.registrationDate,
        photoBase64: imageBase64,
      );
      
      put(readerEdited);

      // После успешного сохранения
      Navigator.pop(context, true); // Возвращаем true как флаг успешного обновления
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка при сохранении: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Редактирование профиля'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _isLoading ? null : _saveChanges,
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  // Аватар и кнопка смены фото
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.grey[200],
                          backgroundImage: _getAvatarImage(),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: Icon(Icons.camera_alt, color: Colors.white),
                              onPressed: _pickImage,),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),
                  
                  // Поля для редактирования
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Имя',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                  SizedBox(height: 16),
                  
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email),
                    ),
                    readOnly: true, // Email обычно нельзя менять
                  ),
                  SizedBox(height: 16),
                  
                  TextFormField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      labelText: 'Телефон',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.phone),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  SizedBox(height: 24),
                  
                  // Кнопка сохранения
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _saveChanges,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        'Сохранить изменения',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  ImageProvider? _getAvatarImage() {
    if (_newImageFile != null) {
      return FileImage(_newImageFile!);
    } else if (widget.reader.photoBase64 != null) {
      return MemoryImage(base64Decode(widget.reader.photoBase64!));
    } else {
      return AssetImage('assets/images/default_avatar.png');
    }
  }
}

 void put(Reader reader){
    final putData = PutData<Reader>(Reader.fromJson);
    putData.putItem(UriStrings.addControllerName(UriStrings.putByIdUri, 'User'), reader);
  }