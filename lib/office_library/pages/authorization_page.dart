import 'package:flutter/material.dart';
import 'bookcrossing_main.dart';
import '../classes/auth.dart';
import '../classes/strings.dart';

class MyAuthorization extends StatefulWidget{
  const MyAuthorization({super.key});

  @override
  _MyAuthorization createState() => _MyAuthorization();
}

class _MyAuthorization extends State<MyAuthorization>{
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final Auth apiService = Auth();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Авторизация')),
      body: Padding(
        padding: const EdgeInsets.all(150.0),
        child: Column(
          children: [
            TextField(controller: emailController, decoration: InputDecoration(labelText: 'Email')),
            TextField(controller: passwordController, decoration: InputDecoration(labelText: 'Пароль'), obscureText: true),
            ElevatedButton( 
              onPressed: () async {
                try {
                  await apiService.login(emailController.text, passwordController.text);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                      MyMainPage()
                    )
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                }
              },
              child: Text(MyStrings.loginButtonLabel),
            ),
          ],
        ),
      ),
    );
  }

  // final formKey = GlobalKey<FormState>();

  // @override
  // Widget build(BuildContext context) {

  // return MaterialApp(
  //   home: Scaffold(
  //     body: Center(
  //       child: Builder(
  //         builder: (context) {
  //           return Center(
  //             child: Form(
  //               key: formKey,
  //               child: Column(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: <Widget>[
  //                   SizedBox(
  //                     width: 400.0,
  //                     //email
  //                     child: TextFormField(
  //                       decoration: const InputDecoration(labelText: MyStrings.emailLabel),
  //                       keyboardType: TextInputType.emailAddress,

  //                       validator: (value) {
  //                         if (value == null || value.isEmpty) {
  //                           return MyStrings.formValidatorLabel;
  //                         }
  //                         return null;
  //                       },
  //                     ),
  //                   ),
  //                   Container(
  //                     width: 400.0,
  //                     //login
  //                     padding: const EdgeInsets.only(top: 10.0),
  //                     child: TextFormField(
  //                       decoration: const InputDecoration(labelText: MyStrings.passwordLabel),
  //                       obscureText: true,

  //                       validator: (value) {
  //                         if (value == null || value.isEmpty) {
  //                           return MyStrings.formValidatorLabel;
  //                         }
  //                         return null;
  //                       },
  //                     ),
  //                   ),
  //                   Padding(
  //                     padding: const EdgeInsets.only(top: 25.0),
  //                     child: Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         ElevatedButton(
  //                           child: const Text(MyStrings.loginButtonLabel),
  //                             onPressed: () {

  //                               //Validate returns true if the form is valid, or false otherwise.
  //                               if (formKey.currentState!.validate()) {
  //                                 // If the form is valid, display a snackbar. In the real world,
  //                                 // you'd often call a server or save the information in a database.

  //                                 Navigator.of(context).push(
  //                                   MaterialPageRoute(
  //                                     builder: (context) =>
  //                                     MyMainPage()
  //                                   )
  //                                 );
  //                               }
  //                             },
  //                         ),
  //                         ElevatedButton(
  //                           child: const Text(MyStrings.registerButtonLabel),
  //                             onPressed: () {

  //                               //Validate returns true if the form is valid, or false otherwise.
  //                               if (formKey.currentState!.validate()) {
  //                                 // If the form is valid, display a snackbar. In the real world,
  //                                 // you'd often call a server or save the information in a database.

  //                                 Navigator.of(context).push(
  //                                   MaterialPageRoute(
  //                                     builder: (context) =>
  //                                     MyMainPage()
  //                                   )
  //                                 );
  //                               }
  //                             },
  //                         )
  //                       ]
  //                     ),
  //                   )
  //                 ],
  //               )
  //             )
  //           );
  //         }
  //       )
  //     )
  //   )
  // );
// }
}
