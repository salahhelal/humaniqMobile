import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppShell extends StatelessWidget {
  final Widget child;

  const AppShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          if (MediaQuery.of(context).size.width >= 1200) 
            const _DesktopNavigationRail(),
          Expanded(
            child: Column(
              children: [
                if (MediaQuery.of(context).size.width < 1200) 
                  //const _MobileAppBar(),
                Expanded(child: child),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: MediaQuery.of(context).size.width < 600
          ? const _MobileBottomNav()
          : null,
      floatingActionButton: _buildFloatingActionButton(context),
    );
  }

  Widget? _buildFloatingActionButton(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location.contains('/chat')) {
      return FloatingActionButton(
        onPressed: () {
          // Start new chat
        },
        child: const Icon(Icons.chat),
      );
    }
    return null;
  }
}

class _DesktopNavigationRail extends StatelessWidget {
  const _DesktopNavigationRail();

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    
    return NavigationRail(
      extended: MediaQuery.of(context).size.width >= 1500,
      destinations: const [
        NavigationRailDestination(
          icon: Icon(Icons.dashboard),
          label: Text('Dashboard'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.people),
          label: Text('Directory'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.event),
          label: Text('Events'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.chat),
          label: Text('Chat'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.receipt),
          label: Text('Payroll'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.settings),
          label: Text('Settings'),
        ),
      ],
      selectedIndex: _getSelectedIndex(location),
      onDestinationSelected: (index) => _onDestinationSelected(context, index),
    );
  }

  int _getSelectedIndex(String location) {
    if (location.contains('/dashboard')) return 0;
    if (location.contains('/directory')) return 1;
    if (location.contains('/events')) return 2;
    if (location.contains('/chat')) return 3;
    if (location.contains('/payroll')) return 4;
    if (location.contains('/settings')) return 5;
    return 0;
  }

  void _onDestinationSelected(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/dashboard');
        break;
      case 1:
        context.go('/dashboard/directory');
        break;
      case 2:
        context.go('/dashboard/events');
        break;
      case 3:
        context.go('/dashboard/chat');
        break;
      case 4:
        context.go('/dashboard/payroll');
        break;
      case 5:
        context.go('/dashboard/settings');
        break;
    }
  }
}

/*class _MobileAppBar extends StatelessWidget {
  const _MobileAppBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('HumanIQ'),
      actions: [
        IconButton(
          icon: const Badge(
            label: Text('3'),
            child: Icon(Icons.notifications),
          ),
          onPressed: () => context.go('/dashboard/notifications'),
        ),
        const SizedBox(width: 8),
        PopupMenuButton(
          child: const CircleAvatar(
            backgroundImage: AssetImage('assets/img/anonyme.jpg'),
          ),
          itemBuilder: (context) => [
            PopupMenuItem(
              child: const Text('Profile'),
              onTap: () => context.go('/dashboard/profile'),
            ),
            PopupMenuItem(
              child: const Text('Settings'),
              onTap: () => context.go('/dashboard/settings'),
            ),
            const PopupMenuItem(
              child: Text('Logout'),
              // TODO: Implement logout
            ),
          ],
        ),
        const SizedBox(width: 16),
      ],
    );
  }
}*/

class _MobileBottomNav extends StatelessWidget {
  const _MobileBottomNav();

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    
    return NavigationBar(
      selectedIndex: _getSelectedIndex(location),
      onDestinationSelected: (index) => _onDestinationSelected(context, index),
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.dashboard),
          label: 'Dashboard',
        ),
        NavigationDestination(
          icon: Icon(Icons.people),
          label: 'Directory',
        ),
        NavigationDestination(
          icon: Icon(Icons.chat),
          label: 'Chat',
        ),
        NavigationDestination(
          icon: Icon(Icons.more_horiz),
          label: 'More',
        ),
      ],
    );
  }

  int _getSelectedIndex(String location) {
    if (location.contains('/dashboard')) return 0;
    if (location.contains('/directory')) return 1;
    if (location.contains('/chat')) return 2;
    return 0;
  }

  void _onDestinationSelected(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/dashboard');
        break;
      case 1:
        context.go('/dashboard/directory');
        break;
      case 2:
        context.go('/dashboard/chat');
        break;
      case 3:
        _showMoreMenu(context);
        break;
    }
  }

  void _showMoreMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.event),
            title: const Text('Events'),
            onTap: () {
              Navigator.pop(context);
              context.go('/dashboard/events');
            },
          ),
          ListTile(
            leading: const Icon(Icons.receipt),
            title: const Text('Payroll'),
            onTap: () {
              Navigator.pop(context);
              context.go('/dashboard/payroll');
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              context.go('/dashboard/settings');
            },
          ),
        ],
      ),
    );
  }
}