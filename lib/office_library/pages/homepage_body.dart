import 'package:flutter/material.dart';

class MyHomePageBody extends StatefulWidget{
  const MyHomePageBody({super.key});

  @override
  _CounterState createState() => _CounterState();
}

class _CounterState extends State<MyHomePageBody>{
 
  @override
  Widget build(BuildContext innerContext) {
    
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
                  "assets/booksIcon.png",
                  height: 100,
                  width: 100,
                ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("Имя: "),
                Text("Тест"),
              ]
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                 Text("Дата регистрации: "),
                 Text("12.11.2024")
              ]
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                 Text("Количество прочитанных книг: "),
                 Text("25")
              ]
            )
          ],
        )
    );
  }
}
