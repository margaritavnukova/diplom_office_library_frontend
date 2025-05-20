import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import '../classes/item_base_class.dart'; // Предполагается, что у вас есть базовый класс Item

class PostData<T extends Item> {
  // Функция для добавления нового элемента 
  Future<Response> postItem(String baseUri, T item) async {
    final uri = baseUri.replaceAll('.', '-');
    final jItem = jsonEncode(item);
    print("item: $jItem");

    // Преобразуем объект в JSON
    final response = await http.post(
      Uri.parse(uri),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jItem,
    );

    print('response: ${response.statusCode}');

    if (response.statusCode == 201 || response.statusCode == 200) {
      print('Item added successfully');
      return response;
    } else {
      throw Exception('Failed to add item: ${response.body}');
    }
  }
}