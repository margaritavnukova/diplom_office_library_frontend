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
  final String? photo;
  final DateTime? registrationDate;

  Reader({
    this.id,
    required this.email,
    this.phoneNumber,
    this.name,
    this.role,
    this.books,
    this.photo,
    this.registrationDate
  });
  
  @override
  factory Reader.fromJson(Map<String, dynamic> json) {
    return Reader(
      id: json[UserJsonKeys.id],
      email: json[UserJsonKeys.email],
      phoneNumber: json[UserJsonKeys.phoneNumber],
      name: json[UserJsonKeys.userName],
      role: json[UserJsonKeys.role],
      photo: json[UserJsonKeys.photo],
      registrationDate: json[UserJsonKeys.registrationDate] != null 
        ? DateTime.parse(json[UserJsonKeys.registrationDate])
        : DateTime.now()
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    UserJsonKeys.id: id,
    UserJsonKeys.email: email, 
    UserJsonKeys.phoneNumber: phoneNumber, 
    UserJsonKeys.userName: name, 
    UserJsonKeys.role: role,
    UserJsonKeys.photo: photo.toString(),
    UserJsonKeys.registrationDate: registrationDate.toString()
    };

  String toJsonStr() => toJson.toString();
}