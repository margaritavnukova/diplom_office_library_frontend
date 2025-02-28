// import 'package:flutter/material.dart';
import 'book_class.dart';

class Reader {
  final int id;
  final String email;
  final Book? books;

  Reader({
    required this.id,
    required this.email,
    this.books,
  });

  factory Reader.fromJson(Map<String, dynamic> json) {
    return Reader(
      id: json['Id'],
      email: json['Email'],
      books: json['Book'],
    );
  }
}