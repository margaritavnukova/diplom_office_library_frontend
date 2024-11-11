import 'package:flutter/material.dart';

class MyBooks extends StatefulWidget{
  const MyBooks({super.key});

  @override
  _MyBooks createState() => _MyBooks();
}

class _MyBooks extends State<MyBooks>{

  @override
  Widget build(BuildContext context) {
 
    const count = 20;

    return Center(
      child: ListView.separated(
        itemCount: count,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            height: 50,
            child: Center(child: Text('Book $index')),
          );
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(),
      )
    );
  }
}