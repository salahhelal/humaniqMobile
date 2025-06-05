class ChatRoom {
  final int id;
  final String name;
  final List<int> users;
  final String? lastMessage;

  ChatRoom({
    required this.id,
    required this.name,
    required this.users,
    this.lastMessage,
  });

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    return ChatRoom(
      id: json['id'],
      name: json['name'] ?? '',
      users: List<int>.from(json['users'] ?? []),
      lastMessage: json['lastMessage'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'users': users,
        'lastMessage': lastMessage,
      };
} 