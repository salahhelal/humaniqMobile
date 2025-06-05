import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/payslip_provider.dart';
import '../models/payslip.dart';

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
      body: Consumer<PayslipProvider>(
        builder: (context, payslipProvider, _) {
          if (payslipProvider.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (payslipProvider.error != null) {
            return Center(child: Text('Error: \\${payslipProvider.error}'));
          }
          final payslips = payslipProvider.payslips;
          if (payslips.isEmpty) {
            return const Center(child: Text('No payslips found.'));
          }
          return SingleChildScrollView(
            child: Column(
              children: [
                _buildSalaryOverview(payslips.first),
                const Divider(height: 1),
                _buildPayslipsList(payslips),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSalaryOverview(Payslip payslip) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Salary Overview',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${payslip.month}/${payslip.year}',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSalaryItem(
                  'Base Salary',
                  payslip.baseSalary.toStringAsFixed(2),
                  Icons.money,
                  Colors.green,
                ),
                _buildSalaryItem(
                  'Bonuses',
                  payslip.bonuses.toStringAsFixed(2),
                  Icons.star,
                  Colors.orange,
                ),
                _buildSalaryItem(
                  'Deductions',
                  payslip.deductions.toStringAsFixed(2),
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

  Widget _buildPayslipsList(List<Payslip> payslips) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: payslips.length,
      itemBuilder: (context, index) {
        final payslip = payslips[index];
        return ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.receipt),
          ),
          title: Text('${payslip.year} - ${payslip.month.toString().padLeft(2, '0')}'),
          subtitle: Text('Net Salary: ${payslip.netSalary.toStringAsFixed(2)}'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showPayslipDetails(context, payslip),
        );
      },
    );
  }

  void _showFilterDialog(BuildContext context) {
    final yearController = TextEditingController();
    final monthController = TextEditingController();
    final provider = Provider.of<PayslipProvider>(context, listen: false);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Payslips'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: yearController,
              decoration: const InputDecoration(labelText: 'Year'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: monthController,
              decoration: const InputDecoration(labelText: 'Month'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              int? year = int.tryParse(yearController.text);
              int? month = int.tryParse(monthController.text);
              await provider.filterPayslips(year: year, month: month);
              if (provider.error != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: ${provider.error}')),
                );
              }
              Navigator.pop(context);
            },
            child: provider.loading ? const CircularProgressIndicator() : const Text('Apply'),
          ),
        ],
      ),
    );
  }

  void _showPayslipDetails(BuildContext context, Payslip payslip) {
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
          return Column(
            children: [
              AppBar(
                title: Text('Payslip Details - ${payslip.year}/${payslip.month.toString().padLeft(2, '0')}'),
                leading: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.download),
                    onPressed: () async {
                      final provider = Provider.of<PayslipProvider>(context, listen: false);
                      await provider.downloadPayslip(payslip.id);
                      if (provider.error != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error: ${provider.error}')),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Payslip downloaded!')),
                        );
                      }
                    },
                  ),
                ],
              ),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  children: [
                    _buildPayslipSection('Earnings', [
                      _buildPayslipRow('Base Salary', payslip.baseSalary.toStringAsFixed(2)),
                      _buildPayslipRow('Bonuses', payslip.bonuses.toStringAsFixed(2)),
                    ]),
                    const Divider(),
                    _buildPayslipSection('Deductions', [
                      _buildPayslipRow('Deductions', payslip.deductions.toStringAsFixed(2)),
                    ]),
                    const Divider(),
                    _buildPayslipSection('Net Salary', [
                      _buildPayslipRow('Total', payslip.netSalary.toStringAsFixed(2)),
                    ]),
                  ],
                ),
              ),
            ],
          );
        },
      ),
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