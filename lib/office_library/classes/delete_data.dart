import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import '../classes/item_base_class.dart'; 

class DeleteData<T extends Item> {
  final T Function(Map<String, dynamic>) fromJson;
  DeleteData(this.fromJson);

  // Функция для добавления нового элемента 
  Future<void> deleteItem(String baseUri, int id) async {
    final uri = join(baseUri, id.toString());

    final response = await http.delete(
      Uri.parse(uri),
    );

    print('response: ${response.statusCode}');

    if (response.statusCode == 204) {
      print('Item deleted successfully');
    } else {
      throw Exception('Failed to delete item: ${response.body}');
    }
  }
}