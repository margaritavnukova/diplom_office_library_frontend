import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../assets/strings.dart';
import '../classes/auth.dart';
import '../classes/author_class.dart';
import '../classes/book_class.dart';
import '../classes/delete_data.dart';
import '../classes/fetch_data.dart';
import '../classes/genre_class.dart';
import '../classes/post_data.dart';
import '../classes/put_data.dart';
import 'item_dropdown.dart';
import 'return_book_pade.dart';
import 'take_book_page.dart';

class AddBookPage extends StatefulWidget {
  final Book? book;

  AddBookPage({this.book});

  @override
  _AddBookPageState createState() => _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage> {
  late TextEditingController _titleController = TextEditingController();
  late TextEditingController _yearController = TextEditingController();
  Genre? _selectedGenre;
  Author? _selectedAuthor;
  File? _newImageFile;

  List<Genre> genres = List<Genre>.empty();

  // Создаем маску для ввода даты в формате "2002-02-02"
  final maskFormatter = MaskTextInputFormatter(
    mask: '####',
    filter: {"#": RegExp(r'[0-9]')}, // Разрешаем ввод только цифр
  );

  @override
  void initState() {
    super.initState();
    // Инициализация контроллеров с начальными данными
    if (widget.book != null) {
      _titleController = TextEditingController(text: widget.book?.name);
      _yearController = TextEditingController(text: widget.book?.year.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
  final isAdmin = Auth.hasRole('Admin') || Auth.hasRole('Manager');
  
  return Scaffold(
    appBar: AppBar(
      title: Text('Информация о книге'),
    ),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: isAdmin ? _buildAdminView() : _buildUserView(),
    ),
  );
}

Widget _buildAdminView() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (widget.book?.photoBase64 != null)
            Image(image: widget.book!.coverImage!, height: 300),

      TextField(
        controller: _titleController,
        decoration: InputDecoration(labelText: 'Название книги'),
      ),
      
      GenericDropdown<Genre>(
        futureItems: FetchData.loadData<Genre>(
          UriStrings.addControllerName(UriStrings.getUri, 'Genre'),
          Genre.fromJson,
        ),
        onItemSelected: (Genre? genre) => _selectedGenre = genre,
        label: widget.book?.genre ?? 'Жанр',
      ),
      
      SizedBox(height: 20),
      
      GenericDropdown<Author>(
        futureItems: FetchData.loadData<Author>(
          UriStrings.addControllerName(UriStrings.getUri, 'Author'),
          Author.fromJson,
        ),
        onItemSelected: (Author? author) => _selectedAuthor = author,
        label: widget.book?.author ?? 'Автор',
      ),
      
      TextField(
        controller: _yearController,
        inputFormatters: [maskFormatter],
        decoration: InputDecoration(
          labelText: 'Год (ГГГГ)',
          hintText: '2002',
        ),
        keyboardType: TextInputType.number,
      ),
      
      ElevatedButton(
        onPressed: _saveBook,
        child: Text('Сохранить книгу'),
      ),
      
      ElevatedButton(
        onPressed: _deleteBook,
        child: Text('Удалить книгу'),
      ),

      if (widget.book != null && !widget.book!.isTaken) 
      ElevatedButton(
        onPressed: () async {
         final result = await Navigator.push<bool> (
            context,
            MaterialPageRoute(builder: (context) => TakeBookDialog(book: widget.book!)),
          );
          if (result == true){
            setState(() {});
          }
        },
        child: Text('Взять книгу'),
      ),

      if (widget.book != null && widget.book!.isTaken) 
      ElevatedButton(
        onPressed: () async {
          final result = await Navigator.push<bool>(
            context,
            MaterialPageRoute(builder: (context) => ReturnBookDialog(book: widget.book!)),
          );
          if (result == true){
            setState(() {});
          }
        },
        child: Text('Вернуть книгу'),
      ),
    ],
  );
}

Widget _buildUserView() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      _buildInfoCard('Название книги', widget.book?.name),
      _buildInfoCard('Жанр', widget.book?.genre),
      _buildInfoCard('Автор', widget.book?.author),
      _buildInfoCard('Год издания', widget.book?.year.toString()),
      _buildInfoCard('Дата возврата', widget.book?.plannedReturnDate.toString() ?? "Нет"),

      // Кнопка "Взять книгу"
      if (widget.book != null && !widget.book!.isTaken) 
        ElevatedButton(
          onPressed: () async {
            final result = await Navigator.push<bool>(
              context,
              MaterialPageRoute(builder: (context) => TakeBookDialog(book: widget.book!)),
            );
            if (result == true && mounted) {
              setState(() {});
            }
          },
          child: Text(
            'Взять книгу',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
        ),

      // Кнопка "Вернуть книгу"
      if (widget.book != null && widget.book!.isTaken && 
          widget.book!.currentReader?.email == Auth.user?.email) 
        ElevatedButton(
          onPressed: () async {
            if (!mounted) return;
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ReturnBookDialog(book: widget.book!)),
            );
          },
          child: Text(
            'Вернуть книгу',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
        ),
    ]
  );
}

  Widget _buildInfoCard(String title, String? value) {
    return Card(
      child: Center(
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 8),
            Text(
              value ?? "Не указано",
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }

  _saveBook() async {
    //Логика для сохранения книги
    String title = _titleController.text;
    String author = _selectedAuthor?.name ?? widget.book?.author ?? "Нет автора";
    String genre = _selectedGenre?.name ?? widget.book?.genre ?? "Нет имени";
    String year = _yearController.text;

try {
    // Подготовка данных для отправки
      String? imageBase64;
      if (_newImageFile != null) {
        final bytes = await _newImageFile!.readAsBytes();
        imageBase64 = base64Encode(bytes);
      }

    Book book = Book(
      id: widget.book?.id ?? '-1', 
      name: title, 
      author: author, 
      genre: genre, 
      year: DateTime.parse(year), 
      readers: widget.book?.readers ?? [], 
      isTaken: widget.book?.isTaken ?? false,
      takingCount: widget.book?.takingCount ?? 0,
      plannedReturnDate: widget.book?.plannedReturnDate,
      photoBase64: imageBase64,
    );
    if (widget.book == null) {
      post(book);
    } else {
      put(book);
    }

    if (mounted && !Navigator.of(context).userGestureInProgress) Navigator.pop(context/* , true */); // Возвращаем true как флаг успешного обновления
    } 
    catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка при сохранении: $e')),
      );
    } 
  }

  _deleteBook() {
    // Логика для удаления книги
    if (widget.book != null) {
        delete(widget.book!);
      }

    Navigator.pop(context);
  }

  ImageProvider? _getAvatarImage() {
    if (_newImageFile != null) {
      return FileImage(_newImageFile!);
    } else if (widget.book?.photoBase64 != null) {
      return MemoryImage(base64Decode(widget.book!.photoBase64!));
    } else {
      return AssetImage('assets/images/default_avatar.png');
    }
  }

  void put(Book book){
    final putData = PutData<Book>(Book.fromJson);
    putData.putItem(UriStrings.addControllerName(UriStrings.putByIdUri, 'Book'), book);
  }

  void post(Book book){
    final postData = PostData<Book>();
    postData.postItem(UriStrings.addControllerName(UriStrings.postUri, 'Book'), book);
  }

  void delete(Book book){
    final deleteData = DeleteData<Book>(Book.fromJson);
    deleteData.deleteItem(UriStrings.addControllerName(UriStrings.deleteByIdUri, 'Book'), book.id!);
  }
}