import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkMode = false;
  bool _notifications = true;
  String _language = 'English';
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          _buildUserHeader(),
          const Divider(),
          _buildPreferencesSection(),
          const Divider(),
          _buildSecuritySection(),
          const Divider(),
          _buildNotificationsSection(),
          const Divider(),
          _buildSupportSection(),
          const Divider(),
          _buildAboutSection(),
        ],
      ),
    );
  }

  Widget _buildUserHeader() {
    return ListTile(
      leading: const CircleAvatar(
        backgroundImage: AssetImage('assets/img/anonyme.jpg'),
        radius: 30,
      ),
      title: const Text(
        'helal salah',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      subtitle: const Text('Senior Developer'),
      trailing: TextButton(
        onPressed: () {
          // TODO: Navigate to profile edit
        },
        child: const Text('Edit Profile'),
      ),
    );
  }

  Widget _buildPreferencesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Preferences',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SwitchListTile(
          title: const Text('Dark Mode'),
          subtitle: const Text('Enable dark theme'),
          value: _darkMode,
          onChanged: (value) {
            setState(() {
              _darkMode = value;
            });
          },
        ),
        ListTile(
          title: const Text('Language'),
          subtitle: Text(_language),
          trailing: const Icon(Icons.chevron_right),
          onTap: _showLanguageDialog,
        ),
      ],
    );
  }

  Widget _buildSecuritySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Security',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ListTile(
          title: const Text('Change Password'),
          leading: const Icon(Icons.lock),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showChangePasswordDialog(context),
        ),
        ListTile(
          title: const Text('Two-Factor Authentication'),
          leading: const Icon(Icons.security),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            // TODO: Navigate to 2FA setup
          },
        ),
      ],
    );
  }

  Widget _buildNotificationsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Notifications',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SwitchListTile(
          title: const Text('Push Notifications'),
          subtitle: const Text('Receive push notifications'),
          value: _notifications,
          onChanged: (value) {
            setState(() {
              _notifications = value;
            });
          },
        ),
        ListTile(
          title: const Text('Email Notifications'),
          subtitle: const Text('Configure email preferences'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            // TODO: Navigate to email settings
          },
        ),
      ],
    );
  }

  Widget _buildSupportSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Support',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ListTile(
          title: const Text('Help Center'),
          leading: const Icon(Icons.help),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            // TODO: Navigate to help center
          },
        ),
        ListTile(
          title: const Text('Contact Support'),
          leading: const Icon(Icons.support_agent),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            // TODO: Navigate to support contact
          },
        ),
        ListTile(
          title: const Text('Report a Bug'),
          leading: const Icon(Icons.bug_report),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            // TODO: Navigate to bug report
          },
        ),
      ],
    );
  }

  Widget _buildAboutSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'About',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ListTile(
          title: const Text('App Version'),
          subtitle: const Text('1.0.0'),
          leading: const Icon(Icons.info),
        ),
        ListTile(
          title: const Text('Terms of Service'),
          leading: const Icon(Icons.description),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            // TODO: Show terms of service
          },
        ),
        ListTile(
          title: const Text('Privacy Policy'),
          leading: const Icon(Icons.privacy_tip),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            // TODO: Show privacy policy
          },
        ),
        ListTile(
          title: const Text('Logout'),
          leading: const Icon(Icons.logout),
          onTap: () => _showLogoutConfirmation(context),
        ),
      ],
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile(
              title: const Text('English'),
              value: 'English',
              groupValue: _language,
              onChanged: (value) {
                setState(() {
                  _language = value.toString();
                });
                Navigator.pop(context);
              },
            ),
            RadioListTile(
              title: const Text('Français'),
              value: 'Français',
              groupValue: _language,
              onChanged: (value) {
                setState(() {
                  _language = value.toString();
                });
                Navigator.pop(context);
              },
            ),
            RadioListTile(
              title: const Text('العربية'),
              value: 'العربية',
              groupValue: _language,
              onChanged: (value) {
                setState(() {
                  _language = value.toString();
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    String currentPassword = '';
    String newPassword = '';
    String confirmPassword = '';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Password'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Current Password',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your current password';
                  }
                  return null;
                },
                onSaved: (value) => currentPassword = value ?? '',
              ),
              const SizedBox(height: 16),
              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'New Password',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a new password';
                  }
                  if (value.length < 8) {
                    return 'Password must be at least 8 characters';
                  }
                  return null;
                },
                onSaved: (value) => newPassword = value ?? '',
              ),
              const SizedBox(height: 16),
              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Confirm New Password',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your new password';
                  }
                  if (value != newPassword) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
                onSaved: (value) => confirmPassword = value ?? '',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                formKey.currentState?.save();
                // TODO: Implement password change
                Navigator.pop(context);
              }
            },
            child: const Text('Change Password'),
          ),
        ],
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement logout
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}