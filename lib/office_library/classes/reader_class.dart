// import 'package:flutter/material.dart';
import 'book_class.dart';
import 'item_base_class.dart';
import '../assets/strings.dart';

class Reader implements Item {
  final String email;
  final String? phoneNumber;
  final String? userName;
  final String? role;
  final List<Book>? books;
  final String? photo;
  final DateTime? registrationDate;

  Reader({
    required this.email,
    this.phoneNumber,
    this.userName,
    this.role,
    this.books,
    this.photo,
    this.registrationDate
  });
  
  @override
  factory Reader.fromJson(Map<String, dynamic> json) {
    return Reader(
      email: json[UserJsonKeys.email],
      phoneNumber: json[UserJsonKeys.phoneNumber],
      userName: json[UserJsonKeys.userName],
      role: json[UserJsonKeys.role],
      photo: json[UserJsonKeys.photo],
      registrationDate: json[UserJsonKeys.registrationDate] != null 
        ? DateTime.parse(json[UserJsonKeys.registrationDate])
        : DateTime.now()
    );
  }

  Map<String, dynamic> toJson() => {
    UserJsonKeys.email: email, 
    UserJsonKeys.phoneNumber: phoneNumber, 
    UserJsonKeys.userName: userName, 
    UserJsonKeys.role: role,
    UserJsonKeys.photo: photo.toString(),
    UserJsonKeys.registrationDate: registrationDate.toString()
    };

  String toJsonStr() => toJson.toString();
}