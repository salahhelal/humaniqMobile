import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/department_provider.dart';
import '../models/department.dart';

class DepartmentScreen extends StatefulWidget {
  const DepartmentScreen({super.key});

  @override
  State<DepartmentScreen> createState() => _DepartmentScreenState();
}

class _DepartmentScreenState extends State<DepartmentScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch dynamic departments from backend via provider
    Future.microtask(() => Provider.of<DepartmentProvider>(context, listen: false).fetchDepartments());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Departments List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddDepartmentDialog(context),
          ),
        ],
      ),
      body: Consumer<DepartmentProvider>(
        builder: (context, departmentProvider, _) {
          if (departmentProvider.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (departmentProvider.error != null) {
            return Center(child: Text('Error: \\${departmentProvider.error}'));
          }
          // Dynamic data: departments from provider
          final departments = departmentProvider.departments;
          if (departments.isEmpty) {
            return const Center(child: Text('No departments found.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: departments.length,
            itemBuilder: (context, index) {
              final department = departments[index];
              return Card(
                child: ExpansionTile(
                  title: Text(department.name),
                  subtitle: Text('Head of Department: ${department.head}'),
                  leading: const CircleAvatar(
                    child: Icon(Icons.business),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton.icon(
                        icon: const Icon(Icons.people),
                        label: const Text('Employees'),
                        onPressed: () => _showEmployeesList(context, department),
                      ),
                      PopupMenuButton(
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'edit',
                            child: Text('Edit'),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Text('Delete'),
                          ),
                        ],
                        onSelected: (value) {
                          if (value == 'edit') {
                            _showEditDepartmentDialog(context, department: department);
                          } else if (value == 'delete') {
                            _showDeleteConfirmation(context, department: department);
                          }
                        },
                      ),
                    ],
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Department Details',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          _buildDetailRow('Location:', department.location),
                          _buildDetailRow('Created:', department.createdDate),
                          _buildDetailRow('Budget:', department.budget.toString()),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(width: 8),
          Text(value),
        ],
      ),
    );
  }

  Future<void> _showAddDepartmentDialog(BuildContext context) {
    final nameController = TextEditingController();
    final headController = TextEditingController();
    final provider = Provider.of<DepartmentProvider>(context, listen: false);
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Department'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Department Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: headController,
              decoration: const InputDecoration(
                labelText: 'Head of Department',
                border: OutlineInputBorder(),
              ),
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
              await provider.addDepartment(nameController.text, null);
              if (provider.error != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: ${provider.error}')),
                );
              } else {
                Navigator.pop(context);
              }
            },
            child: provider.loading ? const CircularProgressIndicator() : const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showEmployeesList(BuildContext context, Department department) {
    showModalBottomSheet(
      context: context,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, controller) => Column(
          children: [
            AppBar(
              title: const Text('Department Employees'),
              leading: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: controller,
                itemCount: department.employees.length,
                itemBuilder: (context, index) {
                  final employee = department.employees[index];
                  return ListTile(
                    leading: const CircleAvatar(
                      backgroundImage: AssetImage('assets/img/anonyme.jpg'),
                    ),
                    title: Text(employee.name),
                    subtitle: Text(employee.position),
                    trailing: Text('Joined: ${employee.joinedDate}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showEditDepartmentDialog(BuildContext context, {required Department department}) {
    final nameController = TextEditingController(text: department.name);
    final headController = TextEditingController(text: department.head);
    final provider = Provider.of<DepartmentProvider>(context, listen: false);
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Department'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Department Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: headController,
              decoration: const InputDecoration(
                labelText: 'Head of Department',
                border: OutlineInputBorder(),
              ),
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
              await provider.editDepartment(department.id, nameController.text, headController.text);
              if (provider.error != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: ${provider.error}')),
                );
              } else {
                Navigator.pop(context);
              }
            },
            child: provider.loading ? const CircularProgressIndicator() : const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _showDeleteConfirmation(BuildContext context, {required Department department}) {
    final provider = Provider.of<DepartmentProvider>(context, listen: false);
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Department'),
        content: const Text(
          'Are you sure you want to delete this department? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await provider.deleteDepartment(department.id);
              if (provider.error != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: ${provider.error}')),
                );
              } else {
                Navigator.pop(context);
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: provider.loading ? const CircularProgressIndicator() : const Text('Delete'),
          ),
        ],
      ),
    );
  }
}