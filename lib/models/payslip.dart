class Payslip {
  final int id;
  final int month;
  final int year;
  final double baseSalary;
  final double bonuses;
  final double deductions;
  final double netSalary;

  Payslip({
    required this.id,
    required this.month,
    required this.year,
    required this.baseSalary,
    required this.bonuses,
    required this.deductions,
    required this.netSalary,
  });

  factory Payslip.fromJson(Map<String, dynamic> json) {
    return Payslip(
      id: json['id'],
      month: json['month'],
      year: json['year'],
      baseSalary: (json['baseSalary'] as num).toDouble(),
      bonuses: (json['bonuses'] as num).toDouble(),
      deductions: (json['deductions'] as num).toDouble(),
      netSalary: (json['netSalary'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'month': month,
        'year': year,
        'baseSalary': baseSalary,
        'bonuses': bonuses,
        'deductions': deductions,
        'netSalary': netSalary,
      };
} 