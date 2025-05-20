import 'package:flutter/material.dart';
import 'bookcrossing_main.dart';
import '../classes/auth.dart';
import '../assets/strings.dart';

class MyAuthorization extends StatefulWidget {
  const MyAuthorization({super.key});

  @override
  _MyAuthorization createState() => _MyAuthorization();
}

class _MyAuthorization extends State<MyAuthorization> {
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
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_rounded, color: Colors.deepPurple),
            SizedBox(width: 10),
            const Text(
              'Авторизация',
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
        backgroundColor: Colors.deepPurple[100],
      ),
      backgroundColor: Colors.deepPurple[50],
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.66,
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.account_circle,
                size: 80,
                color: Colors.deepPurple,
              ),
              const SizedBox(height: 30),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: const TextStyle(fontSize: 18),
                  prefixIcon: const Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Пароль',
                  labelStyle: const TextStyle(fontSize: 18),
                  prefixIcon: const Icon(Icons.lock),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                obscureText: true,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () async {
                          try {
                            await apiService.login(
                              emailController.text, 
                              passwordController.text
                            );

                            var readerReturned = Auth.user;

                            if (mounted && !Navigator.of(context).userGestureInProgress) {
                              Navigator.pushReplacement(
                                context, 
                                MaterialPageRoute(
                                  builder: (context) => MyMainPage(reader: readerReturned)
                                ),
                              );
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  e.toString(),
                                  style: const TextStyle(fontSize: 16),
                                ),
                              )
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          MyStrings.loginButtonLabel,
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Tooltip(
                    message: 'Логин и пароль для входа в систему офисного буккроссинга вы можете получить у администратора',
                    child: IconButton(
                      icon: Icon(Icons.help_outline, color: Colors.deepPurple),
                      onPressed: () {},
                      splashRadius: 20,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onTextChanged() {
    final text = emailController.text;
    if (!text.endsWith(emailSuffix)) {
      final newText = text + emailSuffix;
      emailController.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: text.length)
      );
    }
  }
}