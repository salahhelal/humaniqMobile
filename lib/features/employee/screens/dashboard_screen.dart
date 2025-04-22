import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:humaniq/shared/widgets/dashboard_drawer.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          // Notifications Icon
          IconButton(
            icon: const Badge(
              label: Text('3'),
              child: Icon(Icons.notifications),
            ),
            onPressed: () => context.go('/dashboard/notifications'),
              // TODO: Show notifications
            
          ),
          // Profile Menu
          PopupMenuButton(
            icon: const CircleAvatar(
              backgroundImage: AssetImage('assets/img/anonyme.jpg'),
            ),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: const Text('Profile'),
                value: 'profile',
                onTap: () => context.go('/dashboard/profile'),
              ),
              PopupMenuItem(
                child: const Text('Settings'),
                value: 'settings',
                onTap: () => context.go('/dashboard/settings'),
              ),
              const PopupMenuItem(
                child: Text('Logout'),
                value: 'logout',
                // TODO: Implement logout
              ),
            ],
            onSelected: (value) {
              // TODO: Handle menu selection
            },
          ),
        ],
      ),
      drawer: const DashboardDrawer(),
      body: GridView.count(
        padding: const EdgeInsets.all(16),
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: [
          _DashboardCard(
            title: 'Employees',
            icon: Icons.people,
            count: '150',
            color: Colors.blue,
            onTap: () {
              // TODO: Navigate to employees
            },
          ),
          _DashboardCard(
            title: 'Departments',
            icon: Icons.business,
            count: '8',
            color: Colors.green,
            onTap: () {
              // TODO: Navigate to departments
            },
          ),
          _DashboardCard(
            title: 'Contracts',
            icon: Icons.description,
            count: '120',
            color: Colors.orange,
            onTap: () {
              // TODO: Navigate to contracts
            },
          ),
          _DashboardCard(
            title: 'Events',
            icon: Icons.event,
            count: '5',
            color: Colors.purple,
            onTap: () {
              // TODO: Navigate to events
            },
          ),
        ],
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String count;
  final Color color;
  final VoidCallback onTap;

  const _DashboardCard({
    required this.title,
    required this.icon,
    required this.count,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 48,
                color: color,
              ),
              const SizedBox(height: 8),
              Text(
                count,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}