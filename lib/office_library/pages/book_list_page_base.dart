import 'package:flutter/material.dart';
import 'package:office_library_backend/office_library/classes/book_class.dart';
import '../assets/strings.dart';
import '../classes/auth.dart';
import '../classes/put_data.dart';
import 'single_book_page.dart';
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
              onPressed: () async {
             final result = await Navigator.push<bool>(
                  context,
                  MaterialPageRoute(builder: (context) => AddBookPage()),
                );
                if (result == true) {
                  // Обновляем данные, если редактирование успешно
                  setState(() {});
                }
              },
              child: Text('Добавить новую книгу'),
            ),

////////////////////////////////////////////
          Expanded(
  child: FutureBuilder<List<Book>>(
    future: _futureBooks,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Загрузка книг...'),
            ],
          ),
        );
      } else if (snapshot.hasError) {
        return Center(child: Text('Ошибка: ${snapshot.error}'));
      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return Center(child: Text('Нет данных'));
      } else {
        final currentUser = Auth.user;
        final allBooks = snapshot.data!;
        
        // 1. Книги, взятые текущим пользователем
        final myTakenBooks = allBooks.where((b) => 
          b.isTaken && b.currentReader?.id == currentUser.id).toList();
        
        // 2. Другие взятые книги (не текущим пользователем)
        final otherTakenBooks = allBooks.where((b) => 
          b.isTaken && b.currentReader?.id != currentUser.id).toList();
        
        // 3. Доступные книги
        final availableBooks = allBooks.where((b) => !b.isTaken).toList();

        // Вычисляем общее количество элементов (книги + разделители)
        final itemCount = myTakenBooks.length + 
                        otherTakenBooks.length + 
                        availableBooks.length +
                        (myTakenBooks.isNotEmpty && otherTakenBooks.isNotEmpty ? 1 : 0) +
                        (otherTakenBooks.isNotEmpty && availableBooks.isNotEmpty ? 1 : 0);

        return ListView.builder(
          itemCount: itemCount,
          itemBuilder: (context, index) {
            // Проверяем, является ли текущий индекс разделителем
            if (myTakenBooks.isNotEmpty && 
                otherTakenBooks.isNotEmpty && 
                index == myTakenBooks.length) {
              return _buildDivider("Другие взятые книги");
            }
            
            if (otherTakenBooks.isNotEmpty && 
                availableBooks.isNotEmpty && 
                index == myTakenBooks.length + otherTakenBooks.length + (myTakenBooks.isNotEmpty && otherTakenBooks.isNotEmpty ? 1 : 0)) {
              return _buildDivider("Доступные книги");
            }
            
            // Определяем книгу
            Book book;
            if (index < myTakenBooks.length) {
              book = myTakenBooks[index];
            } 
            else if (index < myTakenBooks.length + otherTakenBooks.length + (myTakenBooks.isNotEmpty && otherTakenBooks.isNotEmpty ? 1 : 0)) {
              final adjustedIndex = index - myTakenBooks.length - (myTakenBooks.isNotEmpty && otherTakenBooks.isNotEmpty ? 1 : 0);
              book = otherTakenBooks[adjustedIndex];
            }
            else {
              final adjustedIndex = index - myTakenBooks.length - otherTakenBooks.length - 
                                  (myTakenBooks.isNotEmpty && otherTakenBooks.isNotEmpty ? 1 : 0) - 
                                  (otherTakenBooks.isNotEmpty && availableBooks.isNotEmpty ? 1 : 0);
              book = availableBooks[adjustedIndex];
            }

            return GestureDetector(
              onDoubleTap: () async {
                final updatedBookData = await Navigator.push<Book>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddBookPage(book: book),
                  ),
                );
                if (updatedBookData != null) {
                  setState(() {
                    _loadData(); // Перезагружаем данные
                  });
                  var putData = PutData<Book>(Book.fromJson);
                  putData.putItem(
                    UriStrings.addControllerName(UriStrings.putByIdUri, 'Book'), 
                    updatedBookData
                  );
                }
              },
              child: ListTile(
                title: Text(book.name ?? "Нет названия"),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(book.author),
                    if (book.isTaken)
                      Text(
                        'Взята ${book.currentReader?.id == currentUser.id ? "вами" : book.currentReader?.name ?? "неизвестным"}',
                        style: TextStyle(
                          color: book.currentReader?.id == currentUser.id 
                            ? Colors.blue 
                            : Colors.red,
                        ),
                      ),
                    if (book.isTaken && book.plannedReturnDate != null)
                      Text(
                        'Вернуть до: ${(book.plannedReturnDate!)}',
                        style: TextStyle(fontSize: 12),
                      ),
                  ],
                ),
                trailing: book.isTaken 
                  ? Icon(
                      Icons.bookmark,
                      color: book.currentReader?.id == currentUser.id 
                        ? Colors.blue 
                        : Colors.red,
                    )
                  : Icon(Icons.bookmark_border, color: Colors.green),
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
// Вспомогательный метод для создания разделителя
Widget _buildDivider(String title) {
  return Column(
    children: [
      Divider(thickness: 2),
      Padding(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey[600],
          ),
        ),
      ),
    ],
  );
}