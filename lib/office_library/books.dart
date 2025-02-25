import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
      child: 
        Text(fetchAlbum().toString())
    );
  }
}

Future<http.Response> fetchAlbum() {
  return http.get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));}

  