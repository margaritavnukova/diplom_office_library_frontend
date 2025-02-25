import 'package:flutter/material.dart';
import 'login_info_class.dart';
import 'inherited_widget.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;

class MyTest extends StatefulWidget{
  const MyTest({super.key});

  @override
  _MyTest createState() => _MyTest();
}

class _MyTest extends State<MyTest>{
  late LoginInfo role = LoginInfo(
    name: "Test", 
    password: "0", 
    pfp: "BooksIcon.png",
    finishedBooks: null
  );
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

  return MaterialApp(
    home: Scaffold(
      body: MyInheritedWidget(
        login: role,
        child: Builder(
          builder: (context) {
            return Center(
              child: Form(
                key: formKey,
                child:  
                    Padding(
                      padding: const EdgeInsets.only(top: 25.0),
                      child: ElevatedButton(
                        child: const Text(
                          "LOGIN"
                        ),
                        onPressed: () async {
                          final response = await http.get(Uri.parse('https://www.cbr.ru/scripts/XML_daily.asp?date_req=02/03/2002'));
                          print('response: ${response.statusCode}');
                        }
                      )
                    )
              )
            );
          }
        )
      )
    )
  );
  }
}
                         