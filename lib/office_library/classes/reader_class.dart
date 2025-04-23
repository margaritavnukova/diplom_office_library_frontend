// import 'package:flutter/material.dart';
import 'book_class.dart';
import 'item_base_class.dart';
import '../assets/strings.dart';

class Reader implements Item {
  @override
  String? id;
  final String email;
  final String? phoneNumber;
  @override
  String? name;
  final String? role;
  final List<Book>? books;
  final DateTime? registrationDate;
  final String? photoBase64;

  Reader({
    this.id,
    required this.email,
    this.phoneNumber,
    this.name,
    this.role,
    this.books,
    this.registrationDate,
    this.photoBase64
  });
  
  @override
  factory Reader.fromJson(Map<String, dynamic> json) {
    return Reader(
      id: json[UserJsonKeys.id],
      email: json[UserJsonKeys.email],
      phoneNumber: json[UserJsonKeys.phoneNumber],
      name: json[UserJsonKeys.userName],
      role: json[UserJsonKeys.role],
      registrationDate: json[UserJsonKeys.registrationDate] != null 
        ? DateTime.parse(json[UserJsonKeys.registrationDate])
        : DateTime.now(),
      photoBase64: json[UserJsonKeys.photoBase64],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    UserJsonKeys.id: id,
    UserJsonKeys.email: email, 
    UserJsonKeys.phoneNumber: phoneNumber, 
    UserJsonKeys.userName: name, 
    UserJsonKeys.role: role,
    UserJsonKeys.registrationDate: registrationDate.toString(),
    UserJsonKeys.photoBase64: photoBase64,
    };

  String toJsonStr() => toJson.toString();
}