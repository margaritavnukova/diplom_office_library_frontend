// import 'package:flutter/material.dart';
import 'reader_class.dart';

class Book {
  final int id;
  final String author;
  final String title;
  final String genre;
  final DateTime year;
  final List<Reader> readers;
  List<dynamic>? readersStrList;

  Book.str({
    required this.id,
    required this.author,
    required this.title,
    required this.genre,
    required this.year,
    required this.readers,
    this.readersStrList,
  });

  Book({
    required this.id,
    required this.author,
    required this.title,
    required this.genre,
    required this.year,
    required this.readers,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    var readersTemp = json['Readers'];
    List<dynamic> readersStrListTemp = [];
    if (readersTemp != null && readersTemp.isNotEmpty) {
      for (var reader in readersTemp) {
        String userName = reader['UserName'];
        readersStrListTemp.add('UserName: $userName');
      }
    }

    return Book.str(
      id: json['Id'],
      author: json['Author'],
      title: json['Title'],
      genre: json['Genre'],
      year: DateTime.parse(json['Year']),
      readers: json['Readers'],
      readersStrList: readersStrListTemp,
    );
  }
}

//   Map<String, dynamic> toJson() => {'Title': title, 'Author': author};
// }