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
  Widget build(BuildContext context) {
 
    return Align(
      alignment: Alignment.center, 
      child: Column(
        children: [
          SizedBox(child: Image.asset("assets/$MyInheritedWidget.of(context).login?.pfp")),
        ],
      )
    );
  }
}
