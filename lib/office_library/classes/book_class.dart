import 'item_base_class.dart';
import '../assets/strings.dart';
import 'post_data.dart';
import 'reader_class.dart';

class Book implements Item {
  @override 
  String? id;
  final String author;
  @override 
  String? name;
  final String genre;
  final DateTime year;
  final List<dynamic> readers;
  final bool isTaken;
  final DateTime? dateOfReturning;
  final int? takingCount;
  final Reader? currentReader;

  Book({
    this.id = "",
    required this.author,
    required this.name,
    required this.genre,
    required this.year,
    required this.readers,
    required this.isTaken,
    this.dateOfReturning,
    this.takingCount,
    this.currentReader
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
      dateOfReturning: json[BookJsonKeys.dateOfReturning] != null
          ? DateTime.parse(json[BookJsonKeys.dateOfReturning])
          : null,
      takingCount: json[BookJsonKeys.takingCount],
      currentReader: json[BookJsonKeys.currentReader] != null
        ? Reader.fromJson(json[BookJsonKeys.currentReader])
        : null
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      BookJsonKeys.id: id,
      BookJsonKeys.author: author,
      BookJsonKeys.title: name,
      BookJsonKeys.genre: genre,
      BookJsonKeys.year: year.toIso8601String(), // toIso8601String для корректного формата
    };
  }

  String toJsonStr() => toJson().toString();

  Book takeBook(Reader reader, DateTime returnDate) {
    readers.add(reader);

    Book book = Book(
      id: id,
      author: author,
      name: name,
      genre: genre,
      year: year,
      readers: readers,
      isTaken: true,
      dateOfReturning: returnDate,
      takingCount: takingCount ?? 1,
      currentReader: reader
    );

    return book;
  }
}
