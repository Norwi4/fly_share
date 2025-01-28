import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled2/code_verification_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();

  Future<void> _sendCode() async {
    final phone = _phoneController.text;

    // Эмуляция задержки, как если бы происходил сетевой запрос
    await Future.delayed(Duration(seconds: 2));

    // Здесь вы можете добавить логику отправки SMS с кодом
    // Эмулируем успешную отправку кода
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CodeVerificationScreen(phone: phone),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Авторизация')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: 'Номер телефона'),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _sendCode,
              child: Text('Отправить код'),
            ),
          ],
        ),
      ),
    );
  }
}
