class Chat {
  final String id;
  final String name;
  final String lastMessage;
  final String lastMessageSentAt;

  Chat({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.lastMessageSentAt,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
        id: json['id'],
        name: json['name'],
        lastMessage: json['lastMessage'] ?? 'Нет сообщений',
        lastMessageSentAt: json['lastMessageSentAt']);
  }
}
