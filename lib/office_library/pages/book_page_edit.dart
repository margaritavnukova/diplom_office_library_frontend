import 'package:flutter/material.dart';
import 'package:office_library_backend/office_library/classes/book_class.dart';

import '../assets/strings.dart';
import '../classes/delete_data.dart';

class EditBookPage extends StatefulWidget {
  final Book book;

  EditBookPage({required this.book});

  @override
  _EditBookPageState createState() => _EditBookPageState();
}

class _EditBookPageState extends State<EditBookPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _authorController;
  late TextEditingController _genreController;
  late TextEditingController _yearController;
  late TextEditingController _photoUrlController;

  @override
  void initState() {
    super.initState();
    // Инициализация контроллеров с начальными данными
    _titleController = TextEditingController(text: widget.book.title);
    _authorController = TextEditingController(text: widget.book.author);
    _genreController = TextEditingController(text: widget.book.genre);
    _yearController = TextEditingController(text: widget.book.year.toString());
    _photoUrlController = TextEditingController(text: widget.book.title);
  }

  @override
  void dispose() {
    // Освобождение ресурсов
    _titleController.dispose();
    _authorController.dispose();
    _genreController.dispose();
    _yearController.dispose();
    _photoUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Редактировать книгу'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Название'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введите название';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _authorController,
                decoration: InputDecoration(labelText: 'Автор'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введите автора';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _genreController,
                decoration: InputDecoration(labelText: 'Жанр'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введите жанр';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _yearController,
                decoration: InputDecoration(labelText: 'Год'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введите год';
                  }
                  if (DateTime.tryParse(value) == null) {
                    return 'Введите корректный год';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _photoUrlController,
                decoration: InputDecoration(labelText: 'Ссылка на фото'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введите ссылку на фото';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Сохранение данных
                    final Book updatedBookData = Book(
                      id: widget.book.id,
                      title: _titleController.text,
                      author: _authorController.text,
                      genre: _genreController.text,
                      year: DateTime.parse(_yearController.text),
                      readers: [],
                      isTaken: false
                    );
                    // Возвращаем данные на предыдущую страницу
                    Navigator.pop(context, updatedBookData);
                  }
                },
                child: Text('Сохранить'),
              ),

              ElevatedButton(
                onPressed: () {
                  var deleteData = DeleteData<Book>(Book.fromJson);
                  // разница здесь
                  deleteData.deleteItem(UriStrings.deleteBookUri, widget.book.id!);

                  Navigator.pop(context);
                },
                child: Text('Удалить'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}