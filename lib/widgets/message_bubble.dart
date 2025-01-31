import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Импортируем пакет для форматирования времени
import '../models/message.dart';

class MessageBubble extends StatelessWidget {
  final Message message;
  final bool isMe; // Флаг, указывающий, является ли сообщение своим

  MessageBubble({required this.message, required this.isMe});

  // Метод для форматирования времени
  String _formatTime(DateTime sentAt) {
    final formattedTime = DateFormat('HH:mm').format(sentAt); // Форматируем время
    return formattedTime;
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft, // Выравнивание по краям
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7, // Максимальная ширина 70% экрана
        ),
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          padding: EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: isMe ? Colors.blue : Colors.orange, // Цвет для своих и чужих сообщений
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end, // Выравниваем время по правому краю
            children: [
              Text(
                message.text,
                style: TextStyle(
                  color: Colors.white, // Цвет текста
                ),
                softWrap: true, // Перенос текста на новую строку
              ),
              SizedBox(height: 4.0), // Отступ между текстом и временем
              Text(
                _formatTime(message.sentAt), // Отображаем отформатированное время
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7), // Полупрозрачный белый цвет
                  fontSize: 12.0, // Уменьшаем размер шрифта
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}