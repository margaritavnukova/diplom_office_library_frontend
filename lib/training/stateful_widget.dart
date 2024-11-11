import 'package:flutter/material.dart';

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
