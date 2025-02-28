// import 'package:flutter/material.dart';
import 'reader_class.dart';

class Book {
  final int id;
  final String author;
  final String title;
  final String genre;
  final DateTime year;
  final List<dynamic> readers;

  Book({
    required this.id,
    required this.author,
    required this.title,
    required this.genre,
    required this.year,
    required this.readers,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['Id'],
      author: json['Author'],
      title: json['Title'],
      genre: json['Genre'],
      year: DateTime.parse(json['Year']),
      readers: json['Readers'],
    );
  }
}

//   Map<String, dynamic> toJson() => {'Title': title, 'Author': author};
// }