import 'package:flutter/material.dart';
import '../assets/strings.dart';
import '../classes/auth.dart';
import '../classes/book_class.dart';
import '../classes/post_data.dart';
import '../classes/reader_class.dart';

class ReturnBookDialog extends StatefulWidget {
  final Book book;

  ReturnBookDialog({
    required this.book,
  });

  @override
  _ReturnBookDialogState createState() => _ReturnBookDialogState();
}

class _ReturnBookDialogState extends State<ReturnBookDialog> {
  late Reader? _reader;
  late DateTime _returnDate;
  Reader currentUser = Auth.user;

  @override
  void initState() {
    super.initState();
    _returnDate = DateTime.now(); // Дата возврата
    _reader = currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Вернуть книгу'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!widget.book.isTaken)
              Column(
                children: [
                  Text(
                    'Книга и так в библиотеке!',
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              )
            else
              Column(
                children: [
                  Text('Читатель: ${widget.book.currentReader?.name ?? "no name"}'),
                  SizedBox(height: 20),
                  SizedBox(height: 10),
                  Text('Название книги: ${widget.book.name}'),
                  SizedBox(height: 10),
                  Text('Дата возврата: ${_returnDate.toLocal()}'),
                ],
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (mounted && !Navigator.of(context).userGestureInProgress) Navigator.pop(context); // Закрыть окно
          },
          child: Text('Отмена'),
        ),
        // Логика возврата книги
      if (widget.book?.isTaken ?? false)
        TextButton(
          onPressed: () async {
            try {
              final bookReturned = widget.book!.returnBook(_reader!, DateTime.now());
              
              final postData = PostData<Book>();
              await postData.postItem(UriStrings.returnBookUri, bookReturned);

              _showSuccessSnackBar(
                'Книга "${bookReturned.name}" возвращена читателем ${_reader?.name ?? "noname"}'
              );
              
              await _closeDialog();
            } catch (e) {
              _showErrorSnackBar(e);
            }
          },
          child: Text('Подтвердить'),
        ),
      ],
    );
  }

  void _showSuccessSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _showErrorSnackBar(dynamic error) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(error.toString())),
    );
  }

  Future<void> _closeDialog() async {
    if (mounted && !Navigator.of(context).userGestureInProgress) {
      Navigator.pop(context);
    }
  }
}

