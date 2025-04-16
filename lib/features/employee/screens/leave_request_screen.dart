import 'package:flutter/material.dart';

class LeaveRequestScreen extends StatefulWidget {
  const LeaveRequestScreen({super.key});

  @override
  State<LeaveRequestScreen> createState() => _LeaveRequestScreenState();
}

class _LeaveRequestScreenState extends State<LeaveRequestScreen> {
  DateTime? _startDate;
  DateTime? _endDate;
  String _selectedLeaveType = 'Annual Leave';
  final TextEditingController _reasonController = TextEditingController();

  final List<String> _leaveTypes = [
    'Annual Leave',
    'Sick Leave',
    'Personal Leave',
    'Other',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Request Leave'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLeaveBalanceCard(),
            const SizedBox(height: 24),
            _buildLeaveForm(),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitLeaveRequest,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Submit Request'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaveBalanceCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Leave Balance',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildLeaveBalanceRow('Annual Leave', 15, 20),
            _buildLeaveBalanceRow('Sick Leave', 7, 10),
            _buildLeaveBalanceRow('Personal Leave', 3, 5),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaveBalanceRow(String type, int used, int total) {
    final double percentage = used / total;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(type),
              Text('$used/$total days'),
            ],
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: percentage,
            backgroundColor: Colors.grey[200],
          ),
        ],
      ),
    );
  }

  Widget _buildLeaveForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          value: _selectedLeaveType,
          decoration: const InputDecoration(
            labelText: 'Leave Type',
            border: OutlineInputBorder(),
          ),
          items: _leaveTypes.map((type) {
            return DropdownMenuItem(
              value: type,
              child: Text(type),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedLeaveType = value!;
            });
          },
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildDatePicker(
                'Start Date',
                _startDate,
                (date) => setState(() => _startDate = date),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildDatePicker(
                'End Date',
                _endDate,
                (date) => setState(() => _endDate = date),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _reasonController,
          maxLines: 3,
          decoration: const InputDecoration(
            labelText: 'Reason for Leave',
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  Widget _buildDatePicker(
    String label,
    DateTime? selectedDate,
    Function(DateTime?) onDateSelected,
  ) {
    return TextFormField(
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        suffixIcon: const Icon(Icons.calendar_today),
      ),
      controller: TextEditingController(
        text: selectedDate?.toString().substring(0, 10) ?? '',
      ),
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );
        if (picked != null) {
          onDateSelected(picked);
        }
      },
    );
  }

  void _submitLeaveRequest() {
    if (_startDate == null || _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select both start and end dates'),
        ),
      );
      return;
    }

    if (_reasonController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please provide a reason for your leave'),
        ),
      );
      return;
    }

    // TODO: Implement leave request submission
    print('Submitting leave request...');
    print('Type: $_selectedLeaveType');
    print('Start: $_startDate');
    print('End: $_endDate');
    print('Reason: ${_reasonController.text}');
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }
}