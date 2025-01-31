import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/message.dart';
import '../services/api_service.dart';
import '../services/websocket_service.dart';

class MessageBloc extends Cubit<List<Message>> {
  final ApiService apiService;
  final String chatId;

  MessageBloc({
    required this.apiService,
    required this.chatId,
  }) : super([]) {
    loadMessages();
  }

  Future<void> loadMessages() async {
    print('Загрузка сообщений для чата $chatId');
    try {
      final messages = await apiService.getMessages(chatId);
      print('Сообщения успешно загружены: ${messages.length} шт.');
      emit(messages);
    } catch (e) {
      print('Ошибка при загрузке сообщений: $e');
      emit([]);
    }
  }

  Future<void> sendMessage(String message) async {
    print('Попытка отправить сообщение в чат $chatId: $message');

    // Получаем токен из SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      print('Токен не найден. Сообщение не отправлено.');
      return;
    }

    // Создаем экземпляр WebSocketService и отправляем сообщение
    final webSocketService = WebSocketService(
      url: 'ws://212.109.196.24:5045/chathub',
      token: token,
    );

    await webSocketService.sendMessage(chatId, message);

    // После отправки сообщения обновляем список сообщений
    loadMessages();
  }
}