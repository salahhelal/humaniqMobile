import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/leave_request_provider.dart';
import '../models/leave_request.dart';
import '../providers/user_provider.dart';
import 'package:file_picker/file_picker.dart';

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
  String? _selectedFilePath;

  final List<String> _leaveTypes = [
    'Annual Leave',
    'Sick Leave',
    'Personal Leave',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    // Fetch dynamic leave requests from backend via provider
    Future.microtask(() {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final username = userProvider.user?.username ?? '';
      Provider.of<LeaveRequestProvider>(context, listen: false).fetchLeaveRequests(username);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Request Leave'),
      ),
      body: Consumer<LeaveRequestProvider>(
        builder: (context, leaveProvider, _) {
          if (leaveProvider.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (leaveProvider.error != null) {
            return Center(child: Text('Error: \\${leaveProvider.error}'));
          }
          // Dynamic data: leave requests from provider
          final leaveRequests = leaveProvider.leaveRequests;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLeaveBalanceCard(leaveRequests),
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
                const SizedBox(height: 24),
                Text('My Leave Requests', style: Theme.of(context).textTheme.titleMedium),
                ...leaveRequests.map((req) => ListTile(
                  title: Text(req.type),
                  subtitle: Text('${req.startDate} to ${req.endDate}'),
                  trailing: Text(req.status),
                )),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildLeaveBalanceCard(List<LeaveRequest> leaveRequests) {
    // Calculate balances from leaveRequests
    final Map<String, int> used = {
      'Annual Leave': 0,
      'Sick Leave': 0,
      'Personal Leave': 0,
    };
    for (var req in leaveRequests) {
      if (used.containsKey(req.type)) {
        used[req.type] = used[req.type]! + 1;
      }
    }
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
            _buildLeaveBalanceRow('Annual Leave', used['Annual Leave']!, 20),
            _buildLeaveBalanceRow('Sick Leave', used['Sick Leave']!, 10),
            _buildLeaveBalanceRow('Personal Leave', used['Personal Leave']!, 5),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaveBalanceRow(String type, int used, int total) {
    final double percentage = total == 0 ? 0 : used / total;
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
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                icon: const Icon(Icons.attach_file),
                label: const Text('Attach File'),
                onPressed: () async {
                  FilePickerResult? result = await FilePicker.platform.pickFiles();
                  if (result != null && result.files.single.path != null) {
                    setState(() {
                      _selectedFilePath = result.files.single.path;
                    });
                  }
                },
              ),
            ),
            if (_selectedFilePath != null)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    _selectedFilePath!.split('/').last,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
          ],
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

  void _submitLeaveRequest() async {
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

    final provider = Provider.of<LeaveRequestProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final email = userProvider.user?.email ?? '';
    await provider.submitLeaveRequest({
      'type': _selectedLeaveType,
      'startDate': _startDate?.toIso8601String(),
      'endDate': _endDate?.toIso8601String(),
      'reason': _reasonController.text,
    }, email, _selectedFilePath);
    if (provider.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${provider.error}')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Leave request submitted!')),
      );
      _reasonController.clear();
      setState(() {
        _startDate = null;
        _endDate = null;
        _selectedLeaveType = 'Annual Leave';
        _selectedFilePath = null;
      });
    }
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }
}