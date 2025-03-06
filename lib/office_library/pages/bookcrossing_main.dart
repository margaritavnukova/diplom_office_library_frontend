import 'package:flutter/material.dart';

import 'user_profile_page.dart';
import '../classes/strings.dart';
import 'book_list_page_base.dart';
import 'qrcode_page.dart';
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
        title: Text("Главная страница"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              apiService.logout();
              Navigator.pushAndRemoveUntil(
                context, 
                MaterialPageRoute(builder: (context) => MyAuthorization()),
                (Route<dynamic> route) => false,
              );
            }
          )
        ]
      ), 

    body: Center( 
      child: IndexedStack(
        index: _selectedIndex,
        children: [
          UserProfilePage(reader: widget.reader),
          // single user books
          BookList(uri: UriStrings.getBooksByReaderUri + Auth.user.email.replaceAll('.', '-')),
          MyQrCodePage(),
          // all book in lib
          BookList(uri: UriStrings.getBooksUri)
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
            icon: Icon(Icons.book),
            label: "Ваши книги",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code),
            label: "Добавить книгу через QR-код",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.queue),
            label: "Очередь на книги",
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

