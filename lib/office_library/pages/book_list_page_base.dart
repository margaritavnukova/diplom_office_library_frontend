import 'package:flutter/material.dart';
import 'package:office_library_backend/office_library/classes/book_class.dart';
import '../assets/strings.dart';
import '../classes/put_data.dart';
import 'book_page_add.dart';
import 'book_page_edit.dart';
import 'book_page_single.dart';
import '../classes/fetch_data.dart';

class BookList extends StatefulWidget{
  final String uri;
  BookList({super.key, required this.uri});

  @override
  _CounterState createState() => _CounterState();
}

class _CounterState extends State<BookList> {
  Future<List<Book>>? _futureBooks; // Храним результаты Future

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Книги'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              // При нажатии кнопки загружаем данные
              setState(() async {
                var fetchData = FetchData<Book>(Book.fromJson);
                // разница здесь
                var books = fetchData.fetchList(widget.uri);
                _futureBooks = await Future.value(books);
              });
            },
            child: Text('Загрузить данные'),
          ),

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
                      return GestureDetector(
                        onDoubleTap: () async {
                           final updatedBookData = await Navigator.push<Book>(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditBookPage(book: books[index]),
                            ),
                          );
                          if (updatedBookData != null) {
                            books[index] = updatedBookData;

                            var putData = PutData<Book>(Book.fromJson);
                            // разница здесь
                            putData.putItem(UriStrings.putBookUri, updatedBookData.id ?? 0, updatedBookData);

                            // Здесь можно добавить логику для обновления UI
                            print('Обновленные данные книги: $updatedBookData');
                          }
                        },
                        child: ListTile(
                          title: Text(books[index].title),
                          subtitle: Text(books[index].author),
                        ),
                      );
                    }
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
