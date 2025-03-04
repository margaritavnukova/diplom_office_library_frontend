// import 'package:flutter/material.dart';
import 'book_class.dart';

class Reader {
  final String email;
  final String fullName;
  final String password;
  final Book? books;

  Reader({
    required this.email,
    required this.fullName,
    required this.password,
    this.books,
  });

  factory Reader.fromJson(Map<String, dynamic> json) {
    return Reader(
      email: json['Email'],
      fullName: json['FullName'],
      password: json['Password'],
      books: json['Books'],
    );
  }

  Map<String, dynamic> toJson() => {'Email': email, 'FullName': fullName, 'Password': password, 'Books': books};
}