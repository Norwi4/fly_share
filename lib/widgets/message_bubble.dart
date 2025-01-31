import 'package:flutter/material.dart';
import '../models/message.dart';

class MessageBubble extends StatelessWidget {
  final Message message;

  MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      padding: EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: message.senderId == 'me' ? Colors.blue : Colors.grey[300],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Text(message.text),
    );
  }
}