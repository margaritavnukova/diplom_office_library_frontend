import 'package:flutter/material.dart';
import '../assets/strings.dart';
import '../classes/auth.dart';
import '../classes/book_class.dart';
import '../classes/fetch_data.dart';
import '../classes/post_data.dart';
import '../classes/reader_class.dart';
import 'item_dropdown.dart';

class TakeBookDialog extends StatefulWidget {
  final Book book;

  TakeBookDialog({
    required this.book,
  });

  @override
  _TakeBookDialogState createState() => _TakeBookDialogState();
}

class _TakeBookDialogState extends State<TakeBookDialog> {
  late Reader? _reader;
  late DateTime _returnDate;
  Reader currentUser = Auth.user;

  @override
  void initState() {
    super.initState();
    _returnDate = DateTime.now().add(Duration(days: 30)); // Дата возврата (+30 дней)
    _reader = currentUser.role! == 'User'
        ? currentUser
        : null; 
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Взять книгу'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.book.isTaken)
              Column(
                children: [
                  Text(
                    'Книга уже взята!',
                    style: TextStyle(color: Colors.red),
                  ),
                  SizedBox(height: 10),
                  Text('Читатель: ${widget.book.currentReader?.name}'),
                  Text('Дата возврата: ${widget.book.plannedReturnDate}'),
                ],
              )
            else
              Column(
                children: [
                  if (currentUser.role == 'User')
                    Text('Читатель: ${currentUser.name}')
                  else
                    GenericDropdown<Reader>(
                      futureItems: FetchData.loadData<Reader>(
                        UriStrings.addControllerName(UriStrings.getUri, 'User'),
                        Reader.fromJson, 
                      ),
                      onItemSelected: (Reader? reader) {
                        _reader = reader;
                      },
                      label: "Читатель",
                    ),
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
        // Логика взятия книги
        if (!(widget.book?.isTaken ?? true))
          TextButton(
            onPressed: () async {
              if (_reader == null) {
                _showErrorSnackBar('Выберите читателя');
                return;
              }

              try {
                final bookTaken = widget.book.takeBook(_reader!);
                
                final postData = PostData<Book>();
                await postData.postItem(UriStrings.takeBookUri, bookTaken);

                _showSuccessSnackBar(
                  'Книга "${bookTaken.name}" взята читателем ${_reader?.name ?? "noname"}'
                );
                _showSuccessSnackBar(
                  'Дата возврата: ${bookTaken.plannedReturnDate?.toString() ?? "не определена"}'
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
