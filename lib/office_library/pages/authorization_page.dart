import 'package:flutter/material.dart';
import 'bookcrossing_main.dart';
import '../classes/auth.dart';
import '../assets/strings.dart';
import '../classes/reader_class.dart';
import '../classes/fetch_data.dart';

class MyAuthorization extends StatefulWidget{
  const MyAuthorization({super.key});

  @override
  _MyAuthorization createState() => _MyAuthorization();
}

class _MyAuthorization extends State<MyAuthorization>{
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final Auth apiService = Auth();
  final emailSuffix = "@mail.com";

  @override
  void initState() {
    emailController.addListener(_onTextChanged);
  }

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

                  var readerReturned = Auth.user;

                  Navigator.pushReplacement(
                    context, 
                    MaterialPageRoute(builder: (context) => MyMainPage(reader: readerReturned)),
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

  void _onTextChanged() {
    final text = emailController.text;
    if (!text.endsWith(emailSuffix)){
      final newText = text + emailSuffix;
      emailController.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: text.length)
      );
    }
  }
}
