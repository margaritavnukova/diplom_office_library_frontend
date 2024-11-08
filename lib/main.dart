import 'package:flutter/material.dart';

import 'form.dart';

void main() {
  runApp(
    const MaterialApp(
      home: Scaffold(
        body: MyCustomForm()
      )
    )
  );
  //Log();
}

//5 lection

void Log() {
  int x = 20;
    log(x);
    x = 34;
    log(x);
    String name = "Tom";
    log(name);
}
void log<T>(T a){
     
    // DateTime.now() - получает текущую дату и время
    print("${DateTime.now()} a=$a");
}