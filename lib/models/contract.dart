class Contract {
  final int id;
  final String type;
  final String description;
  final String startDate;
  final String endDate;
  final String status;
  final int employeeId;

  Contract({
    required this.id,
    required this.type,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.employeeId,
  });

  factory Contract.fromJson(Map<String, dynamic> json) {
    return Contract(
      id: json['id'],
      type: json['type'] ?? json['contractType'] ?? '',
      description: json['description'] ?? '',
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
      status: json['status'] ?? '',
      employeeId: json['employeeId'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'description': description,
        'startDate': startDate,
        'endDate': endDate,
        'status': status,
        'employeeId': employeeId,
      };
} 