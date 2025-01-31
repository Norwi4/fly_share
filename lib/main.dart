import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home_screen.dart'; // Экран "Искать"
import 'login_screen.dart'; // Экран авторизации
import 'profile_screen.dart'; // Экран профиля
import 'theme_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Грузоперевозки',
          theme: themeProvider.currentTheme,
          home: CheckAuthScreen(), // Проверка авторизации
        );
      },
    );
  }
}

class CheckAuthScreen extends StatelessWidget {
  Future<bool> _checkIfLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    return token != null; // Если токен существует, возвращаем true
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkIfLoggedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Показываем индикатор загрузки, пока идет проверка
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.data == true) {
          // Если пользователь авторизован, показываем экран "Искать"
          return HomeScreen();
        } else {
          // Если пользователь не авторизован, показываем экран авторизации
          return LoginScreen();
        }
      },
    );
  }
}
