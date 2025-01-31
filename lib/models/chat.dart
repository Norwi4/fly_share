class Chat {
  final String id;
  final String name;
  final String lastMessage;

  Chat({
    required this.id,
    required this.name,
    required this.lastMessage,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['id'],
      name: json['name'],
      lastMessage: json['lastMessage'] ?? 'Нет сообщений',
    );
  }
}
