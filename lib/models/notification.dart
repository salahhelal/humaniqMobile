class AppNotification {
  final int id;
  final String title;
  final String message;
  final String time;
  final bool isRead;
  final bool isImportant;

  AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.time,
    required this.isRead,
    required this.isImportant,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'],
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      time: json['time'] ?? '',
      isRead: json['isRead'] ?? false,
      isImportant: json['isImportant'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'message': message,
        'time': time,
        'isRead': isRead,
        'isImportant': isImportant,
      };
} 