import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_list_provider.dart';
import '../providers/department_provider.dart';
import '../models/user.dart';
import '../models/department.dart';

class DirectoryScreen extends StatefulWidget {
  const DirectoryScreen({super.key});

  @override
  State<DirectoryScreen> createState() => _DirectoryScreenState();
}

class _DirectoryScreenState extends State<DirectoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedDepartment = 'All';
  
  @override
  void initState() {
    super.initState();
    // Fetch dynamic data from backend via providers
    Future.microtask(() {
      Provider.of<UserListProvider>(context, listen: false).fetchUsers();
      Provider.of<DepartmentProvider>(context, listen: false).fetchDepartments();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Company Directory'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search employees...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Theme.of(context).cardColor,
              ),
              onChanged: (value) {
                setState(() {}); // Triggers search
              },
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          _buildDepartmentFilter(),
          Expanded(
            child: Consumer<UserListProvider>(
              builder: (context, userListProvider, _) {
                if (userListProvider.loading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (userListProvider.error != null) {
                  return Center(child: Text('Error: ${userListProvider.error}'));
                }
                // Dynamic data: users list from provider
                List<User> users = userListProvider.users;
                // Filter by department
                if (_selectedDepartment != 'All') {
                  users = users.where((u) => u.department == _selectedDepartment).toList();
                }
                // Filter by search
                if (_searchController.text.isNotEmpty) {
                  users = users.where((u) =>
                    u.name.toLowerCase().contains(_searchController.text.toLowerCase()) ||
                    u.email.toLowerCase().contains(_searchController.text.toLowerCase())
                  ).toList();
                }
                if (users.isEmpty) {
                  return const Center(child: Text('No employees found.'));
                }
                return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    return _EmployeeCard(user: users[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDepartmentFilter() {
    return Consumer<DepartmentProvider>(
      builder: (context, departmentProvider, _) {
        if (departmentProvider.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        List<String> departments = ['All'];
        // Dynamic data: department names from provider
        departments.addAll(departmentProvider.departments.map((d) => d.name));
        return Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: departments.map((dep) => _buildDepartmentChip(dep)).toList(),
          ),
        );
      },
    );
  }

  Widget _buildDepartmentChip(String department) {
    final isSelected = _selectedDepartment == department;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: FilterChip(
        label: Text(department),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedDepartment = department;
          });
        },
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

class _EmployeeCard extends StatelessWidget {
  final User user;
  const _EmployeeCard({required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: () => _showEmployeeDetails(context, user),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: user.profileImage != null && user.profileImage!.isNotEmpty
                  ? NetworkImage(user.profileImage!)
                  : const AssetImage('assets/img/anonyme.jpg') as ImageProvider,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(user.position),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.business,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          user.department,
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  IconButton(
                    icon: const Icon(Icons.email),
                    onPressed: () {
                      // TODO: Send email
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.phone),
                    onPressed: () {
                      // TODO: Make call
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEmployeeDetails(BuildContext context, User user) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => _EmployeeDetailsSheet(user: user),
    );
  }
}

class _EmployeeDetailsSheet extends StatelessWidget {
  final User user;
  const _EmployeeDetailsSheet({required this.user});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Column(
          children: [
            AppBar(
              title: const Text('Employee Details'),
              leading: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.all(16),
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: user.profileImage != null && user.profileImage!.isNotEmpty
                        ? NetworkImage(user.profileImage!)
                        : const AssetImage('assets/img/anonyme.jpg') as ImageProvider,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Text(
                      user.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      user.position,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildDetailRow(Icons.business, 'Department', user.department),
                  _buildDetailRow(Icons.email, 'Email', user.email),
                  _buildDetailRow(Icons.phone, 'Phone', user.phone),
                  _buildDetailRow(
                    Icons.calendar_today,
                    'Joined',
                    user.joinedDate,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        icon: const Icon(Icons.email),
                        label: const Text('Send Email'),
                        onPressed: () {
                          // TODO: Send email
                        },
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.message),
                        label: const Text('Send Message'),
                        onPressed: () {
                          // TODO: Send message
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}