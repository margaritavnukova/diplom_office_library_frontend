import 'package:flutter/material.dart';
import 'book_class.dart';

class LoginInfo {
  String name;
  String password;
  String pfp;
  List<Book>? finishedBooks;

  LoginInfo({
    required this.name, 
    required this.password,
    required this.pfp,
    required this.finishedBooks,
  });
}