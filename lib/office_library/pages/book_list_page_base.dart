import 'dart:convert';

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
  Future<List<Book>>? _futureBooks;
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

   @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadData() async {
    setState(() {
      _futureBooks = null;
    });

    try {
      var fetchData = FetchData<Book>(Book.fromJson);
      var books = await fetchData.fetchList(UriStrings.addControllerName(widget.uri, 'Book'));
      setState(() {
        _futureBooks = Future.value(books);
      });
    } catch (e) {
      setState(() {
        _futureBooks = Future.error(e);
      });
    }

    if (_futureBooks == null) {
      
    }
  }

  // Фильтрация книг по поисковому запросу
  List<Book> _filterBooks(List<Book> allBooks) {
    if (_searchQuery.isEmpty) return allBooks;
    
    return allBooks.where((book) => 
      book.name?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false).toList();
  }

  Widget _buildBookImage(Book book) {
    return Container(
      width: 60, // Фиксированная ширина для изображения
      height: 90, // Фиксированная высота для изображения
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.deepPurple[100],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: book.photoBase64 != null
            ? Image.memory(
                base64Decode(book.photoBase64!),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
              )
            : _buildPlaceholder(),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: Colors.grey[200],
      child: Center(
        child: Icon(
          Icons.menu_book,
          size: 30,
          color: Colors.grey[600],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[100],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.menu_book, color: Colors.deepPurple),
            SizedBox(width: 10),
            Text(
              'Книги',
              style: TextStyle(
                fontFamily: 'Bookman Old Style',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple[900],
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.deepPurple[50],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                // Поле поиска (занимает всё свободное пространство)
                Expanded(
                  flex: 3, // Задаём соотношение 3:1:1
                  child: Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Поиск по названию...',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      ),
                      onChanged: (value) => setState(() => _searchQuery = value),
                    ),
                  ),
                ),
                // Кнопка обновления
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: _buildActionButton(
                      Icons.refresh,
                      'Обновить',
                      Colors.deepPurple,
                      _loadData,
                    ),
                  ),
                ),
                // Кнопка добавления (если есть права)
                if (Auth.hasRole('Admin') || Auth.hasRole('Manager'))
                  Expanded(
                    flex: 1,
                    child: _buildActionButton(
                      Icons.add,
                      'Добавить',
                      Colors.green,
                      () async {
                        final result = await Navigator.push<bool>(
                          context,
                          MaterialPageRoute(builder: (context) => AddBookPage()),
                        );
                        if (result == true) _loadData();
                      },
                    ),
                  ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<Book>>(
                future: _futureBooks,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            color: Colors.deepPurple,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Загрузка книг...',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Ошибка: ${snapshot.error}',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 16,
                          color: Colors.red,
                        ),
                      ),
                    );
                  } else if (!snapshot.hasData) {
                    return Center(
                      child: Text(
                        'Нет данных',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 24,
                        ),
                      ),
                    );
                  } else if (snapshot.data!.isEmpty) {
                    return Center(
                      child: Text(
                        'Нет истории прочитанного',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 24,
                        ),
                      ),
                    );
                  } else {
                     final currentUser = Auth.user;
                    final allBooks = _filterBooks(snapshot.data!);
                    
                    final myTakenBooks = allBooks.where((b) => 
                      b.isTaken && b.currentReader?.id == currentUser.id).toList();
                    
                    final otherTakenBooks = allBooks.where((b) => 
                      b.isTaken && b.currentReader?.id != currentUser.id).toList();
                    
                    final availableBooks = allBooks.where((b) => !b.isTaken).toList();

                    final itemCount = myTakenBooks.length + 
                                    otherTakenBooks.length + 
                                    availableBooks.length +
                                    (myTakenBooks.isNotEmpty && otherTakenBooks.isNotEmpty ? 1 : 0) +
                                    (otherTakenBooks.isNotEmpty && availableBooks.isNotEmpty ? 1 : 0);

                    return ListView.builder(
                      itemCount: itemCount,
                      itemBuilder: (context, index) {
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
                          onDoubleTap: () {
                            if (!book.isDeleted || Auth.hasRole('Admin')) {
                              _openBookDetails(context, book);
                            }
                          },
                          child: Card(
                            elevation: (book.isDeleted && !Auth.hasRole('Admin')) ? 2 : 4,
                            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            color: book.isDeleted ? Colors.deepPurple[50] : Colors.white,
                            child: Container(
                              padding: EdgeInsets.all(16),
                              height: 150,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                // Блок с изображением книги
                                _buildBookImage(book),
                                SizedBox(width: 12),
                                
                                // Левая часть - Название книги
                                Expanded(
                                  flex: 2,
                                  child: Center(
                                    child: Text(
                                      book.name ?? "Нет названия",
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: 20, // Чуть уменьшили размер
                                        fontWeight: FontWeight.bold,
                                        color: book.isDeleted ? Colors.deepPurple[800] : Colors.black,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                
                                VerticalDivider(
                                  thickness: 1,
                                  width: 20,
                                  color: Colors.grey[300],
                                ),
                                
                                // Правая часть - Детали книги
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      MouseRegion(
                                        cursor: (book.isDeleted && !Auth.hasRole('Admin')) 
                                          ? SystemMouseCursors.basic 
                                          : SystemMouseCursors.click,
                                        child: Tooltip(
                                          message: '${book.author?.lifetime ?? "Не указано"}\n${book.author?.country ?? "Не указано"}',
                                          child: Text(
                                            book.author?.name ?? "Неизвестный автор",
                                            style: TextStyle(
                                              fontFamily: 'Roboto',
                                              fontSize: 16, // Чуть уменьшили размер
                                              color: book.isDeleted ? Colors.deepPurple[600] : Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      MouseRegion(
                                        cursor: book.isDeleted 
                                          ? SystemMouseCursors.basic 
                                          : SystemMouseCursors.click,
                                        child: Tooltip(
                                          message: book.genre?.description ?? "Описание жанра отсутствует",
                                          child: Text(
                                            book.genre?.name ?? "Неизвестный жанр",
                                            style: TextStyle(
                                              fontFamily: 'Roboto',
                                              fontSize: 14, // Чуть уменьшили размер
                                              color: book.isDeleted ? Colors.deepPurple[500] : Colors.grey[700],
                                            ),
                                          ),
                                        ),
                                      ),
                                      if (book.isTaken && !book.isDeleted) ...[
                                        SizedBox(height: 4),
                                        Text(
                                          'Взята ${book.currentReader?.id == currentUser.id ? "вами" : book.currentReader?.name ?? "неизвестным"}',
                                          style: TextStyle(
                                            fontFamily: 'Roboto',
                                            fontSize: 14,
                                            color: book.currentReader?.id == currentUser.id 
                                              ? Colors.blue 
                                              : Colors.red,
                                          ),
                                        ),
                                      ],
                                      if (book.isTaken && book.plannedReturnDate != null && !book.isDeleted) ...[
                                        SizedBox(height: 4),
                                        Text(
                                          'Вернуть до: ${book.plannedReturnDate!.toLocal().toString().split(' ')[0]}',
                                          style: TextStyle(
                                            fontFamily: 'Roboto',
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                      if (book.isDeleted) ...[
                                        SizedBox(height: 4),
                                        Text(
                                          'Архивная книга',
                                          style: TextStyle(
                                            fontFamily: 'Roboto',
                                            fontSize: 14,
                                            color: Colors.deepPurple[700],
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                                
                                Container(
                                  width: 6, // Сделали тоньше
                                  margin: EdgeInsets.only(left: 8),
                                  decoration: BoxDecoration(
                                    color: book.isDeleted 
                                      ? Colors.black 
                                      : book.isTaken 
                                        ? (book.currentReader?.id == currentUser.id 
                                            ? Colors.blue 
                                            : Colors.red)
                                        : Colors.green,
                                    borderRadius: BorderRadius.horizontal(
                                      right: Radius.circular(12),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              }
            )
          )
        ]
      )
    )
  );
}

  Widget _buildActionButton(IconData icon, String text, Color color, VoidCallback onPressed) {
    return ElevatedButton.icon(
      icon: Icon(icon, size: 24, color: Colors.white),
      label: Text(
        text,
        style: TextStyle(
          fontFamily: 'Roboto',
          fontSize: 16,
          color: Colors.white
        ),
      ),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        minimumSize: Size(160, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  Widget _buildDivider(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Divider(
            thickness: 2,
            color: Colors.deepPurple[200],
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text(
              title,
              style: TextStyle(
                fontFamily: 'Bookman Old Style',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple[800],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openBookDetails(BuildContext context, Book book) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddBookPage(book: book),
      ),
    ).then((value) {
      if (value == true) {
        _loadData(); // Обновляем список, если книга была изменена
      }
    });
  }
}