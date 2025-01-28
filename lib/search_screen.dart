import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

    String currentLocation = "${placemarks[0].locality ?? ''}, ${placemarks[0].country ?? ''}".trim();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('cached_location', currentLocation);

    setState(() {
      _fromController.text = currentLocation;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: Container(
        color: Colors.black, // Темный фон для всего приложения
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              child: Text("Доставим все", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),)

            ),
            SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[800], // Светлее фон для блока ввода
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
                      fillColor: Colors.grey[700], // Фон для текстового поля
                    ),
                    style: TextStyle(color: Colors.white), // Цвет текста
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _toController,
                    decoration: InputDecoration(
                      hintText: 'Куда',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.grey[700], // Фон для текстового поля
                    ),
                    style: TextStyle(color: Colors.white), // Цвет текста
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
                color: Colors.grey[800], // Светлее фон для блока популярных маршрутов
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Популярные маршруты',
                    style:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white), // Цвет заголовка
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
                          margin: EdgeInsets.symmetric(horizontal: 8.0),
                          decoration: BoxDecoration(
                            color: Colors.blueGrey,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius:
                                  BorderRadius.circular(8.0), // Закругление углов изображения
                                  child:
                                  Image.network('https://via.placeholder.com/100', fit: BoxFit.cover),
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(popularDestinations[index],
                                  style:
                                  TextStyle(color: Colors.white)), // Цвет текста города под квадратом
                            ],
                          ),
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
