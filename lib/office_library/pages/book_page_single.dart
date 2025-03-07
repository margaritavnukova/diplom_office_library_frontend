import 'package:flutter/material.dart';
import '../classes/book_class.dart';
import '../assets/strings.dart';

class BookDetailPage extends StatelessWidget {
  final Book book;
  final noReadersException = "No readers yet";

  const BookDetailPage({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(book.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Author: ${book.author}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Title: ${book.title}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Genre: ${book.genre}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Year: ${book.year.year}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),

            if (book.readers.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Readers:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                if (book.readers.isNotEmpty)
                  for (var reader in book.readers) 
                    if (reader is Map) 
                      Text(
                        reader[UserJsonKeys.email] ?? 'Email is missing', 
                        style: TextStyle(fontSize: 16),
                        )
                ],
            ),
          ],
        ),
      ),
    );
  }
}
