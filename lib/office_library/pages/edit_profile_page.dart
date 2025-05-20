import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../classes/reader_class.dart';
import '../classes/edit_profile_page_methods.dart';

class EditProfilePage extends StatefulWidget {
  final Reader reader;

  const EditProfilePage({super.key, required this.reader});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late EditProfileBloc _bloc;

  // Создаем маску для ввода номера в формате "+7(999)999-99-99"
  final phoneMaskFormatter = MaskTextInputFormatter(
    mask: '+7(###)###-##-##',
    filter: {"#": RegExp(r'[0-9]')}, // Разрешаем ввод только цифр
  );

  @override
  void initState() {
    super.initState();
    _bloc = EditProfileBloc(reader: widget.reader);
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    try {
      final updatedReader = await _bloc.saveChanges();
      if (!mounted) return;
      
      Navigator.pop(context, updatedReader);
      
    } catch (e) {
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка при сохранении: ${e.toString()}'),
          duration: const Duration(seconds: 3),
        ),
      );
      
      Navigator.pop(context, null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Редактирование профиля'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _bloc.isLoading ? null : _saveChanges,
          ),
        ],
      ),
      body: _bloc.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Аватар и кнопка смены фото
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.grey[200],
                          backgroundImage: _bloc.getAvatarImage(),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.camera_alt, color: Colors.white),
                              onPressed: _bloc.pickImage,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Поля для редактирования
                  TextFormField(
                    controller: _bloc.nameController,
                    decoration: const InputDecoration(
                      labelText: 'Имя',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  TextFormField(
                    controller: _bloc.emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email),
                    ),
                    readOnly: true,
                  ),
                  const SizedBox(height: 16),
                  
                  TextFormField(
                    controller: _bloc.phoneController,
                    inputFormatters: [phoneMaskFormatter],
                    decoration: const InputDecoration(
                      labelText: 'Телефон',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.phone),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 24),
                  
                  // Кнопка сохранения
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _bloc.isLoading ? null : _saveChanges,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'Сохранить изменения',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}