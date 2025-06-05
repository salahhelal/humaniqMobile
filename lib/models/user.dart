class User {
  final int id;
  final String username;
  final String name;
  final String email;
  final String phone;
  final String position;
  final String joinedDate;
  final String department;
  final String? profileImage;

  User({
    required this.id,
    required this.username,
    required this.name,
    required this.email,
    required this.phone,
    required this.position,
    required this.joinedDate,
    required this.department,
    this.profileImage,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'] ?? '',
      name: json['name'] ?? json['fullName'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      position: json['position'] ?? '',
      joinedDate: json['joinedDate'] ?? '',
      department: json['department'] ?? '',
      profileImage: json['profileImage'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'name': name,
        'email': email,
        'phone': phone,
        'position': position,
        'joinedDate': joinedDate,
        'department': department,
        'profileImage': profileImage,
      };
} 