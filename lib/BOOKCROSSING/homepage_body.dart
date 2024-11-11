import 'package:flutter/material.dart';

class MyHomePageBody extends StatefulWidget{
  const MyHomePageBody({ super.key});

  @override
  _CounterState createState() => _CounterState();
}

class _CounterState extends State<MyHomePageBody>{
 
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
