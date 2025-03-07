import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:office_library_backend/office_library/assets/strings.dart';
import '../classes/book_class.dart';
import '../classes/fetch_data.dart';
import '../classes/reader_class.dart';

class UserProfilePage extends StatelessWidget {
  final Reader reader;
  static const double paddingMeasure = 10;

  UserProfilePage({required this.reader});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Профиль пользователя')
      ),
      body: Padding(
        padding: const EdgeInsets.all(paddingMeasure * 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Имя: ${reader.userName}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Почта: ${reader.email}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.deepPurple[700],
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Телефон: ${reader.phoneNumber}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.deepPurple[700],
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Количество книг: ',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.deepPurple[700],
                        ),
                      ),
                      SizedBox(height: 8),
                        FutureBuilder<List<Book>>(
                          future: fetchBooks(reader.email),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return CircularProgressIndicator(); // Показываем индикатор загрузки
                            } else if (snapshot.hasError) {
                              return Text(
                                'Ошибка: ${snapshot.error}',
                                style: TextStyle(color: Colors.red),
                              );
                            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return Text('Книг нет');
                            } else {
                              // Данные успешно загружены, отображаем длину списка
                              return Text(
                                '${snapshot.data!.length}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.deepPurple[700],
                                ),
                              );
                            }
                          },
                        ),
                      SizedBox(height: 8),
                      Text(
                        'Дата регистрации: ${reader.registrationDate?.toLocal() ?? "Нет данных"}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.deepPurple[700],
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Роль: ${reader.role ?? "Нет данных"}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.deepPurple[700],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.topRight,
                    child: CircleAvatar(
                      radius: MediaQuery.sizeOf(context).width / paddingMeasure,
                      backgroundColor: Colors.purpleAccent,
                      backgroundImage: (reader.photo != null)
                        ? MemoryImage(base64Decode(reader.photo!)) as ImageProvider<Object>?
                        : AssetImage('assets/images/null_user_photo.png') as ImageProvider<Object>?,
                      ),
                    ),
                  ),
                
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Future<List<Book>> fetchBooks(String email) async {
  var fetchData = FetchData<Book>(Book.fromJson);
  var books = fetchData.fetchList(UriStrings.getBooksByReaderUri + email);
  return books;
}