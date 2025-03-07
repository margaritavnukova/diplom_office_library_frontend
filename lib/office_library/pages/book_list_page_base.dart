import 'package:flutter/material.dart';
import 'package:office_library_backend/office_library/classes/book_class.dart';
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
                        onDoubleTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BookDetailPage(book: books[index]),
                            ),
                          );
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
