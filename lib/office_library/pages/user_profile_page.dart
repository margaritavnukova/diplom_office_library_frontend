import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:office_library_backend/office_library/assets/strings.dart';
import '../classes/auth.dart';
import '../classes/book_class.dart';
import '../classes/fetch_data.dart';
import '../classes/reader_class.dart';
import 'edit_profile_page.dart';
import 'item_dropdown.dart';

class UserProfilePage extends StatelessWidget {
  final Reader reader;
  late Reader? otherReader;
  static const double paddingMeasure = 10;

  UserProfilePage({required this.reader});

  @override
  Widget build(BuildContext context) {
    final isAdmin = Auth.user.role == 'Admin';
    final isCurrentUser = Auth.user.email == reader.email;

    return Scaffold(
      appBar: AppBar(
        title: Text('Профиль пользователя'),
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
                        'Имя: ${reader.name ?? "Нет данных об имени"}',
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
                            return CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text(
                              'Ошибка: ${snapshot.error}',
                              style: TextStyle(color: Colors.red),
                            );
                          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return Text('Книг нет');
                          } else {
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
                        style: TextStyle(fontSize: 16,
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
                      backgroundImage: (reader.photoBase64 != null)
                          ? MemoryImage(base64Decode(reader.photoBase64!)) as ImageProvider<Object>?
                          : null,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Кнопки редактирования
            if (isCurrentUser || isAdmin)
              ElevatedButton(
                onPressed: () {
                  // Логика редактирования профиля
                  _editProfile(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Text(
                  'Редактировать профиль',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            if (isAdmin)
              SizedBox(height: 10),
            if (isAdmin)
              GenericDropdown<Reader>(
                      futureItems: FetchData.loadData<Reader>(
                        UriStrings.addControllerName(UriStrings.getUri, 'User'),
                        Reader.fromJson, 
                      ),
                      onItemSelected: (Reader? reader) {
                        otherReader = reader!;
                      },
                      label: "Читатель",
                    ),

              if (isAdmin)
              ElevatedButton(
                onPressed: () {
                  // Логика редактирования пользователей для админа
                  _editUserPermissions(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Text(
                  'Редактировать пользователя',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _editProfile(BuildContext context) {
    // Навигация на страницу редактирования профиля
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfilePage(reader: reader),
      ),
    );
  }

  void _editUserPermissions(BuildContext context) {
    // Навигация на страницу редактирования прав пользователя
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfilePage(reader: otherReader!),
      )
    );
  }
}

Future<List<Book>> fetchBooks(String email) async {
  var fetchData = FetchData<Book>(Book.fromJson);
  var books = fetchData.fetchList(UriStrings.addControllerName(UriStrings.getBooksByReaderUri + email, 'Book'));
  return books;
}