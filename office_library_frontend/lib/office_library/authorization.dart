import 'package:flutter/material.dart';
import 'bookcrossing_main.dart';
import 'login_info_class.dart';
import 'inherited_widget.dart';

class MyAuthorization extends StatefulWidget{
  const MyAuthorization({super.key});

  @override
  _MyAuthorization createState() => _MyAuthorization();
}

class _MyAuthorization extends State<MyAuthorization>{
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: 400.0,
                      child: TextFormField(
                        decoration: const InputDecoration(labelText: "Email"),
                        keyboardType: TextInputType.emailAddress,

                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          role.name = value;
                          print(role.name);
                          return null;
                        },
                      ),
                    ),
                    Container(
                      width: 400.0,
                      padding: const EdgeInsets.only(top: 10.0),
                      child: TextFormField(
                        decoration: const InputDecoration(labelText: "Password"),
                        obscureText: true,

                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 25.0),
                      child: ElevatedButton(
                        child: const Text(
                          "LOGIN"
                        ),
                        onPressed: () {
                          print("Click 1");
                          //Validate returns true if the form is valid, or false otherwise.
                          if (formKey.currentState!.validate()) {
                            // If the form is valid, display a snackbar. In the real world,
                            // you'd often call a server or save the information in a database.

                            print("Click 2");

                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => 
                                MyMainPage(login: role)
                              )
                            );
                          }
                        }, 
                      ),
                    )
                  ],
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
      