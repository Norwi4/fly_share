import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/chat.dart';
import '../services/api_service.dart';

class ChatBloc extends Cubit<List<Chat>> {
  final ApiService apiService;

  ChatBloc({required this.apiService}) : super([]);

  void loadChats() async {
    try {
      final chats = await apiService.getChats();
      emit(chats);
    } catch (e) {
      emit([]);
    }
  }
}