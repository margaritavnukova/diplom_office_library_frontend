import 'item_base_class.dart';
import '../assets/strings.dart';

class Book implements Item {
  final String author;
  final String title;
  final String genre;
  final DateTime year;
  final List<dynamic> readers;
  final bool isTaken;
  final DateTime? dateOfReturning;
  final int? takingCount;

  Book({
    required this.author,
    required this.title,
    required this.genre,
    required this.year,
    required this.readers,
    required this.isTaken,
    this.dateOfReturning,
    this.takingCount
  });

  @override
  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      author: json[BookJsonKeys.author],
      title: json[BookJsonKeys.title],
      genre: json[BookJsonKeys.genre],
      year: DateTime.parse(json[BookJsonKeys.year]),
      readers: json[BookJsonKeys.readers],
      isTaken: json[BookJsonKeys.isTaken],
      dateOfReturning: json[BookJsonKeys.dateOfReturning],
      takingCount: json[BookJsonKeys.takingCount],
    );
  }

  Map<String, dynamic> toJson() => {
    BookJsonKeys.author: author, 
    BookJsonKeys.title: title, 
    BookJsonKeys.genre: genre, 
    BookJsonKeys.year: year.toString(),
    BookJsonKeys.readers: readers,
    BookJsonKeys.isTaken: isTaken,
    BookJsonKeys.dateOfReturning: dateOfReturning,
    BookJsonKeys.takingCount: takingCount,
    };

  String toJsonStr() => toJson.toString();
}