import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Notifications'),
          actions: [
            IconButton(
              icon: const Icon(Icons.done_all),
              onPressed: () => _markAllAsRead(context),
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'All'),
              Tab(text: 'Unread'),
              Tab(text: 'Important'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _NotificationsList(filter: 'all'),
            _NotificationsList(filter: 'unread'),
            _NotificationsList(filter: 'important'),
          ],
        ),
      ),
    );
  }

  void _markAllAsRead(BuildContext context) {
    // TODO: Implement mark all as read
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All notifications marked as read'),
      ),
    );
  }
}

class _NotificationsList extends StatelessWidget {
  final String filter;

  const _NotificationsList({required this.filter});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 10, // TODO: Replace with actual notifications count
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        return _NotificationItem(
          title: 'Leave Request Approved',
          message: 'Your leave request for April 20-22 has been approved',
          time: '2025-04-15 17:49:43',
          isRead: index % 2 == 0,
          isImportant: index % 3 == 0,
          onTap: () => _showNotificationDetails(context),
        );
      },
    );
  }

  void _showNotificationDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => const _NotificationDetailsSheet(),
    );
  }
}

class _NotificationItem extends StatelessWidget {
  final String title;
  final String message;
  final String time;
  final bool isRead;
  final bool isImportant;
  final VoidCallback onTap;

  const _NotificationItem({
    required this.title,
    required this.message,
    required this.time,
    required this.isRead,
    required this.isImportant,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isRead
              ? Colors.grey.withOpacity(0.1)
              : Theme.of(context).primaryColor.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.notifications,
          color: isRead ? Colors.grey : Theme.of(context).primaryColor,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
        ),
      ),
      subtitle: Text(
        message,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            time.substring(11, 16),
            style: const TextStyle(fontSize: 12),
          ),
          if (isImportant)
            const Icon(
              Icons.star,
              color: Colors.amber,
              size: 16,
            ),
        ],
      ),
    );
  }
}

class _NotificationDetailsSheet extends StatelessWidget {
  const _NotificationDetailsSheet();

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
              title: const Text('Notification Details'),
              leading: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    // TODO: Implement delete
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.all(16),
                children: [
                  const Text(
                    'Leave Request Approved',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '2025-04-15 17:49:43',
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Your leave request for April 20-22 has been approved by your supervisor. '
                    'You can view the details in the Leave Management section.',
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      // TODO: Navigate to related content
                      Navigator.pop(context);
                    },
                    child: const Text('View Leave Details'),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}