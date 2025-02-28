import 'package:flutter/material.dart';
import 'package:office_library_backend/office_library/classes/book_class.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BookDetailPage extends StatelessWidget {
  final Book book;

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
                for (var reader in book.readers)
                  Text(reader.email),
              ],
            ),

            // Text(
            //   'Readers: ${book.readersStrList}',
            //   style: TextStyle(fontSize: 18),
            // ),

            // ListView.builder(
            //   itemCount: book.readers.length,
            //   itemBuilder: (context, index) {
                // return GestureDetector(
                //   onDoubleTap: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => BookDetailPage(readers: [index]),
                //       ),
                //     );
                //   },

                  // return ListTile(
                  //   title: Text(book.readers[index].id.toString()),
                  //   subtitle: Text(book.readers[index].email),
                  // );
              // }
            // )
          ],
        ),
      ),
    );
  }
}
