import 'package:flutter/material.dart';

import 'homepage_body.dart';
import 'authorization.dart';
import 'books.dart';

class MyMainPage extends StatefulWidget {
  const MyMainPage({super.key});

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

    body: IndexedStack(
      index: _selectedIndex,
      children: const [
        MyHomePageBody(),
        MyBooks(),
        MyAuthorization(),
        MyAuthorization(),
      ],
    ),

      bottomNavigationBar: BottomNavigationBar(
        fixedColor: Colors.deepPurple,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Profile",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: "Your books",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code),
            label: "Read QR-code",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.messenger),
            label: "Get assistance",
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
