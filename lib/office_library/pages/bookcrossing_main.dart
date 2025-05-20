import 'package:flutter/material.dart';

import 'user_profile_page.dart';
import '../assets/strings.dart';
import 'book_list_page_base.dart';
import 'authorization_page.dart';
import '../classes/reader_class.dart';
import '../classes/auth.dart';

class MyMainPage extends StatefulWidget {
  final Reader reader;
  const MyMainPage({super.key, required this.reader});

  @override
  MyMainPageState createState() {
    return MyMainPageState();
  }
}

class MyMainPageState extends State<MyMainPage> {
  int _selectedIndex = 0;
  final Auth apiService = Auth();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purpleAccent,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.auto_stories_rounded, size: 28), // Иконка книги
            SizedBox(width: 10), // Отступ между иконкой и текстом
            Text(Auth.hasRole('Admin') ? "Приложение для буккроссинга (администрирование)" : "Приложение для буккроссинга", style: TextStyle(fontFamily: "Bookman old style")),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              apiService.logout();
              final result = await Navigator.pushAndRemoveUntil<bool>(
                  context,
                  MaterialPageRoute(builder: (context) => MyAuthorization()),
                  (Route<dynamic> route) => false,
                );
                if (result == true) {
                  // Обновляем данные, если редактирование успешно
                  setState(() {});
                }
            }
          )
        ]
      ), 

    body: Center( 
      child: IndexedStack(
        index: _selectedIndex,
        children: [
          UserProfilePage(initialReader: widget.reader),
          // single user books
          BookList(uri: UriStrings.getBooksByReaderUri + Auth.user.email.replaceAll('.', '-')),
          // MyQrCodePage(),
          // all book in lib
          BookList(uri: UriStrings.addControllerName(UriStrings.getUri, 'Book'))
        ],
      ),
    ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(255, 53, 41, 85),
        fixedColor: Colors.deepPurple,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Профиль",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_stories_outlined),
            label: "Ваши книги",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_awesome_motion_outlined), //amp_stories_outlined, auto_awesome_motion_outlined
            label: "Книги библиотеки",
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

