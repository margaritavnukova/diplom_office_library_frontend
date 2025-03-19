import 'package:flutter/material.dart';
import 'package:office_library_backend/office_library/classes/book_class.dart';
import '../assets/strings.dart';
import '../classes/auth.dart';
import '../classes/put_data.dart';
import 'book_page_add.dart';
import '../classes/fetch_data.dart';

class BookList extends StatefulWidget {
  final String uri;
  BookList({super.key, required this.uri});

  @override
  _CounterState createState() => _CounterState();
}

class _CounterState extends State<BookList> {
  Future<List<Book>>? _futureBooks; // Храним результаты Future

  // Метод для загрузки данных
  void _loadData() async {
    setState(() {
      _futureBooks = null; // Сбрасываем Future, чтобы показать индикатор загрузки
    });

    try {
      var fetchData = FetchData<Book>(Book.fromJson);
      var books = await fetchData.fetchList(UriStrings.addControllerName(widget.uri, 'Book')); // Ждем завершения запроса
      setState(() {
        _futureBooks = Future.value(books); // Обновляем Future
      });
    } catch (e) {
      setState(() {
        _futureBooks = Future.error(e); // Обрабатываем ошибку
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Книги'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: _loadData, // Используем метод _loadData
            child: Text('Загрузить данные'),
          ),

          if (Auth.hasRole('Admin') || Auth.hasRole('Manager')) 
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddBookPage()),
                );
              },
              child: Text('Добавить новую книгу'),
            ),

          Expanded(
            child: FutureBuilder<List<Book>>(
              future: _futureBooks,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(), // Индикатор загрузки
                        SizedBox(height: 16), // Отступ
                        Text('Загрузка книг...'), // Текст под индикатором
                      ],
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('Ошибка: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('Нет данных'));
                } else {
                  final books = snapshot.data!;

                  return ListView.builder(
                    itemCount: books.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onDoubleTap: () async {
                          final updatedBookData = await Navigator.push<Book>(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddBookPage(book: books[index]),
                            ),
                          );
                          if (updatedBookData != null) {
                            setState(() {
                              books[index] = updatedBookData;
                            });

                            var putData = PutData<Book>(Book.fromJson);
                            putData.putItem(UriStrings.addControllerName(UriStrings.putByIdUri, 'Book'), updatedBookData);

                            print('Обновленные данные книги: $updatedBookData');
                            }
                        },
                        child: ListTile(
                          title: Text(books[index].name ?? "Нет названия"),
                          subtitle: Text(books[index].author),
                        ),
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
}