import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/chat.dart';
import '../screens/chat_detail_screen.dart';

class ChatItem extends StatelessWidget {
  final Chat chat;

  ChatItem({required this.chat});

  String _formatTime(String sentAt) {
    final dateTime = DateTime.parse(sentAt); // Преобразуем строку в DateTime
    final formattedTime = DateFormat('HH:mm').format(dateTime); // Форматируем время
    return formattedTime;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        // Здесь можно добавить аватарку чата, если она есть
        child: Text(chat.name[0]), // Первая буква имени чата как аватар
      ),
      title: Text(chat.name),
      subtitle: Text(
        chat.lastMessage,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Text(
        _formatTime(chat.lastMessageSentAt),
        style: TextStyle(color: Colors.grey),
      ),
      onTap: () {
        // Переход на экран чата
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatDetailScreen(chatId: chat.id),
          ),
        );
      },
    );
  }
}