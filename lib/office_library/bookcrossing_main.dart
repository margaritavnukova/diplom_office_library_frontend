import 'package:flutter/material.dart';

import 'homepage_body.dart';
import 'inherited_widget.dart';
import 'login_info_class.dart';
import 'package:office_library_backend/office_library/book_list_page.dart';
import 'qrcode_page.dart';

class MyMainPage extends StatefulWidget {
  final LoginInfo? login;
  const MyMainPage({super.key, this.login});

  @override
  MyMainPageState createState() {
    return MyMainPageState();
  }
}

class MyMainPageState extends State<MyMainPage> {
  int _selectedIndex = 0;

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
      ), 

    body: MyInheritedWidget( 
      child: IndexedStack(
        index: _selectedIndex,
        children: const [
          MyHomePageBody(),
          BookList(),
          MyQrCodePage(),
          BookList()
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

