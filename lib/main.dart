import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData(fontFamily: 'Maki'),
      title: 'Rita App Test',
      //home: MyHomePage(),
      home: Scaffold(
        body: MyStatefulWidget(),
        appBar: AppBar(
          //leading: Image.network("https://www.google.com/search?sca_esv=dd081f6c458ad610&sxsrf=ADLYWILl-7coYAMmwKFiTSzpyKMqnGDYuw:1730811018434&q=%D0%B8%D0%BA%D0%BE%D0%BD%D0%BA%D0%B0+%D0%BA%D0%BD%D0%B8%D0%B3%D0%B8&udm=2&fbs=AEQNm0DDgaHKHmgQPgdfMPlZgxGLnxEu8LHmfB5EkrXeWoaoT4cm3R3McfGi35ahIGKd3uXCpdObyYftpdup4d1HQYmsZvB4sogTW2MrYwnvFygLrcEArKPmY_mSkSJItE3pJgy2GGmoRjv0om5m4qySbZLdn4l83qLSIUF9vwKZ12O8Gb6tdVy5W_8C4-SloIZqf0SG8tQRZf7jGGj0qH5I4eZchBRAJSW-fhfJUBjXCU5m3czMS0o&sa=X&ved=2ahUKEwiH-rS_ncWJAxUVGhAIHSjyLW0QtKgLegQIFBAB#vhid=5pao25gGk9pEkM&vssid=mosaic"),
          title: Text(
            "My Title",
            style: TextStyle(fontFamily: 'Maki'),
          ), 
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          ),
      )
    )
  );
}

class MyStatelessWidget extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
     
    return Container(
      alignment: Alignment.center,
      color: Colors.black,
      // child: ElevatedButton(
      //   onPressed: () {}, 
      //   child: Text("Button")
      //),
      child: Scaffold(
        body: Image.asset("assets/booksIcon.png"),
     ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget{
  MyStatefulWidget({ super.key});
  @override
  _CounterState createState() => _CounterState();
}

class _CounterState extends State<MyStatefulWidget>{
 
  int value = 0;
 
  @override
  Widget build(BuildContext context) {
 
    return Align(
      alignment: Alignment.center, 
      child: ElevatedButton(
        child: Text("Value: $value", style: TextStyle(fontSize: 22)),
        onPressed:(){ setState(() {
          value++;
        });}
      )
    );
  }
}
