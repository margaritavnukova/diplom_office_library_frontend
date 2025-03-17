import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import '../classes/item_base_class.dart'; 

class PutData<T extends Item> {
  final T Function(Map<String, dynamic>) fromJson;
  PutData(this.fromJson);

  // Функция для добавления нового элемента 
  Future<void> putItem(String uri, T item) async {
    final response = await http.put(
      Uri.parse(uri),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(item),
    );

    print('response: ${response.statusCode}');

    if (response.statusCode == 201 || response.statusCode == 200) {
      print('Item edited successfully');
    } else {
      throw Exception('Failed to add item: ${response.body}');
    }
  }
}