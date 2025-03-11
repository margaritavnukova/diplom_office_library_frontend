import 'item_base_class.dart';
import '../assets/strings.dart';

class Book implements Item {
  final int? id;
  final String author;
  final String title;
  final String genre;
  final DateTime year;
  final List<dynamic> readers;
  final bool isTaken;
  final DateTime? dateOfReturning;
  final int? takingCount;

  Book({
    this.id = 0,
    required this.author,
    required this.title,
    required this.genre,
    required this.year,
    required this.readers,
    required this.isTaken,
    this.dateOfReturning,
    this.takingCount,
  });

  @override
  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json[BookJsonKeys.id],
      author: json[BookJsonKeys.author],
      title: json[BookJsonKeys.title],
      genre: json[BookJsonKeys.genre],
      year: DateTime.parse(json[BookJsonKeys.year]),
      readers: json[BookJsonKeys.readers],
      isTaken: json[BookJsonKeys.isTaken],
      dateOfReturning: json[BookJsonKeys.dateOfReturning] != null
          ? DateTime.parse(json[BookJsonKeys.dateOfReturning])
          : null,
      takingCount: json[BookJsonKeys.takingCount],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      BookJsonKeys.id: id,
      BookJsonKeys.author: author,
      BookJsonKeys.title: title,
      BookJsonKeys.genre: genre,
      BookJsonKeys.year: year.toIso8601String(), // toIso8601String для корректного формата
    };
  }

  String toJsonStr() => toJson().toString(); 
}
