import 'package:flutter/material.dart';
import 'package:office_library_backend/office_library/book_class.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
                        title: Text(books[index].title!),
                        subtitle: Text(books[index].author!),
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
    Uri.parse('https://localhost:44319/api/Book'),
    );

  print('response: ${response.statusCode}');


  if (response.statusCode == 200) {
    final respStr = response.body.replaceAll("\"[", "[").replaceAll("]\"", "]").replaceAll("\\", "");
    print('resp = $respStr');
    List<dynamic> jsonResponse = json.decode(respStr);
    List<Book> books = jsonResponse.map((bookJson) => Book.fromJson(bookJson)).toList();

    return books;
     
     } 
     else {
       throw Exception('Failed to load items');
     }
  }
}
