import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class DashboardDrawer extends StatelessWidget {
  const DashboardDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;
    final userName = user?.name ?? 'Guest';
    final userEmail = user?.email ?? 'No Email';
    final profileImage = user?.profileImage;

    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            currentAccountPicture: profileImage != null && profileImage.isNotEmpty
                ? CircleAvatar(
                    backgroundImage: NetworkImage(profileImage),
                  )
                : const CircleAvatar(
                    backgroundImage: AssetImage('assets/img/anonyme.jpg'),
                  ),
            accountName: Text(userName),
            accountEmail: Text(userEmail),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(
                  context,
                  icon: Icons.dashboard,
                  title: 'Dashboard',
                  onTap: () => context.go('/dashboard'),
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.people,
                  title: 'Directory',
                  onTap: () => context.go('/dashboard/directory'),
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.business,
                  title: 'Departments',
                  onTap: () => context.go('/dashboard/departments'),
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.description,
                  title: 'Contracts',
                  onTap: () => context.go('/dashboard/contracts'),
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.event,
                  title: 'Events',
                  onTap: () => context.go('/dashboard/events'),
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.beach_access,
                  title: 'Leave Requests',
                  onTap: () => context.go('/dashboard/leave-requests'),
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.payment,
                  title: 'Payroll',
                  onTap: () => context.go('/dashboard/payroll'),
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.chat,
                  title: 'Chat',
                  onTap: () => context.go('/dashboard/chat'),
                ),
                const Divider(),
                _buildDrawerItem(
                  context,
                  icon: Icons.settings,
                  title: 'Settings',
                  onTap: () => context.go('/dashboard/settings'),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Divider(),
                _buildDrawerItem(
                  context,
                  icon: Icons.logout,
                  title: 'Logout',
                  onTap: () => _showLogoutDialog(context),
                ),
                const SizedBox(height: 8),
                Text(
                  'Version 1.0.0',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool showTrailing = false,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: showTrailing ? const Icon(Icons.chevron_right) : null,
      onTap: () {
        // Close the drawer before navigating
        Navigator.pop(context);
        onTap();
      },
    );
  }

  Future<void> _showLogoutDialog(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.logout();
      if (context.mounted) {
        context.go('/login');
      }
    }
  }
}