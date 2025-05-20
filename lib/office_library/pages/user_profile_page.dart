import 'dart:convert';

import 'package:flutter/material.dart';

import '../assets/strings.dart';
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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_rounded, color: Colors.deepPurple),
            SizedBox(width: 10),
            Text(
              'Профиль пользователя',
              style: TextStyle(
                fontFamily: 'Bookman Old Style',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple[900],
              ),
            ),
          ],
        ),
        backgroundColor: Colors.deepPurple[100],
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, size: 28),
            onPressed: _refreshData,
            tooltip: 'Обновить данные',
          ),
        ],
      ),
      backgroundColor: Colors.deepPurple[50],
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.66,
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildUserProfileSection(context),
                  const SizedBox(height: 30),
                  _buildActionButtonsSection(isCurrentUser, isAdmin),
                  if (isAdmin) _buildAdminSection(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserProfileSection(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProfileInfoItem(
                    Icons.person,
                    reader.name ?? "Нет данных об имени",
                    Colors.deepPurple,
                    FontWeight.bold,
                    20
                  ),
                  _buildProfileInfoItem(
                    Icons.badge_rounded,
                    reader.role ?? "Нет данных о роли",
                    Colors.deepPurple,
                    FontWeight.bold,
                    20
                  ),
                  const SizedBox(height: 12),
                  _buildProfileInfoItem(
                    Icons.email,
                    'Почта: ${reader.email}',
                    Colors.deepPurple[700]!,
                    FontWeight.normal,
                    18
                  ),
                  const SizedBox(height: 12),
                  _buildProfileInfoItem(
                    Icons.phone,
                    'Телефон: ${reader.phoneNumber ?? "Нет номера"}',
                    Colors.deepPurple[700]!,
                    FontWeight.normal,
                    18
                  ),
                  const SizedBox(height: 20),
                  _buildOverdueBooksSection(),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.topRight,
                child: _buildUserAvatar()
              )
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserAvatar() {
    try {
      if (reader.photoBase64 != null && reader.photoBase64!.isNotEmpty) {
        // Удаляем префикс, если есть
        final base64Data = reader.photoBase64!.contains(',') 
            ? reader.photoBase64!.split(',').last 
            : reader.photoBase64!;
            
        return CircleAvatar(
          radius: 60,
          backgroundColor: Colors.purpleAccent[100],
          backgroundImage: MemoryImage(base64Decode(base64Data)),
        );
      }
    } catch (e) {
      print('Ошибка загрузки фото: $e');
    }
    
    // Fallback, если фото нет или произошла ошибка
    return CircleAvatar(
      radius: 60,
      backgroundColor: Colors.purpleAccent[100],
      child: const Icon(Icons.person, size: 50, color: Colors.white),
    );
  }

  Widget _buildProfileInfoItem(IconData icon, String value, Color color, FontWeight weight, double size) {
    return Row(
      children: [
        Icon(icon, color: color, size: size),
        const SizedBox(width: 10),
        Text(
          '$value',
          style: TextStyle(
            fontSize: size,
            color: color,
            fontWeight: weight,
          ),
        ),
      ],
    );
  }

  Widget _buildOverdueBooksSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.assignment_outlined, color: Colors.red, size: 20),
            const SizedBox(width: 8),
            const Text(
              'Просроченные книги:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        FutureBuilder<List<Book>>(
          future: fetchOverdueBooks(reader.email),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text(
                'Ошибка: ${snapshot.error}',
                style: const TextStyle(color: Colors.red, fontSize: 16),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Text(
                'Нет просроченных книг',
                style: TextStyle(fontSize: 16),
              );
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: snapshot.data!.map((book) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      const Icon(Icons.assignment_late_rounded, color: Colors.red, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        '${book.name} (до ${book.plannedReturnDate?.toLocal().toString().split(' ')[0]})',
                        style: const TextStyle(color: Colors.red, fontSize: 16),
                      ),
                    ],
                  ),
                )).toList(),
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildActionButtonsSection(bool isCurrentUser, bool isAdmin) {
    return Column(
      children: [
        if (isCurrentUser || isAdmin)
          _buildActionButton(
            Icons.edit,
            'Редактировать профиль',
            Colors.deepPurple,
            () => _editProfile(context),
          ),
        if (isAdmin) const SizedBox(height: 12),
        if (isAdmin)
          _buildActionButton(
            Icons.person_add,
            'Добавить пользователя',
            Colors.green,
            () => _addUser(context),
          ),
      ],
    );
  }

  Widget _buildAdminSection() {
    return Column(
      children: [
        const SizedBox(height: 30),
        const Text(
          'Все пользователи:',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Bookman',
          ),
        ),
        const SizedBox(height: 12),
        _buildUsersTable(),
      ],
    );
  }

  Widget _buildActionButton(IconData icon, String text, Color color, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: Icon(icon, size: 24, color: Colors.white),
        label: Text(
          text,
          style: const TextStyle(fontSize: 18, color: Colors.white),
        ),
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          minimumSize: const Size(double.infinity, 55),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        ),
      ),
    );
  }

  Widget _buildUsersTable() {
    if (allUsers.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columnSpacing: 30,
            columns: const [
              DataColumn(label: Text('Имя', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Email', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Роль', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Действия', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
            ],
            rows: allUsers.map((user) {
              return DataRow(
                cells: [
                  DataCell(Text(user.name ?? '', style: const TextStyle(fontSize: 16))),
                  DataCell(Text(user.email, style: const TextStyle(fontSize: 16))),
                  DataCell(Text(user.role ?? '', style: const TextStyle(fontSize: 16))),
                  DataCell(
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, size: 24),
                          onPressed: () => _editUser(context, user),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, size: 24, color: Colors.red),
                          onPressed: () => _confirmDelete(context, user),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, Reader user) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Подтвердите удаление'),
        content: Text('Вы уверены, что хотите удалить пользователя ${user.name}?'),
        actions: [
          TextButton(
            child: const Text('Отмена'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          TextButton(
            child: const Text('Удалить', style: TextStyle(color: Colors.red)),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      // Здесь должна быть реализация удаления пользователя
      setState(() {
        allUsers.removeWhere((u) => u.id == user.id);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Пользователь ${user.name} удалён')),
      );
    }
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
        reader = updatedUser;
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
      book.plannedReturnDate != null 
      && book.plannedReturnDate!.isBefore(now)
      && book.actualReturnDate == null
    ).toList();
  }
}