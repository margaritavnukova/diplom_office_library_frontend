import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../assets/strings.dart';
import '../classes/auth.dart';
import '../classes/author_class.dart';
import '../classes/book_class.dart';
import '../classes/delete_data.dart';
import '../classes/fetch_data.dart';
import '../classes/genre_class.dart';
import '../classes/item_base_class.dart';
import '../classes/post_data.dart';
import '../classes/put_data.dart';
import 'item_dropdown.dart';
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
  String? _photoPath;

  List<Genre> genres = List<Genre>.empty();

  // Создаем маску для ввода даты в формате "2002-02-02"
  final maskFormatter = MaskTextInputFormatter(
    mask: '####-##-##',
    filter: {"#": RegExp(r'[0-9]')}, // Разрешаем ввод только цифр
  );

  @override
  void initState() {
    super.initState();
    // Инициализация контроллеров с начальными данными
    if (widget.book != null) {
      _titleController = TextEditingController(text: widget.book?.name);
      _yearController = TextEditingController(text: widget.book?.year.toString());
      _photoPath = widget.book?.name;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Информация о книге'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (Auth.hasRole('Admin') || Auth.hasRole('Manager'))
              TextField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Название книги'),
              ),

            if (Auth.hasRole('User'))
             Text(
              widget.book?.name ?? "Нет названия"
             ),
            
            if (Auth.hasRole('Admin') || Auth.hasRole('Manager'))
              GenericDropdown<Genre>(
                futureItems: FetchData.loadData<Genre>(
                  UriStrings.addControllerName(UriStrings.getUri, 'Genre'),
                  Genre.fromJson, // Фабричный метод для Genre
                ),
                onItemSelected: (Genre? genre) {
                  // setState(() {
                    _selectedGenre = genre;
                  // });
                },
                label: widget.book?.genre ?? 'Жанр',
              ),
            
            if (Auth.hasRole('User'))
              Text(
                widget.book?.genre ?? "Нет жанра"
              ),

            SizedBox(height: 20),
            
            if (Auth.hasRole('Admin') || Auth.hasRole('Manager'))
              GenericDropdown<Author>(
                futureItems: FetchData.loadData<Author>(
                  UriStrings.addControllerName(UriStrings.getUri, 'Author'),
                  Author.fromJson, // Фабричный метод для Author
                ),
                onItemSelected: (Author? author) {
                  // setState(() {
                    _selectedAuthor = author;
                  // });
                },
                label: widget.book?.author ?? 'Автор',
              ),
            
            if (Auth.hasRole('User'))
              Text(
                widget.book?.author ?? "Нет автора"
              ),

            if (Auth.hasRole('Admin') || Auth.hasRole('Manager'))
            TextField(
              controller: _yearController,
              inputFormatters: [maskFormatter], // Применяем маску
              decoration: InputDecoration(
                labelText: 'Дата (ГГГГ-ММ-ДД)',
                hintText: '2002-02-02',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number, // Цифровая клавиатура
            ),

            if (Auth.hasRole('User'))
             Text(
              widget.book?.year.toString() ?? "Нет года"
             ),

            if (Auth.hasRole('Admin') || Auth.hasRole('Manager'))
              ElevatedButton(
                onPressed: () {
                  // Логика для сохранения книги
                  String title = _titleController.text;
                  String author = _selectedAuthor?.name ?? widget.book?.author ?? "Нет автора";
                  String genre = _selectedGenre?.name ?? widget.book?.genre ?? "Нет имени";
                  String year = _yearController.text;

                  Book book = Book(
                    id: widget.book?.id ?? '-1', 
                    name: title, 
                    author: author, 
                    genre: genre, 
                    year: DateTime.parse(year), 
                    readers: widget.book?.readers ?? [], 
                    isTaken: widget.book?.isTaken ?? false,
                    takingCount: widget.book?.takingCount ?? 0,
                    dateOfReturning: widget.book?.dateOfReturning);
                  if (widget.book == null) {
                    post(book);
                  } else {
                    put(book);
                  }

                  Navigator.pop(context);
                },
                child: Text('Сохранить книгу'),
              ),

            if (Auth.hasRole('Admin') || Auth.hasRole('Manager'))
              ElevatedButton(
                onPressed: () {
                  // Логика для сохранения книги

                  if (widget.book == null) {
                    // post(book);
                  } else {
                    delete(widget.book!);
                  }

                  Navigator.pop(context);
                },
                child: Text('Удалить книгу'),
              ),

            if (widget.book != null) 
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TakeBookDialog(book: widget.book!)),
                  );
                },
                child: Text('Взять книгу'),
              ),
          ],
        ),
      ),
    );
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