import 'package:flutter/material.dart';

class MyQrCodePage extends StatefulWidget{
  const MyQrCodePage({super.key});

  @override
  _CounterState createState() => _CounterState();
}

class _CounterState extends State<MyQrCodePage>{
 
  @override
  Widget build(BuildContext innerContext) {    
    return Align(
      alignment: Alignment.center, 
      child: Column(
        children: [
          const Text("Загрузите изображение с кодом"),
          ElevatedButton(
          child: const Icon(Icons.download),
          onPressed: () {},
          ),
        ]      
      )
    );
  }
}
