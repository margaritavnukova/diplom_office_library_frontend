import 'package:flutter/material.dart';

class MyAuthorization extends StatefulWidget{
  const MyAuthorization({ super.key});

  @override
  _MyAuthorization createState() => _MyAuthorization();
}

class _MyAuthorization extends State<MyAuthorization>{

  @override
  Widget build(BuildContext context) {
 
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: 400.0,
            child: TextFormField(
              decoration: const InputDecoration(labelText: "Email"),
              keyboardType: TextInputType.emailAddress,
            ),
          ),
          Container(
            width: 400.0,
            padding: const EdgeInsets.only(top: 10.0),
            child: TextFormField(
              decoration: const InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 25.0),
            child: ElevatedButton(
              child: const Text(
                "LOGIN"
              ),
              onPressed: () {},
            ),
          )
        ],
      )
    );
  }
}