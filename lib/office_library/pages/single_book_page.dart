import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
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

  final yearMaskFormatter = MaskTextInputFormatter(
    mask: '####-##-##',
    filter: {"#": RegExp(r'[0-9]')},
  );

  @override
  void initState() {
    super.initState();
    if (widget.book != null) {
      _titleController = TextEditingController(text: widget.book?.name);
      _yearController = TextEditingController(text: widget.book?.year.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAdmin = (Auth.hasRole('Admin') || Auth.hasRole('Manager'));
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[100],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.menu_book, color: Colors.deepPurple),
            SizedBox(width: 10),
            Text(
              widget.book == null ? 'Добавить книгу' : 'Детали о книге',
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
        child: isAdmin ? _buildAdminView() : _buildUserView(),
      ),
    );
  }

  Widget _buildAdminView() {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Адаптивный layout для изображения и полей
              LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth > 600) {
                    // Горизонтальное расположение на широких экранах
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Изображение с фиксированной шириной
                        SizedBox(
                          width: 350,
                          child: Column(
                            children: [
                              _buildImageSection(),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: _pickImage,
                                child: const Text('Загрузить изображение'),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 20),
                        // Поля ввода с возможностью расширения
                        Expanded(
                          child: _buildFieldsColumn(),
                        ),
                      ],
                    );
                  } else {
                    // Вертикальное расположение на узких экранах
                    return Column(
                      children: [
                        _buildImageSection(),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _pickImage,
                          child: const Text('Загрузить изображение'),
                        ),
                        const SizedBox(height: 20),
                        _buildFieldsColumn(),
                      ],
                    );
                  }
                },
              ),
              const SizedBox(height: 30),
              // Кнопки действий
              ..._buildActionButtonsAdmin(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserView() {
    return SingleChildScrollView(
  child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      children: [
        // Блок с изображением и информацией
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 600) {
              // Горизонтальное расположение на широких экранах
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Блок с изображением (20% ширины экрана)
                  if (widget.book?.photoBase64 != null)
                    SizedBox(
                      width: constraints.maxWidth * 0.2,
                      height: constraints.maxWidth * 0.3,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.deepPurple[100],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: _buildBookImage(),
                        ),
                      ),
                    ),
                  const SizedBox(width: 20),
                  // Блок с информацией
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _buildBookInfoCards(),
                    ),
                  ),
                ],
              );
            } else {
              // Вертикальное расположение на узких экранах
              return Column(
                children: [
                  if (widget.book?.photoBase64 != null)
                    Container(
                      width: constraints.maxWidth * 0.6,
                      height: constraints.maxWidth * 0.9,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.deepPurple[100],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: _buildBookImage(),
                      ),
                    ),
                  const SizedBox(height: 20),
                  ..._buildBookInfoCards(),
                ],
              );
            }
          },
        ),
        // Кнопки действий
        ..._buildActionButtons(),
      ],
    ),
  ),
);

  }

  Widget _buildTextFieldWithIcon(IconData icon, String label, 
      TextEditingController controller, {
      List<TextInputFormatter>? formatters,
      String? hintText,
      TextInputType? keyboardType,
    }) {
    return TextField(
      controller: controller,
      inputFormatters: formatters,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      keyboardType: keyboardType,
    );
  }

  Widget _buildInfoCard(IconData icon, String title, String? value) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, size: 28, color: Colors.deepPurple),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    value ?? "Не указано",
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String text, Color color, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: Icon(icon, size: 24, color: Colors.white),
        label: Text(
          text,
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 18,
            color: Colors.white
          ),
        ),
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          minimumSize: Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        ),
      ),
    );
  }

   Widget _buildBookImage() {
    if (_newImageFile != null) {
      return Image.file(_newImageFile!, fit: BoxFit.cover);
    } else if (widget.book?.photoBase64 != null) {
      return Image.memory(
        base64Decode(widget.book!.photoBase64!),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
      );
    } else {
      return _buildPlaceholder();
    }
  }

   Widget _buildImageSection({bool readOnly = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Блок с изображением (1/5 ширины экрана)
        Container(
          width: MediaQuery.of(context).size.width * 0.2,
          height: MediaQuery.of(context).size.width * 0.3,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.deepPurple[100],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: _buildBookImage(),
          ),
        ),
        
        SizedBox(width: 16),
        
        // Блок с информацией (4/5 ширины экрана)
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.book?.photoBase64 != null || _newImageFile != null)
                Text(
                  'Обложка книги',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: Colors.grey[200],
      child: Center(
        child: Icon(
          Icons.menu_book,
          size: 40,
          color: Colors.grey[600],
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _newImageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка при выборе изображения: $e')),
      );
    }
  }

  _saveBook() async {
    //Логика для сохранения книги
    String title = _titleController.text;
    Author? author = _selectedAuthor ?? widget.book?.author;
    Genre? genre = _selectedGenre ?? widget.book?.genre;
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
      author: author!, 
      genre: genre!, 
      isDeleted: widget.book?.isDeleted ?? false,
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

  // Отдельный метод для построения карточек с информацией
List<Widget> _buildBookInfoCards() {
  return [
    if (widget.book?.isDeleted ?? false)
      _buildInfoCard(Icons.assignment_outlined, 'Предупреждение', 'Книга удалена из каталога'),
    _buildInfoCard(Icons.title, 'Название книги', widget.book?.name),
    _buildInfoCard(Icons.category, 'Жанр', widget.book?.genre.name),
    _buildInfoCard(Icons.person, 'Автор', widget.book?.author.name),
    _buildInfoCard(Icons.calendar_today, 'Год издания', widget.book?.year.toString()),
    _buildInfoCard(Icons.event, 'Дата возврата', 
      widget.book?.plannedReturnDate?.toLocal().toString().split(' ')[0] ?? "Нет"),
  ];
}

// Отдельный метод для построения кнопок действий
List<Widget> _buildActionButtons() {
  final buttons = <Widget>[];
  
  if (widget.book != null && !widget.book!.isTaken && !widget.book!.isDeleted) {
    buttons.addAll([
      const SizedBox(height: 20),
      _buildActionButton(
        Icons.bookmark_add,
        'Взять книгу',
        Colors.green,
        () async {
          final result = await Navigator.push<bool>(
            context,
            MaterialPageRoute(builder: (context) => TakeBookDialog(book: widget.book!)),
          );
          if (result == true && mounted) {
            setState(() {});
          }
        },
      ),
    ]);
  }

  if (widget.book != null && 
      widget.book!.isTaken && 
      widget.book!.currentReader?.email == Auth.user.email && 
      !widget.book!.isDeleted) {
    buttons.addAll([
      const SizedBox(height: 20),
      _buildActionButton(
        Icons.bookmark_remove,
        'Вернуть книгу',
        Colors.blue,
        () async {
          final result = await Navigator.push<bool>(
            context,
            MaterialPageRoute(builder: (context) => ReturnBookDialog(book: widget.book!)),
          );
          if (result == true && mounted) {
            setState(() {});
          }
        },
      ),
    ]);
  }

  return buttons;
}

  Future<Response> delete(Book book) async {
  try {
    final deleteData = DeleteData<Book>(Book.fromJson);
    final response = await deleteData.deleteItem(
      UriStrings.addControllerName(UriStrings.deleteByIdUri, 'Book'), 
      book.id!
    );
    return response; // предполагая, что response возвращает bool
  } catch (e) {
    SnackBar(content: Text('Ошибка при удалении: $e'));
    throw Exception('Ошибка при удалении: $e');
  }
}

Future<Response> restore(Book book) async {
  var restoredBook = book.restoredBook();

  try {
    final restoreData = PutData<Book>(Book.fromJson);
    final response = await restoreData.putItem(
      UriStrings.addControllerName(UriStrings.putByIdUri, 'Book'), 
      restoredBook
    );
    return response; // предполагая, что response возвращает bool
  } catch (e) {
    SnackBar(content: Text('Ошибка при удалении: $e'));
    throw Exception('Ошибка при удалении: $e');
  }
}

  Future<Response> put(Book book) async {
    try {
      final putData = PutData<Book>(Book.fromJson);
      final response = await putData.putItem(
        UriStrings.addControllerName(UriStrings.putByIdUri, 'Book'), 
        book);
      return response; // предполагая, что response возвращает bool
    } catch (e) {
      SnackBar(content: Text('Ошибка при удалении: $e'));
      throw Exception('Ошибка при удалении: $e');
    }
  }

  Future<Response> post(Book book) async {
    try {
      final postData = PostData<Book>();
      final response = await postData.postItem(UriStrings.addControllerName(UriStrings.postUri, 'Book'), book);
      return response; // предполагая, что response возвращает bool
    } catch (e) {
      SnackBar(content: Text('Ошибка при удалении: $e'));
      throw Exception('Ошибка при удалении: $e');
    }
  }

  Future<void> _confirmDelete(BuildContext context, Book bookToDelete) async {
  // Проверка на удаление 
  if (bookToDelete.isTaken) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Вы не можете удалить книгу на руках')),
      );
    }
    return;
  }

  final bool? confirm = await showDialog<bool>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Подтверждение удаления'),
        content: Text('Вы уверены, что хотите удалить ${bookToDelete.name}?'),
        icon: const Icon(Icons.warning, color: Colors.orange),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Отмена'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          TextButton(
            child: const Text('Удалить', style: TextStyle(color: Colors.red)),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      );
    },
  );

  if (confirm == true && mounted) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    Response response = await delete(bookToDelete);
    Navigator.of(context).pop(); // Закрываем индикатор

    if (mounted) {
      if (response.statusCode == 200 || response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Книга "${bookToDelete.name}" удалена')));
        setState(() {});
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ошибка при удалении')),
        );
      }
    }
  }
}

