import 'package:flutter/material.dart';
import 'package:office_library_backend/office_library/book_class.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;

class BookList extends StatefulWidget{
  const BookList({super.key});

  @override
  _CounterState createState() => _CounterState();
}

class _CounterState extends State<BookList> {
  Future<List<Book>>? _futureBooks; // Храним результаты Future

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('XML Data'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              // При нажатии кнопки загружаем данные
              setState(() {
                _futureBooks = fetchBooks(); // Инициализация загрузки данных
              });
            },
            child: Text('Загрузить данные'),
          ),
          Expanded(
            child: FutureBuilder<List<Book>>(
              future: _futureBooks,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Ошибка: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('Нет данных'));
                } else {
                  final books = snapshot.data!;

                  return ListView.builder(
                    itemCount: books.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(books[index].Title),
                        subtitle: Text(books[index].Author),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<List<Book>> fetchBooks() async {
  final response = await http.get(
    Uri.parse('https://www.cbr.ru/scripts/XML_daily.asp?date_req=02/03/2002'),
    headers: {'Accept-Charset': 'ascii'}
    );

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
  }
}
