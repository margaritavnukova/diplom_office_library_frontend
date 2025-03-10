import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../classes/book_class.dart';
import '../classes/post_data.dart';

class AddBookPage extends StatefulWidget {
  @override
  _AddBookPageState createState() => _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  String? _selectedGenre;
  String? _photoPath;

  // Создаем маску для ввода даты в формате "2002-02-02"
  final maskFormatter = MaskTextInputFormatter(
    mask: '####-##-##',
    filter: {"#": RegExp(r'[0-9]')}, // Разрешаем ввод только цифр
  );

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
            DropdownButtonFormField<String>(
              value: _selectedGenre,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedGenre = newValue;
                });
              },
              //fetch data
              items: <String>['Фантастика', 'Научная', 'Драма', 'Комедия']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: InputDecoration(labelText: 'Жанр'),
            ),
            TextField(
              controller: _authorController,
              decoration: InputDecoration(labelText: 'Автор'),
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
            ),
            // Здесь можно добавить функционал для выбора/загрузки фото
            ElevatedButton(
              onPressed: () {
                // Логика для сохранения книги
                String title = _titleController.text;
                String author = _authorController.text;
                String genre = _selectedGenre!;
                String year = _yearController.text;

                Book book = new Book(title: title, author: author, genre: genre, year: DateTime.parse(year), readers: [], isTaken: false);
                final postData = PostData<Book>(book.toJson);

                Navigator.pop(context);
              },
              child: Text('Сохранить книгу'),
            ),
          ],
        ),
      ),
    );
  }
}
