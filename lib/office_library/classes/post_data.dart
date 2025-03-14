import 'dart:convert';
import 'package:http/http.dart' as http;
import '../classes/item_base_class.dart'; // Предполагается, что у вас есть базовый класс Item

class PostData<T extends Item> {
  // Функция для добавления нового элемента 
  Future<void> postItem(String baseUri, T item) async {
    final uri = baseUri.replaceAll('.', '-');

    // Преобразуем объект в JSON
    final response = await http.post(
      Uri.parse(uri),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(item),
    );

    print('response: ${response.statusCode}');

    if (response.statusCode == 201 || response.statusCode == 200) {
      print('Item added successfully');
    } else {
      throw Exception('Failed to add item: ${response.body}');
    }
  }
}