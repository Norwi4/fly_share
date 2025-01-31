import 'package:signalr_netcore/http_connection_options.dart';
import 'package:signalr_netcore/hub_connection_builder.dart';

class WebSocketService {
  final String url;
  final String token;

  WebSocketService({required this.url, required this.token});

  Future<void> sendMessage(String chatId, String message) async {
    final connection = HubConnectionBuilder()
        .withUrl(
      'http://212.109.196.24:5045/chathub',
      options: HttpConnectionOptions(
        accessTokenFactory: () async => this.token,
      ),
    )
        .build();

    try {
      print('Попытка подключения к SignalR...');
      await connection.start();
      print('Успешное подключение к SignalR');

      print('Попытка отправить сообщение в чат $chatId: $message');
      await connection.invoke('SendMessageToChat', args: [chatId, message]);
      print('Сообщение успешно отправлено');

      await connection.stop();
      print('Соединение SignalR закрыто');
    } catch (e) {
      print('Ошибка при отправке сообщения: $e');
    }
  }
}

