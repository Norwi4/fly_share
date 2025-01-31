import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/message_bloc.dart';
import '../models/message.dart';
import '../services/api_service.dart';
import '../widgets/message_bubble.dart';

class ChatDetailScreen extends StatefulWidget {
  final String chatId;

  ChatDetailScreen({required this.chatId});

  @override
  _ChatDetailScreenState createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Прокручиваем список вниз после загрузки сообщений
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print('Построение экрана чата для chatId: ${widget.chatId}');
    return Scaffold(
      appBar: AppBar(
        title: Text('Чат'),
      ),
      body: BlocProvider(
        create: (context) => MessageBloc(
          apiService: ApiService(),
          chatId: widget.chatId,
        )..loadMessages(),
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<MessageBloc, List<Message>>(
                builder: (context, messages) {
                  print('Обновление списка сообщений: ${messages.length} шт.');

                  // Прокручиваем список вниз после обновления сообщений
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (_scrollController.hasClients) {
                      _scrollController.animateTo(
                        _scrollController.position.maxScrollExtent,
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                      );
                    }
                  });

                  return ListView.builder(
                    controller: _scrollController, // Добавляем контроллер
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      return MessageBubble(message: message);
                    },
                  );
                },
              ),
            ),
            _MessageInput(chatId: widget.chatId),
          ],
        ),
      ),
    );
  }
}

class _MessageInput extends StatelessWidget {
  final String chatId;

  _MessageInput({required this.chatId});

  @override
  Widget build(BuildContext context) {
    final messageBloc = BlocProvider.of<MessageBloc>(context);
    final textController = TextEditingController();

    return Container(
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: textController,
              decoration: InputDecoration(
                hintText: 'Введите сообщение...',
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              final message = textController.text;
              if (message.isNotEmpty) {
                print('Пользователь нажал кнопку отправки сообщения: $message');
                messageBloc.sendMessage(message);
                textController.clear();
              }
            },
          ),
        ],
      ),
    );
  }
}