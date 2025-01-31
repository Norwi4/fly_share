import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/chat_bloc.dart';
import '../models/chat.dart';
import '../services/api_service.dart';
import '../widgets/chat_item.dart';

class ChatListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Чаты'),
      ),
      body: BlocProvider(
        create: (context) => ChatBloc(apiService: ApiService())..loadChats(),
        child: BlocBuilder<ChatBloc, List<Chat>>(
          builder: (context, chats) {
            return ListView.builder(
              itemCount: chats.length,
              itemBuilder: (context, index) {
                final chat = chats[index];
                return ChatItem(chat: chat);
              },
            );
          },
        ),
      ),
    );
  }
}