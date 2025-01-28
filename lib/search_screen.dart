import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _fromController = TextEditingController();
  TextEditingController _toController = TextEditingController();
  List<String> popularDestinations = [
    "Нью-Йорк",
    "Лондон",
    "Париж",
    "Токио",
    "Сидней",
    "Берлин",
    "Рим",
    "Мадрид",
    "Дубай",
    "Торонто"
  ];

  @override
  void initState() {
    super.initState();
    _loadCachedLocation();
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

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      body: Container(
        color: themeProvider.isDarkMode ? Colors.black : Colors.white, // Фон в зависимости от темы
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
                color: themeProvider.isDarkMode ? Colors.grey[800] : Colors.blue, // Цвет фона блока ввода
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
                      fillColor: themeProvider.isDarkMode ? Colors.grey[700] : Colors.white, // Фон для текстового поля
                    ),
                    style: TextStyle(color: themeProvider.isDarkMode ? Colors.white : Colors.black), // Цвет текста
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _toController,
                    decoration: InputDecoration(
                      hintText: 'Куда',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: themeProvider.isDarkMode ? Colors.grey[700] : Colors.white, // Фон для текстового поля
                    ),
                    style: TextStyle(color: themeProvider.isDarkMode ? Colors.white : Colors.black), // Цвет текста
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
                color: themeProvider.isDarkMode ? Colors.grey[800] : Colors.blue, // Цвет фона блока популярных маршрутов
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Популярные маршруты',
                    style:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: themeProvider.isDarkMode ? Colors.white : Colors.black), // Цвет заголовка
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: 120, // Высота контейнера для скроллируемых объектов
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: popularDestinations.length,
                      itemBuilder: (context, index) {
                        return Container(
                          width: 100, // Ширина каждого квадрата
                          margin:
                          EdgeInsets.symmetric(horizontal: 8.0),
                          decoration:
                          BoxDecoration(color:
                          themeProvider.isDarkMode ? Colors.grey[800] : Colors.blue, // иконки
                              borderRadius:
                              BorderRadius.circular(8.0)),
                          child:
                          Column(mainAxisAlignment:
                          MainAxisAlignment.center,
                              children:[
                                Expanded(child:
                                ClipRRect(borderRadius:
                                BorderRadius.circular(8.0),
                                    child:
                                    Image.network('https://yt3.ggpht.com/ytc/AKedOLS7Nzy4zKW-CoHoGHk3y1_lKxJwGAJ-tu_Wpf357Q=s900-c-k-c0x00ffffff-no-rj', fit:
                                    BoxFit.cover))),
                                SizedBox(height:
                                5),
                                Text(popularDestinations[index],
                                    style:
                                    TextStyle(color:
                                    Colors.white)), // Цвет текста города под квадратом
                              ]),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
