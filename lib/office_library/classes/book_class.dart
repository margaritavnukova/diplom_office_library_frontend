import 'dart:convert';

import 'package:flutter/material.dart';

import 'item_base_class.dart';
import '../assets/strings.dart';
import 'reader_class.dart';

class Book implements Item {
  @override String? id;
  final String author;
  @override String? name;
  final String genre;
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
    return Book(
      id: json[BookJsonKeys.id],
      author: json[BookJsonKeys.author],
      name: json[BookJsonKeys.title],
      genre: json[BookJsonKeys.genre],
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
    return {
      BookJsonKeys.id: id,
      BookJsonKeys.author: author,
      BookJsonKeys.title: name,
      BookJsonKeys.genre: genre,
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
      year: year,
      readers: readers,
      isTaken: true, // Установлено в true
      dateTaken: now,
      plannedReturnDate: now.add(Duration(days: 30)), // Рассчитано
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

  // Остальные методы без изменений
  String toJsonStr() => toJson().toString();

  ImageProvider? get coverImage {
    if (photoBase64 == null) {
      return null;
    }
    return MemoryImage(base64Decode(photoBase64!));
  }
}
