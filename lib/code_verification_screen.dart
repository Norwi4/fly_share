import 'dart:convert'; // Импортируем для работы с JSON
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http; // Импортируем пакет http
import 'home_screen.dart';

class CodeVerificationScreen extends StatefulWidget {
  final String phone;

  CodeVerificationScreen({required this.phone});

  @override
  _CodeVerificationScreenState createState() => _CodeVerificationScreenState();
}

class _CodeVerificationScreenState extends State<CodeVerificationScreen> {
  final TextEditingController _codeController = TextEditingController();

  Future<void> _verifyCode() async {
    final code = _codeController.text;

    // Эмуляция задержки, как если бы происходил сетевой запрос
    await Future.delayed(Duration(seconds: 2));

    // Эмулируем успешную верификацию кода
    if (code == "123456") { // Здесь вы можете использовать любой код для тестирования
      await _login(); // Выполняем запрос на вход
    } else {
      // Обработка неверного кода
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Неверный код')),
      );
    }
  }

  Future<void> _login() async {
    final url = Uri.parse('http://212.109.196.24:5045/api/Accounts/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: '{"email": "babay@gmail.com", "password": "testtestT1!"}', // Ваши данные для входа
    );

    if (response.statusCode == 200) {
      // Если сервер возвращает код 200, значит, запрос успешен
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body); // Парсим ответ

      // Извлекаем токен из ответа
      final token = jsonResponse['token'];

      // Выводим токен в консоль
      print('Token: $token');

      // Сохранение токена в SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);

      // Переход на главный экран и удаление всех предыдущих экранов из стека
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => HomeScreen()),
            (Route<dynamic> route) => false,
      );
    } else {
      // Обработка ошибки при входе
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка при входе: ${response.reasonPhrase}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ввод кода')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Введите код, отправленный на номер ${widget.phone}'),
            TextField(
              controller: _codeController,
              decoration: InputDecoration(labelText: 'Код'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _verifyCode,
              child: Text('Подтвердить'),
            ),
          ],
        ),
      ),
    );
  }
}
