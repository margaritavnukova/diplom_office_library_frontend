import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:office_library_backend/office_library/assets/strings.dart';
import '../classes/auth.dart';
import '../classes/book_class.dart';
import '../classes/fetch_data.dart';
import '../classes/reader_class.dart';
import 'edit_profile_page.dart';
import 'register_reader.dart';

class UserProfilePage extends StatefulWidget {
  final Reader initialReader;

  const UserProfilePage({required this.initialReader, Key? key}) : super(key: key);

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  late Reader reader;
  Reader? otherReader;
  List<Reader> allUsers = [];
  static const double paddingMeasure = 10;

  @override
  void initState() {
    super.initState();
    reader = widget.initialReader;
    if (Auth.user.role == 'Admin') {
      _loadAllUsers();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAdmin = Auth.user.role == 'Admin';
    final isCurrentUser = Auth.user.email == reader.email;

    return Scaffold(
  appBar: AppBar(
        title: const Text('Профиль пользователя'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshData,
            tooltip: 'Обновить данные',
          ),
        ],
      ),
  body: RefreshIndicator(
        onRefresh: _refreshData,
        child: Padding(
          padding: const EdgeInsets.all(paddingMeasure * 4),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(), // Для работы RefreshIndicator
            child: Padding(
              padding: const EdgeInsets.all(paddingMeasure * 4),
              child: SingleChildScrollView(
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
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Почта: ${reader.email}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.deepPurple[700],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Телефон: ${reader.phoneNumber}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.deepPurple[700],
                                ),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Просроченные книги:',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                              FutureBuilder<List<Book>>(
                                future: fetchOverdueBooks(reader.email),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return const CircularProgressIndicator();
                                  } else if (snapshot.hasError) {
                                    return Text(
                                      'Ошибка: ${snapshot.error}',
                                      style: const TextStyle(color: Colors.red),
                                    );
                                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                    return const Text('Нет просроченных книг');
                                  } else {
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: snapshot.data!.map((book) => Text(
                                        '• ${book.name} (до ${book.plannedReturnDate?.toLocal().toString().split(' ')[0]})',
                                        style: const TextStyle(color: Colors.red),
                                      )).toList(),
                                    );
                                  }
                                },
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
                                  ? MemoryImage(base64Decode(reader.photoBase64!)) as ImageProvider?
                                  : null,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Column(
                      children: [
                        if (isCurrentUser || isAdmin)
                          _buildActionButton(
                            'Редактировать профиль',
                            Colors.deepPurple,
                            () => _editProfile(context),
                          ),
                        if (isAdmin) const SizedBox(height: 10),
                        
                        if (isAdmin) const SizedBox(height: 10),
                        if (isAdmin)
                          _buildActionButton(
                            'Добавить пользователя',
                            Colors.green,
                            () => _addUser(context),
                          ),

                          if (isAdmin) ...[
                          const SizedBox(height: 30),
                          const Text(
                            'Все пользователи:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          _buildUsersTable(),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
    ),
  );
}

Future<void> _refreshData() async {
    setState(() {
      // Сбрасываем состояние загрузки
      allUsers = [];
    });

    try {
      // 1. Обновляем данные текущего пользователя
      var editedEmail = widget.initialReader.email.replaceAll('.', '-');
      final updatedUser = await FetchData<Reader>(Reader.fromJson).fetchOne(
        '${UriStrings.getOneUserByEmailUri}$editedEmail'
      );
      
      // 2. Для админа обновляем список всех пользователей
      if (Auth.user.role == 'Admin') {
        final users = await FetchData.loadData<Reader>(
          UriStrings.addControllerName(UriStrings.getUri, 'User'),
          Reader.fromJson,
        );
        setState(() {
          allUsers = users;
        });
      }

      setState(() {
        reader = updatedUser ?? widget.initialReader;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Данные обновлены')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка обновления: $e')),
      );
    }
  }
  
  Widget _buildActionButton(String text, Color color, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          minimumSize: const Size(double.infinity, 50),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ),
        )
      );
  }

  Future<void> _editProfile(BuildContext context) async {
    final updatedReader = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfilePage(reader: reader),
      ),
    );

    if (updatedReader != null) {
      setState(() {
        reader = updatedReader;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Профиль успешно обновлен')),
      );
    }
  }

  Future<void> _editUserPermissions(BuildContext context) async {
    if (otherReader == null) return;
    
    final updatedReader = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfilePage(reader: otherReader!),
      ),
    );

    if (updatedReader != null) {
      setState(() {
        otherReader = updatedReader;
      });
    }
  }

  Future<void> _addUser(BuildContext context) async {
    //if (otherReader == null) return;
    
    final updatedReader = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RegisterPage(),
      ),
    );

    if (updatedReader != null) {
      setState(() {
        otherReader = updatedReader;
      });
    }
  }

  Future<void> _loadAllUsers() async {
    try {
      final users = await FetchData.loadData<Reader>(
        UriStrings.addControllerName(UriStrings.getUri, 'User'),
        Reader.fromJson,
      );
      setState(() {
        allUsers = users;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка загрузки пользователей: $e')),
      );
    }
  }

  Widget _buildUsersTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Имя')),
          DataColumn(label: Text('Email')),
          DataColumn(label: Text('Роль')),
          DataColumn(label: Text('Действия')),
        ],
        rows: allUsers.map((user) {
          return DataRow(
            cells: [
              DataCell(Text(user.name ?? '')),
              DataCell(Text(user.email)),
              DataCell(Text(user.role ?? '')),
              DataCell(
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _editUser(context, user),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );

    
  }

  Future<void> _editUser(BuildContext context, Reader user) async {
    final updatedReader = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfilePage(reader: user),
      ),
    );

    if (updatedReader != null) {
      setState(() {
        final index = allUsers.indexWhere((u) => u.id == updatedReader.id);
        if (index != -1) {
          allUsers[index] = updatedReader;
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Пользователь успешно обновлен')),
      );
    }
  }


Future<List<Book>> fetchBooks(String email) async {
  var fetchData = FetchData<Book>(Book.fromJson);
  var books = fetchData.fetchList(
    UriStrings.addControllerName(UriStrings.getBooksByReaderUri + email, 'Book')
  );
  return books;
}

Future<List<Book>> fetchOverdueBooks(String email) async {
    final now = DateTime.now();
    final allBooks = await fetchBooks(email);
    return allBooks.where((book) => 
      book.plannedReturnDate != null && book.plannedReturnDate!.isBefore(now)
    ).toList();
  }
}

