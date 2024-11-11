import 'package:flutter/material.dart';

import 'homepage_body.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  MyHomePageState createState() {
    return MyHomePageState();
  }
}

class MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      //navigation
      initialRoute: '/',
      routes: {
        '/home_body': (context) => const MyHomePageBody(),
        //'/page2': (context) => const Page2(),
      },  

      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purpleAccent,
        ), 
        body: const MyHomePageBody(

        ),
        bottomNavigationBar: BottomNavigationBar(
          fixedColor: Colors.deepPurple,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.book),
              label: 'Books',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.messenger),
              label: 'Help',
            ),
          ],
        ),
      ),
    );
  }
}

