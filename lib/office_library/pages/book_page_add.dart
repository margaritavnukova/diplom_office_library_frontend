import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../assets/strings.dart';
import '../classes/author_class.dart';
import '../classes/book_class.dart';
import '../classes/fetch_data.dart';
import '../classes/genre_class.dart';
import '../classes/item_base_class.dart';
import '../classes/post_data.dart';
import 'item_dropdown.dart';

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
        title: Text('Добавить новую книгу'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Название книги'),
            ),
            
            GenericDropdown<Genre>(
              futureItems: _loadData<Genre>(
                UriStrings.addControllerName(UriStrings.getUri, 'Genre'),
                Genre.fromJson, // Фабричный метод для Genre
              ),
              onItemSelected: (Genre? genre) {
                setState(() {
                  _selectedGenre = genre;
                });
              },
              label: 'Жанр',
            ),
            SizedBox(height: 20),
            GenericDropdown<Author>(
              futureItems: _loadData<Author>(
                UriStrings.addControllerName(UriStrings.getUri, 'Author'),
                Author.fromJson, // Фабричный метод для Author
              ),
              onItemSelected: (Author? author) {
                setState(() {
                  _selectedAuthor = author;
                });
              },
              label: 'Автор',
            ),
            
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
            // Здесь можно добавить функционал для выбора/загрузки фото
            ElevatedButton(
              onPressed: () {
                // Логика для сохранения книги
                String title = _titleController.text;
                String author = _selectedAuthor?.name ?? "Нет автора";
                String genre = _selectedGenre?.name ?? "Нет имени";
                String year = _yearController.text;

                Book book = Book(name: title, author: author, genre: genre, year: DateTime.parse(year), readers: [], isTaken: false);
                final postData = PostData<Book>();
                postData.postItem(UriStrings.addControllerName(UriStrings.postUri, 'Book'), book);

                Navigator.pop(context);
              },
              child: Text('Сохранить книгу'),
            ),
          ],
        ),
      ),
    );
  }
  
  // Метод для загрузки данных
  Future<List<T>> _loadData<T extends Item>(String uri, T Function(Map<String, dynamic>) fromJson) async {
  try {
    var fetchData = FetchData<T>(fromJson);
    return await fetchData.fetchList(uri); // Возвращаем Future<List<T>>
    } catch (e) {
      throw Exception('Ошибка загрузки данных: $e');
    }
  }
}