Future<void> _confirmRestore(BuildContext context, Book bookToRestore) async {
  final bool? confirm = await showDialog<bool>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Подтверждение действия'),
        content: Text('Вы уверены, что хотите восстановить ${bookToRestore.name}?'),
        icon: const Icon(Icons.warning, color: Colors.green),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Отмена'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          TextButton(
            child: const Text('Восстановить', style: TextStyle(color: Colors.red)),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      );
    },
  );

  if (confirm == true && mounted) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    Response response = await restore(bookToRestore);
    Navigator.of(context).pop(); // Закрываем индикатор

    if (mounted) {
      if (response.statusCode == 200 || response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Книга "${bookToRestore.name}" снова доступна')));
        setState(() {});
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ошибка при восстановлении')),
        );
      }
    }
  }
}


// Отдельный метод для построения колонки с полями ввода
Widget _buildFieldsColumn() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildTextFieldWithIcon(
        Icons.title,
        'Название книги',
        _titleController,
      ),
      const SizedBox(height: 20),
      GenericDropdown<Genre>(
        futureItems: FetchData.loadData<Genre>(
          UriStrings.addControllerName(UriStrings.getUri, 'Genre'),
          Genre.fromJson,
        ),
        onItemSelected: (Genre? genre) => _selectedGenre = genre,
        label: widget.book?.genre.name ?? 'Жанр',
        icon: Icons.category,
      ),
      const SizedBox(height: 20),
      GenericDropdown<Author>(
        futureItems: FetchData.loadData<Author>(
          UriStrings.addControllerName(UriStrings.getUri, 'Author'),
          Author.fromJson,
        ),
        onItemSelected: (Author? author) => _selectedAuthor = author,
        label: widget.book?.author.name ?? 'Автор',
        icon: Icons.person,
      ),
      const SizedBox(height: 20),
      _buildTextFieldWithIcon(
        Icons.calendar_today,
        'Год издания (ГГГГ-ММ-ДД)',
        _yearController,
        formatters: [yearMaskFormatter],
        hintText: '2002-02-02',
        keyboardType: TextInputType.number,
      ),
    ],
  );
}

