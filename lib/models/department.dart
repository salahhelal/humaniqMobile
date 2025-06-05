import 'user.dart';

class Department {
  final int id;
  final String name;
  final String head;
  final String location;
  final double budget;
  final String createdDate;
  final List<User> employees;

  Department({
    required this.id,
    required this.name,
    required this.head,
    required this.location,
    required this.budget,
    required this.createdDate,
    required this.employees,
  });

  factory Department.fromJson(Map<String, dynamic> json) {
    return Department(
      id: json['id'],
      name: json['name'],
      head: json['head'] ?? json['headOfDepartment'] ?? '',
      location: json['location'] ?? '',
      budget: (json['budget'] is int) ? (json['budget'] as int).toDouble() : (json['budget'] ?? 0.0),
      createdDate: json['createdDate'] ?? '',
      employees: (json['employees'] as List?)?.map((e) => User.fromJson(e)).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'head': head,
        'location': location,
        'budget': budget,
        'createdDate': createdDate,
        'employees': employees.map((e) => e.toJson()).toList(),
      };
} 