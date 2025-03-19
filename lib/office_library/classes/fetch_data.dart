import 'dart:convert';
import 'package:http/http.dart' as http;
import '../classes/item_base_class.dart';

class FetchData<T extends Item> {
  final T Function(Map<String, dynamic>) fromJson;
  FetchData(this.fromJson);

  Future<List<T>> fetchList(String baseUri) async {
  
    final uri = baseUri.replaceAll('.', '-');

    final response = await http.get(
      Uri.parse(uri),
      );

    print('response: ${response.statusCode}');

    if (response.statusCode == 200) {
      final respStr = response.body.replaceAll("\"[", "[").replaceAll("]\"", "]").replaceAll("\\", "");
      List<dynamic> jsonResponse = json.decode(respStr);
      return jsonResponse.map((itemJson) => fromJson(itemJson)).toList();
    } 
    else {
      throw Exception('Failed to load items');
      }
  }

  Future<T> fetchOne(String getOneUri) async {
    final response = await http.get(
      Uri.parse(getOneUri),
      );

    print('response: ${response.statusCode}');

    if (response.statusCode == 200) {
      final respStr = response.body.replaceAll("\"{", "{").replaceAll("}\"", "}").replaceAll("\\", "");
      print('resp = $respStr');
      Map<String, dynamic> jsonResponse = json.decode(respStr);
      return fromJson(jsonResponse);
    } 
    else {
      throw Exception('Failed to load items');
      }
  }

  static Future<List<T>> loadData<T extends Item>(String uri, T Function(Map<String, dynamic>) fromJson) async {
  try {
    var fetchData = FetchData<T>(fromJson);
    return await fetchData.fetchList(uri); // Возвращаем Future<List<T>>
    } catch (e) {
      throw Exception('Ошибка загрузки данных: $e');
    }
  }
}
