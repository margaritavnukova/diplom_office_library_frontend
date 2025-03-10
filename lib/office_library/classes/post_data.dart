import 'dart:convert';
import 'package:http/http.dart' as http;
import '../classes/item_base_class.dart'; // Предполагается, что у вас есть базовый класс Item

class PostData<T extends Item> {
  final Map<String, dynamic> Function() toJson;
  PostData(this.toJson);

  // Функция для добавления нового элемента 
  Future<void> postItem(String uri, T item) async {
    uri = uri.replaceAll('.', '-');

    // Преобразуем объект в JSON
    final itemJson = item.toJson();
    final response = await http.post(
      Uri.parse(uri),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(itemJson),
    );

    print('response: ${response.statusCode}');

    if (response.statusCode == 201 || response.statusCode == 200) {
      print('Item added successfully');
    } else {
      throw Exception('Failed to add item: ${response.body}');
    }
  }
}