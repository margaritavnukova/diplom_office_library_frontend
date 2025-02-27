// import 'package:flutter/material.dart';

class Book {
  final int id;
  final String author;
  final String title;
  final String genre;
  final DateTime year;
  final dynamic readers;

  Book({
    required this.id,
    required this.author,
    required this.title,
    required this.genre,
    required this.year,
    this.readers,
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

// class Book {
//   // final String Id;
//   final String? title;
//   final String? author;
//   // final String Genre;
//   // final String Year;
  
//   Book (
//   //   this.Id,
//     this.title,
//     this.author,
//   //   this.Genre,
//   //   this.Year
//   );

//   factory Book.fromJson(Map<String, String> json){
//     return Book(
//       // id: json['Id'],
//       json['Author'],
//       json['Title'],
//       // genre: json['Genre'],
//       // year: DateTime.parse(json['Year']),
//       // readers: json['Readers'],
//     );
//   }

//   Map<String, dynamic> toJson() => {'Title': title, 'Author': author};
// }