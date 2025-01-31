import 'package:flutter/material.dart';
import '../models/chat.dart';
import '../screens/chat_detail_screen.dart';

class ChatItem extends StatelessWidget {
  final Chat chat;

  ChatItem({required this.chat});

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
        '12:34', // Здесь можно добавить время последнего сообщения, если оно есть
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