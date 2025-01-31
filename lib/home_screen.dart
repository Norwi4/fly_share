import 'package:flutter/material.dart';
import 'package:untitled2/screens/chat_list_screen.dart'; // Импорт экрана чатов
import 'search_screen.dart';
import 'publish_screen.dart';
import 'trips_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    SearchScreen(),
    PublishScreen(),
    TripsScreen(),
    ChatListScreen(), // Экран чатов
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Устанавливаем фиксированный стиль
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Искать',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Опубликовать',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_car),
            label: 'Ваши поездки',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Чаты',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Профиль',
          ),
        ],
        currentIndex: _currentIndex,
        selectedItemColor: Colors.blueAccent, // Цвет выбранного элемента
        unselectedItemColor: Colors.grey, // Цвет невыбранных элементов
        backgroundColor: Colors.black, // Цвет фона нижнего меню
        onTap: _onItemTapped,
      ),
    );
  }
}