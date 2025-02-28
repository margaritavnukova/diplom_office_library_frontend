import 'package:flutter/material.dart';
import 'package:office_library_backend/office_library/classes/book_class.dart';
import '../classes/reader_class.dart';

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
                        reader['Email'] ?? 'Email is missing', 
                        style: TextStyle(fontSize: 16),
                        )
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
