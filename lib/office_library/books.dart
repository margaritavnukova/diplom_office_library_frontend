import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;
import 'book_class.dart';

class MyBooks extends StatefulWidget{
  const MyBooks({super.key});

  @override
  _MyBooks createState() => _MyBooks();
}

class _MyBooks extends State<MyBooks>{

  @override
  Widget build(BuildContext context) {
 
    return Center(
      child: 
        FutureBuilder<List<Book>>(
          future: fetchBooks(), 
          builder: (context, snapshot){
            if (snapshot.connectionState == ConnectionState.waiting){
              return Center(child: CircularProgressIndicator());
            }
            else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            else {
              final books = snapshot.data!;
              return ListView.builder(
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(books[index].Title),
                    subtitle: Text(books[index].Author),
                  );
                }
              );
            }
          }
        )
      );
  }
}

Future<List<Book>> fetchBooks() async {
  final response = await http.get(Uri.parse('https://www.cbr.ru/scripts/XML_daily.asp?date_req=02/03/2002'));
  print('response: ${response.statusCode}');

  if (response.statusCode == 200) {
    final document = xml.XmlDocument.parse(response.body);
    final books = document.findAllElements('Valute');

    // List<Book> returnBooks = [];

    return books.map((node) {
         return Book(
          node.findElements('Name').single.text,
          node.findElements('Value').single.text,
          );
       }).toList();
     } else {
       throw Exception('Failed to load items');
     }

  //   returnBooks.add(Book(
  //     '0',
  //     books.first.getElement('Title').toString(),
  //     books.first.getElement('Author').toString(),
  //     books.first.getElement('Genre').toString(),
  //     books.first.getElement('Year').toString()
  //     )
  //   );
  //   return returnBooks;
  // }
  // else 
  //   { throw Exception('Failed to load books'); }
}

  