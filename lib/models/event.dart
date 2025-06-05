class Event {
  final int id;
  final String title;
  final String location;
  final String date;
  final String time;
  final int participants;

  Event({
    required this.id,
    required this.title,
    required this.location,
    required this.date,
    required this.time,
    required this.participants,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      title: json['title'] ?? '',
      location: json['location'] ?? '',
      date: json['date'] ?? '',
      time: json['time'] ?? '',
      participants: json['participants'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'location': location,
        'date': date,
        'time': time,
        'participants': participants,
      };
} 