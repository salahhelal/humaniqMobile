import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../providers/leave_request_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch dynamic user profile data from backend via provider
    Future.microtask(() => Provider.of<UserProvider>(context, listen: false).fetchProfile());
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, _) {
        if (userProvider.loading) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (userProvider.error != null) {
          return Scaffold(body: Center(child: Text('Error: \\${userProvider.error}')));
        }
        // Dynamic data: user profile from provider
        final user = userProvider.user;
        if (user == null) {
          return const Scaffold(body: Center(child: Text('No user data.')));
        }
        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 200,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Theme.of(context).primaryColor,
                          Theme.of(context).primaryColor.withOpacity(0.8),
                        ],
                      ),
                    ),
                  ),
                  title: Text(user.name),
                ),
              ),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: user.profileImage != null && user.profileImage!.isNotEmpty
                        ? NetworkImage(user.profileImage!)
                        : const AssetImage('assets/img/anonyme.jpg') as ImageProvider,
                    ),
                    const SizedBox(height: 16),
                    _buildInfoCard(user),
                    _buildStatsCards(user),
                    _buildActionButtons(),
                    _buildRecentActivity(),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoCard(user) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildInfoRow(Icons.email, 'Email', user.email),
            const Divider(),
            _buildInfoRow(Icons.phone, 'Phone', user.phone),
            const Divider(),
            _buildInfoRow(Icons.work, 'Position', user.position),
            const Divider(),
            _buildInfoRow(Icons.calendar_today, 'Joined', user.joinedDate),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
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

  Widget _buildStatsCards(user) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Consumer<LeaveRequestProvider>(
              builder: (context, leaveProvider, _) {
                final used = leaveProvider.leaveRequests.length;
                // You can improve this logic if backend provides total allowed
                final total = 20;
                return _buildStatCard(
                  'Leave Balance',
                  '$used/$total',
                  Icons.beach_access,
                  Colors.blue,
                );
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildStatCard(
              'Projects',
              '0', // Replace with real project count if ProjectProvider is available
              Icons.work,
              Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildActionButton(
            'Request Leave',
            Icons.calendar_today,
            () => _showLeaveRequestDialog(context),
          ),
          _buildActionButton(
            'View Payslip',
            Icons.receipt_long,
            () => _navigateToPayslip(context),
          ),
          _buildActionButton(
            'Edit Profile',
            Icons.edit,
            () => _showEditProfileDialog(context),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    String label,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon),
          onPressed: onPressed,
        ),
        Text(label),
      ],
    );
  }

  Widget _buildRecentActivity() {
    // TODO: Connect to activity provider if available
    return Card(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Recent Activity',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Divider(height: 1),
          // TODO: Replace with dynamic activity items
          _buildActivityItem(
            'Leave Request Approved',
            'Your leave request for April 20-22 has been approved',
            '2025-04-15 17:46:50',
          ),
          const Divider(height: 1),
          _buildActivityItem(
            'Project Assignment',
            'You have been assigned to the Mobile App project',
            '2025-04-14 09:30:00',
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(String title, String description, String datetime) {
    return ListTile(
      title: Text(title),
      subtitle: Text(description),
      trailing: Text(
        datetime.substring(0, 10),
        style: const TextStyle(color: Colors.grey),
      ),
    );
  }

  void _showLeaveRequestDialog(BuildContext context) {
    // TODO: Implement leave request dialog
  }

  void _navigateToPayslip(BuildContext context) {
    // TODO: Navigate to payslip screen
  }

  void _showEditProfileDialog(BuildContext context) {
    // TODO: Implement edit profile dialog
  }
}