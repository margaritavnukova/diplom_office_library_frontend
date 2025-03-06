// import 'package:flutter/material.dart';
import 'book_class.dart';
import 'item_base_class.dart';

class Reader implements Item {
  final String email;
  final String password;
  final String? phone;
  final String? fullName;
  final Book? books;

  Reader({
    required this.email,
    required this.password,
    this.phone,
    this.fullName,
    this.books,
  });
  
  @override
  factory Reader.fromJson(Map<String, dynamic> json) {
    return Reader(
      email: json['Email'],
      password: json['Password'],
      phone: json['Phone'],
      fullName: json['FullName'],
      books: json['Books'],
    );
  }

  Map<String, dynamic> toJson() => {'Email': email, 'Password': password,  'Phone': phone, 'FullName': fullName, 'Books': books};
  String toJsonStr() => toJson.toString();
}