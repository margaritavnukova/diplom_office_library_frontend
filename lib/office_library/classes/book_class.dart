import 'dart:convert';

import 'package:flutter/material.dart';

import 'author_class.dart';
import 'genre_class.dart';
import 'item_base_class.dart';
import '../assets/strings.dart';
import 'reader_class.dart';

class Book implements Item {
  @override String? id;
  final Author author;
  @override String? name;
  final Genre genre;
  final bool isDeleted;
  final DateTime year;
  final List<dynamic> readers;
  final bool isTaken;
  final DateTime? dateTaken;
  final DateTime? plannedReturnDate; // Добавлено
  final DateTime? actualReturnDate;   // Изменено с dateOfReturning
  final int? takingCount;
  final Reader? currentReader;
  final String? photoBase64;

  Book({
    this.id = "",
    required this.author,
    required this.name,
    required this.genre,
    required this.isDeleted,
    required this.year,
    required this.readers,
    required this.isTaken,
    this.dateTaken,
    this.plannedReturnDate, // Добавлено
    this.actualReturnDate,   // Изменено
    this.takingCount,
    this.currentReader,
    this.photoBase64
  });

  @override
  factory Book.fromJson(Map<String, dynamic> json) {
    var jAuthor = json[BookJsonKeys.author];
    var jGenre = json[BookJsonKeys.genre];

    return Book(
      id: json[BookJsonKeys.id],
      author: Author.fromJson(jAuthor),
      name: json[BookJsonKeys.title],
      genre: Genre.fromJson(jGenre),
      isDeleted: json[BookJsonKeys.isDeleted] ?? false,
      year: DateTime.parse(json[BookJsonKeys.year]),
      readers: json[BookJsonKeys.readers],
      isTaken: json[BookJsonKeys.isTaken],
      dateTaken: json[BookJsonKeys.dateTaken] != null
          ? DateTime.parse(json[BookJsonKeys.dateTaken])
          : null,
      plannedReturnDate: json[BookJsonKeys.plannedReturnDate] != null // Добавлено
          ? DateTime.parse(json[BookJsonKeys.plannedReturnDate])
          : null,
      actualReturnDate: json[BookJsonKeys.actualReturnDate] != null // Изменено
          ? DateTime.parse(json[BookJsonKeys.actualReturnDate])
          : null,
      takingCount: json[BookJsonKeys.takingCount],
      currentReader: json[BookJsonKeys.currentReader] != null
        ? Reader.fromJson(json[BookJsonKeys.currentReader])
        : null,
      photoBase64: json[BookJsonKeys.photoBase64],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    var jAuthor = author?.toJson();
    var jGenre = genre?.toJson();

    return {
      BookJsonKeys.id: id,
      BookJsonKeys.author: jAuthor,
      BookJsonKeys.title: name,
      BookJsonKeys.genre: jGenre,
      BookJsonKeys.isDeleted: isDeleted,
      BookJsonKeys.year: year.toIso8601String(),
      BookJsonKeys.readers: readers,
      BookJsonKeys.isTaken: isTaken,
      BookJsonKeys.dateTaken: dateTaken?.toIso8601String(),
      BookJsonKeys.plannedReturnDate: plannedReturnDate?.toIso8601String(), // Добавлено
      BookJsonKeys.actualReturnDate: actualReturnDate?.toIso8601String(), // Изменено
      BookJsonKeys.takingCount: takingCount,
      BookJsonKeys.currentReader: currentReader?.toJson(),
      BookJsonKeys.photoBase64: photoBase64,
    };
  }

  Book takeBook(Reader reader) {
    final now = DateTime.now();
    readers.add(reader);

    return Book(
      id: id,
      author: author,
      name: name,
      genre: genre,
      isDeleted: isDeleted,
      year: year,
      readers: readers,
      isTaken: true, // Установлено в true
      dateTaken: now,
      plannedReturnDate: null, // Рассчитаю на сервере
      actualReturnDate: null, // Пока книга не возвращена
      takingCount: (takingCount ?? 0) + 1, // Увеличено
      currentReader: reader,
      photoBase64: photoBase64
    );
  }

  Book returnBook(Reader reader, DateTime returnDate) {
    return Book(
      id: id,
      author: author,
      name: name,
      genre: genre,
      isDeleted: isDeleted,
      year: year,
      readers: readers,
      isTaken: false, // Установлено в false
      dateTaken: dateTaken,
      plannedReturnDate: plannedReturnDate,
      actualReturnDate: DateTime.now(), // Установлена текущая дата
      takingCount: takingCount,
      currentReader: null, // Обнулен
      photoBase64: photoBase64
    );
  }

  String toJsonStr() => toJson().toString();

  ImageProvider? get coverImage {
    if (photoBase64 == null) {
      return null;
    }
    return MemoryImage(base64Decode(photoBase64!));
  }

  Book restoredBook() {
    return Book(
      id: id,
      author: author,
      name: name,
      genre: genre,
      isDeleted: false, // Установлено в false
      year: year,
      readers: readers,
      isTaken: isTaken, 
      dateTaken: dateTaken,
      plannedReturnDate: plannedReturnDate,
      actualReturnDate: actualReturnDate, 
      takingCount: takingCount,
      currentReader: currentReader, // Обнулен
      photoBase64: photoBase64
    );
  }
}
