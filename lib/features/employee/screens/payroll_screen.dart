import 'package:flutter/material.dart';

class PayrollScreen extends StatelessWidget {
  const PayrollScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payroll'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildSalaryOverview(),
            const Divider(height: 1),
            _buildPayslipsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildSalaryOverview() {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Salary Overview',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'April 2025',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSalaryItem(
                  'Base Salary',
                  '5,000 DT',
                  Icons.money,
                  Colors.green,
                ),
                _buildSalaryItem(
                  'Bonuses',
                  '500 DT',
                  Icons.star,
                  Colors.orange,
                ),
                _buildSalaryItem(
                  'Deductions',
                  '300 DT',
                  Icons.remove_circle,
                  Colors.red,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSalaryItem(
    String label,
    String amount,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 4),
        Text(
          amount,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildPayslipsList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 12,
      itemBuilder: (context, index) {
        final month = DateTime(2025, 4 - index);
        return _PayslipListItem(
          month: month,
          onTap: () => _showPayslipDetails(context, month),
        );
      },
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Payslips'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildFilterOption('Year', ['2025', '2024', '2023']),
            const SizedBox(height: 16),
            _buildFilterOption(
              'Quarter',
              ['Q1', 'Q2', 'Q3', 'Q4'],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Apply filters
              Navigator.pop(context);
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterOption(String label, List<String> options) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: options.map((option) {
            return ChoiceChip(
              label: Text(option),
              selected: false,
              onSelected: (selected) {
                // TODO: Handle filter selection
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  void _showPayslipDetails(BuildContext context, DateTime month) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) {
          return _PayslipDetailsSheet(
            month: month,
            scrollController: scrollController,
          );
        },
      ),
    );
  }
}

class _PayslipListItem extends StatelessWidget {
  final DateTime month;
  final VoidCallback onTap;

  const _PayslipListItem({
    required this.month,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.receipt),
      ),
      title: Text(
        '${month.year} - ${month.month.toString().padLeft(2, '0')}',
      ),
      subtitle: const Text('Net Salary: 5,200 DT'),
      trailing: const Icon(Icons.chevron_right),
    );
  }
}

class _PayslipDetailsSheet extends StatelessWidget {
  final DateTime month;
  final ScrollController scrollController;

  const _PayslipDetailsSheet({
    required this.month,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          title: Text(
            'Payslip Details - ${month.year}/${month.month.toString().padLeft(2, '0')}',
          ),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.download),
              onPressed: () {
                // TODO: Download payslip
              },
            ),
          ],
        ),
        Expanded(
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.all(16),
            children: [
              _buildPayslipSection(
                'Earnings',
                [
                  _buildPayslipRow('Base Salary', '5,000 DT'),
                  _buildPayslipRow('Overtime', '200 DT'),
                  _buildPayslipRow('Bonuses', '300 DT'),
                ],
              ),
              const Divider(),
              _buildPayslipSection(
                'Deductions',
                [
                  _buildPayslipRow('Tax', '200 DT'),
                  _buildPayslipRow('Insurance', '100 DT'),
                ],
              ),
              const Divider(),
              _buildPayslipSection(
                'Net Salary',
                [_buildPayslipRow('Total', '5,200 DT')],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPayslipSection(String title, List<Widget> rows) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...rows,
      ],
    );
  }

  Widget _buildPayslipRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}