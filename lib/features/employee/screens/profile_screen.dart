import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final double _leaveBalance = 15;
  final String _currentUserName = 'salah helal';

  @override
  Widget build(BuildContext context) {
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
              title: Text(_currentUserName),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(height: 16),
                const CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/img/anonyme.jpg'),
                ),
                const SizedBox(height: 16),
                _buildInfoCard(),
                _buildStatsCards(),
                _buildActionButtons(),
                _buildRecentActivity(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildInfoRow(Icons.email, 'Email', 'helal@example.com'),
            const Divider(),
            _buildInfoRow(Icons.phone, 'Phone', '+1234567890'),
            const Divider(),
            _buildInfoRow(Icons.work, 'Position', 'Senior Developer'),
            const Divider(),
            _buildInfoRow(Icons.calendar_today, 'Joined', '2024-01-15'),
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

  Widget _buildStatsCards() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              'Leave Balance',
              '$_leaveBalance days',
              Icons.beach_access,
              Colors.blue,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildStatCard(
              'Projects',
              '5 Active',
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
          onPressed: onPressed,
          icon: Icon(icon),
          color: Theme.of(context).primaryColor,
        ),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildRecentActivity() {
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