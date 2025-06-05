class LeaveRequest {
  final int id;
  final int userId;
  final String type;
  final String status;
  final String startDate;
  final String endDate;
  final String reason;

  LeaveRequest({
    required this.id,
    required this.userId,
    required this.type,
    required this.status,
    required this.startDate,
    required this.endDate,
    required this.reason,
  });

  factory LeaveRequest.fromJson(Map<String, dynamic> json) {
    return LeaveRequest(
      id: json['id'],
      userId: json['userId'],
      type: json['type'] ?? '',
      status: json['status'] ?? '',
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
      reason: json['reason'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'type': type,
        'status': status,
        'startDate': startDate,
        'endDate': endDate,
        'reason': reason,
      };
} 