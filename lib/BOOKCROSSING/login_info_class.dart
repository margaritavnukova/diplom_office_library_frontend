import 'package:flutter/material.dart';
import 'book_class.dart';

class LoginInfo {
  final String name;
  final String password;
  final String pfp;
  final List<Book> finishedBooks;

  LoginInfo(
    this.name, 
    this.password,
    this.pfp,
    this.finishedBooks,
  );
}