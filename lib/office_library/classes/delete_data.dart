import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import '../classes/item_base_class.dart'; 

class DeleteData<T extends Item> {
  final T Function(Map<String, dynamic>) fromJson;
  DeleteData(this.fromJson);

  // Функция для добавления нового элемента 
  Future<void> deleteItem(String baseUri, String bookId) async {
    final uri = join(baseUri);

    final response = await http.delete(
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      Uri.parse(uri),
      body: jsonEncode(bookId)
    );

    print('response: ${response.statusCode}');

    if (response.statusCode == 204) {
      print('Item deleted successfully');
    } else {
      throw Exception('Failed to delete item: ${response.body}');
    }
  }
}