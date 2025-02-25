import 'package:flutter/material.dart';

import 'login_info_class.dart';
import 'inherited_widget.dart';

class MyHomePageBody extends StatefulWidget{
  final LoginInfo? login;
  const MyHomePageBody({super.key, this.login});

  @override
  _CounterState createState() => _CounterState();
}

class _CounterState extends State<MyHomePageBody>{
 
  @override
  Widget build(BuildContext innerContext) {
    
    print(MyInheritedWidget.of(innerContext).login);
    
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.all(20),
      // child: Align(
      //   alignment: Alignment.center, 
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
      //)
    );
  }
}