// Отдельный метод для построения кнопок действий
List<Widget> _buildActionButtonsAdmin() {
  final buttons = <Widget>[];
  
  buttons.add(
    _buildActionButton(
      Icons.save,
      'Сохранить книгу',
      Colors.deepPurple,
      _saveBook,
    ),
  );

  if (widget.book != null && !widget.book!.isDeleted) {
    buttons.addAll([
      const SizedBox(height: 15),
      _buildActionButton(
        Icons.delete,
        'Удалить книгу',
        Colors.red,
        () => _confirmDelete(context, widget.book!),
      ),
    ]);
  }
  
  if (widget.book?.isDeleted ?? false) {
    buttons.addAll([
      const SizedBox(height: 15),
      _buildActionButton(
        Icons.restore_from_trash,
        'Восстановить книгу',
        Colors.green,
        () => _confirmRestore(context, widget.book!),
      ),
    ]);
  }

  if (widget.book != null && !widget.book!.isTaken && !widget.book!.isDeleted) {
    buttons.addAll([
      const SizedBox(height: 15),
      _buildActionButton(
        Icons.bookmark_add,
        'Взять книгу',
        Colors.green,
        () async {
          final result = await Navigator.push<bool>(
            context,
            MaterialPageRoute(builder: (context) => TakeBookDialog(book: widget.book!)),
          );
          if (result == true && mounted) {
            setState(() {});
          }
        },
      ),
    ]);
  }

  if (widget.book != null && 
      widget.book!.isTaken && 
      widget.book!.currentReader == Auth.user &&
      !widget.book!.isDeleted) {
    buttons.addAll([
      const SizedBox(height: 15),
      _buildActionButton(
        Icons.bookmark_remove,
        'Вернуть книгу',
        Colors.blue,
        () async {
          final result = await Navigator.push<bool>(
            context,
            MaterialPageRoute(builder: (context) => ReturnBookDialog(book: widget.book!)),
          );
          if (result == true && mounted) {
            setState(() {});
          }
        },
      ),
    ]);
  }

  return buttons;
}
}