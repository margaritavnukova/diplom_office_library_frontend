import 'package:flutter/material.dart';
import 'package:office_library_backend/office_library/book_class.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;

class BookList extends StatefulWidget{
  const BookList({super.key});

  @override
  _CounterState createState() => _CounterState();
}

class _CounterState extends State<BookList> {
  Future<List<Book>>? _futureBooks; // Храним результаты Future

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('XML Data'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              // При нажатии кнопки загружаем данные
              setState(() {
                _futureBooks = fetchBooks(); // Инициализация загрузки данных
              });
            },
            child: Text('Загрузить данные'),
          ),
          Expanded(
            child: FutureBuilder<List<Book>>(
              future: _futureBooks,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Ошибка: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('Нет данных'));
                } else {
                  final books = snapshot.data!;

                  return ListView.builder(
                    itemCount: books.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(books[index].Title),
                        subtitle: Text(books[index].Author),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<List<Book>> fetchBooks() async {
  final response = await http.get(
    // Uri.parse('https://www.cbr.ru/scripts/XML_daily.asp?date_req=02/03/2002'),
    Uri.parse('https://localhost:44319/api/Book'),
    // headers: {'Accept-Charset': 'utf-8'}
    );

  print('response: ${response.statusCode}');


  if (response.statusCode == 200) {
    // final decodedData = utf8.decode(latin1.encode(response.body));

    final startPoint = response.body.indexOf('?');
    final responsePart = response.body.substring(startPoint - 1, response.body.length - 1);
    var editedResponse = responsePart.replaceAll("\\r\\n", "");

    editedResponse = editedResponse.replaceAll(" xmlns:xsd=\\\"http://www.w3.org/2001/XMLSchema\\\" xmlns:xsi=\\\"http://www.w3.org/2001/XMLSchema-instance\\\"", "");
    // editedResponse = editedResponse.replaceAll("</ArrayOfBooksDto>", "");
    editedResponse = editedResponse.replaceAll(" xmlns=\\\"https://localhost:44319\\\"", "");
    editedResponse = editedResponse.replaceAll(" <Readers />", "");
    
    print('cut resp = $editedResponse');

    final document = xml.XmlDocument.parse(editedResponse);
    final books = document.findAllElements('BooksDto');

    // List<Book> returnBooks = [];

    return books.map((node) {
         return Book(
          node.findElements('Title').single.text,
          node.findElements('Year').single.text,
          );
       }).toList();
     } else {
       throw Exception('Failed to load items');
     }
  }
}
