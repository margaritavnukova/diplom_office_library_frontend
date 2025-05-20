import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'dart:convert';

import '../assets/strings.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String? _selectedRole = 'User';
  bool _isLoading = false;
  final List<String> _roles = ['User', 'Admin', 'Manager'];

  // Создаем маску для ввода номера в формате "+7(999)999-99-99"
  final phoneInputFormatter = MaskTextInputFormatter(
    mask: '+7(###)###-##-##',
    filter: {"#": RegExp(r'[0-9]')}, // Разрешаем ввод только цифр
  );

  // Создаем маску для ввода почты
  final emailInputFormatter = MaskTextInputFormatter(
    mask: '###################################',
    filter: {"#": RegExp(r"[a-zA-Z0-9@._-]")}, 
  );

  // Создаем маску для ввода имени и фамилии
  final nameInputFormatter = MaskTextInputFormatter(
  mask: 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX', // несколько символов X
  filter: {
    "X": RegExp(r'[a-zA-Zа-яА-ЯёЁ\s\-]'), // Буквы, пробел и дефис
  },
);

  // Создаем маску для ввода пароля
  final passwordInputFormatter = MaskTextInputFormatter(
    mask: '*************************', // 25 звездочек = 25 любых символов
  filter: {"*": RegExp(r'.')}, // Любой символ
  );

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse(UriStrings.registerUri),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'UserName': _usernameController.text,
          'Email': _emailController.text,
          'Password': _passwordController.text,
          'PhoneNumber': _phoneController.text,
          'Role': _selectedRole,
        }),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Регистрация прошла успешно!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Ошибка регистрации');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_add, color: Colors.deepPurple),
            SizedBox(width: 10),
            Text(
              'Регистрация',
              style: TextStyle(
                fontFamily: 'Bookman Old Style',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple[900],
              ),
            ),
          ],
        ),
        backgroundColor: Colors.deepPurple[100],
        centerTitle: true,
      ),
      backgroundColor: Colors.deepPurple[50],
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTextFieldWithIcon(
                    Icons.person,
                    'Имя пользователя',
                    _usernameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Введите имя пользователя';
                      }
                      return null;
                    }, formatter: nameInputFormatter,
                  ),
                  SizedBox(height: 20),
                  _buildTextFieldWithIcon(
                    Icons.email,
                    'Email',
                    _emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Введите email';
                      }
                      if (!value.contains('@')) {
                        return 'Введите корректный email';
                      }
                      return null;
                    }, formatter: emailInputFormatter,
                  ),
                  SizedBox(height: 20),
                  _buildTextFieldWithIcon(
                    Icons.lock,
                    'Пароль',
                    _passwordController,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Введите пароль';
                      }
                      if (value.length < 6) {
                        return 'Пароль должен быть не менее 6 символов';
                      }
                      return null;
                    }, formatter: passwordInputFormatter,
                  ),
                  SizedBox(height: 20),
                  _buildTextFieldWithIcon(
                    Icons.phone,
                    'Телефон',
                    _phoneController,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Введите номер телефона';
                      }
                      if (value.length < 11) {
                        return 'Номер телефона должен быть не менее 11 символов';
                      }
                      return null;
                    }, formatter: phoneInputFormatter,
                  ),
                  SizedBox(height: 20),
                  _buildDropdownWithIcon(
                    Icons.people,
                    'Роль',
                    _selectedRole!,
                    _roles,
                    (value) => setState(() => _selectedRole = value),
                  ),
                  SizedBox(height: 30),
                  _buildActionButton(
                    Icons.person_add,
                    'Зарегистрировать',
                    Colors.deepPurple,
                    _isLoading ? null : _register,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFieldWithIcon(
    IconData icon,
    String label,
    TextEditingController controller, {
    bool obscureText = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    required MaskTextInputFormatter formatter,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      inputFormatters: [formatter],
      style: TextStyle(fontSize: 18),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(fontSize: 16, color: Colors.deepPurple[700]),
        prefixIcon: Icon(icon, color: Colors.deepPurple),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.deepPurple),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.deepPurple),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.deepPurple, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.red),
        ),
      ),
    );
  }

  Widget _buildDropdownWithIcon(
    IconData icon,
    String label,
    String value,
    List<String> items,
    Function(String?) onChanged,
  ) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(fontSize: 16, color: Colors.deepPurple[700]),
        prefixIcon: Icon(icon, color: Colors.deepPurple),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.deepPurple),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          items: items.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: TextStyle(fontSize: 18),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildActionButton(
    IconData icon,
    String text,
    Color color,
    VoidCallback? onPressed,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        icon: Icon(icon, size: 24, color: Colors.white),
        label: Text(
          text,
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}