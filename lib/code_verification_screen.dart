import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      final token = 'token_for_${widget.phone}'; // Создаем токен на основе номера телефона

      // Сохранение токена в SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);

      // Переход на главный экран и удаление всех предыдущих экранов из стека
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => HomeScreen()),
            (Route<dynamic> route) => false,
      );
    } else {
      // Обработка неверного кода
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Неверный код')),
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
