import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // Импортируем для работы с JSON
import 'package:provider/provider.dart';
import 'theme_provider.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _fromController = TextEditingController();
  TextEditingController _toController = TextEditingController();
  List<dynamic> deliveryOrders = []; // Список для хранения данных о доставках
  bool isLoading = true; // Состояние загрузки

  @override
  void initState() {
    super.initState();
    _loadCachedLocation();
    _fetchDeliveryOrders(); // Получаем данные о доставках при инициализации
  }

  Future<void> _loadCachedLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cachedLocation = prefs.getString('cached_location');

    if (cachedLocation != null) {
      setState(() {
        _fromController.text = cachedLocation;
      });
    } else {
      await _getCurrentLocation();
    }
  }

  Future<void> _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

    String currentLocation = (placemarks[0].locality ?? '').trim();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('cached_location', currentLocation);

    setState(() {
      _fromController.text = currentLocation;
    });
  }

  Future<void> _fetchDeliveryOrders() async {
    final url = Uri.parse('http://212.109.196.24:5045/api/DeliveryOrders/GetAllDeliveryOrders');

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token'); // Получаем токен из SharedPreferences

      setState(() {
        isLoading = true; // Устанавливаем состояние загрузки
      });

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Добавляем токен в заголовок
        },
      );

      if (response.statusCode == 200) {
        // Если запрос успешен, парсим ответ
        final List<dynamic> jsonResponse = jsonDecode(response.body);

        setState(() {
          deliveryOrders = jsonResponse; // Сохраняем данные о доставках в список
          isLoading = false; // Сбрасываем состояние загрузки
        });
      } else {
        // Обработка ошибки при запросе
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка при получении данных: ${response.reasonPhrase}')),
        );
        setState(() {
          isLoading = false; // Сбрасываем состояние загрузки даже в случае ошибки
        });
      }
    } catch (e) {
      // Обработка исключений
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Произошла ошибка: $e')),
      );
      setState(() {
        isLoading = false; // Сбрасываем состояние загрузки даже в случае ошибки
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      body: Container(
        color: themeProvider.isDarkMode ? Colors.black : Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 80),
            Container(
              child: Text(
                "Доставим все",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: themeProvider.isDarkMode ? Colors.white : Colors.black),
              ),
            ),
            SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: themeProvider.isDarkMode ? Colors.grey[800] : Colors.blue,
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _fromController,
                    decoration: InputDecoration(
                      hintText: 'Откуда',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: themeProvider.isDarkMode ? Colors.grey[700] : Colors.white,
                    ),
                    style: TextStyle(color: themeProvider.isDarkMode ? Colors.white : Colors.black),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _toController,
                    decoration: InputDecoration(
                      hintText: 'Куда',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: themeProvider.isDarkMode ? Colors.grey[700] : Colors.white,
                    ),
                    style: TextStyle(color: themeProvider.isDarkMode ? Colors.white : Colors.black),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      print('Откуда: ${_fromController.text}, Куда: ${_toController.text}');
                    },
                    child: Text('Найти маршрут', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: themeProvider.isDarkMode ? Colors.grey[800] : Colors.blue,
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding: const EdgeInsets.all(16.0),
              child:
              Column(crossAxisAlignment:
              CrossAxisAlignment.start,
                children:[
                  Text(
                    'Популярные маршруты',
                    style:
                    TextStyle(fontSize:
                    18, fontWeight:
                    FontWeight.bold, color:
                    themeProvider.isDarkMode ? Colors.white : Colors.black),
                  ),
                  SizedBox(height:
                  10),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 500), // Длительность анимации
                    color:
                    isLoading ? (themeProvider.isDarkMode ? Colors.grey[700] : Colors.grey[300]) : (themeProvider.isDarkMode ? Colors.grey[800] : Colors.blue), // Цвет фона в зависимости от состояния загрузки
                    height:
                    isLoading ? 120 : null, // Высота контейнера для скроллируемых объектов
                    child:
                    isLoading
                        ? Center(child:
                    CircularProgressIndicator()) // Индикатор загрузки во время запроса
                        : Container( // Используем Container для ограничения высоты списка
                      height: 120, // Ограничиваем высоту списка
                      child:
                      ListView.builder(
                        scrollDirection:
                        Axis.horizontal, // Устанавливаем горизонтальную прокрутку
                        itemCount:
                        deliveryOrders.length,
                        itemBuilder:
                            (context, index) {
                          final order =
                          deliveryOrders[index];
                          final avatarBase64 =
                          order['avatar']; // Получаем аватар в base64

                          // Декодируем base64 строку в изображение
                          ImageProvider avatarImage =
                          avatarBase64.isNotEmpty ?
                          MemoryImage(base64Decode(avatarBase64)) :
                          AssetImage('assets/default_avatar.png'); // Путь к изображению по умолчанию

                          return Container(
                            width:
                            100, // Ширина каждого элемента
                            margin:
                            EdgeInsets.symmetric(horizontal:
                            8.0),
                            decoration:
                            BoxDecoration(color:
                            themeProvider.isDarkMode ? Colors.grey[800] : Colors.blue,
                                borderRadius:
                                BorderRadius.circular(8.0)),
                            child:
                            Column(mainAxisAlignment:
                            MainAxisAlignment.center,
                                children:[
                                  CircleAvatar(
                                    backgroundImage:
                                    avatarImage,
                                    radius:
                                    25, // Радиус аватара для создания круглого изображения
                                  ),
                                  SizedBox(height:
                                  5),
                                  Text('${order['from']} - ',
                                      style:
                                      TextStyle(color:
                                      Colors.white)),
                                  Text('${order['to']}',
                                      style:
                                      TextStyle(color:
                                      Colors.white)),
                                  Text(order['name'],
                                      style:
                                      TextStyle(color:
                                      Colors.red)), // Цвет текста имени
                                ]),
                          );
                        },
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
