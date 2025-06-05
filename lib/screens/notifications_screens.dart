import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/notification_provider.dart';
import '../models/notification.dart';

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
        body: Consumer<NotificationProvider>(
          builder: (context, notificationProvider, _) {
            if (notificationProvider.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (notificationProvider.error != null) {
              return Center(child: Text('Error: \\${notificationProvider.error}'));
            }
            final notifications = notificationProvider.notifications;
            return TabBarView(
              children: [
                _NotificationsList(notifications: notifications, filter: 'all'),
                _NotificationsList(notifications: notifications, filter: 'unread'),
                _NotificationsList(notifications: notifications, filter: 'important'),
              ],
            );
          },
        ),
      ),
    );
  }

  void _markAllAsRead(BuildContext context) async {
    final provider = Provider.of<NotificationProvider>(context, listen: false);
    await provider.markAllAsRead();
    if (provider.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${provider.error}')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All notifications marked as read')),
      );
    }
  }
}

class _NotificationsList extends StatelessWidget {
  final List<AppNotification> notifications;
  final String filter;
  const _NotificationsList({required this.notifications, required this.filter});

  @override
  Widget build(BuildContext context) {
    List<AppNotification> filtered = notifications;
    if (filter == 'unread') {
      filtered = notifications.where((n) => !n.isRead).toList();
    } else if (filter == 'important') {
      filtered = notifications.where((n) => n.isImportant).toList();
    }
    if (filtered.isEmpty) {
      return const Center(child: Text('No notifications.'));
    }
    return ListView.separated(
      itemCount: filtered.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final n = filtered[index];
        return _NotificationItem(
          title: n.title,
          message: n.message,
          time: n.time,
          isRead: n.isRead,
          isImportant: n.isImportant,
          onTap: () async {
            final provider = Provider.of<NotificationProvider>(context, listen: false);
            await provider.markAsRead(n.id);
            if (provider.error != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: ${provider.error}')),
              );
            }
            _showNotificationDetails(context, n);
          },
        );
      },
    );
  }

  void _showNotificationDetails(BuildContext context, AppNotification notification) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => _NotificationDetailsSheet(notification: notification),
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
  final AppNotification notification;
  const _NotificationDetailsSheet({required this.notification});

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
                  onPressed: () async {
                    final provider = Provider.of<NotificationProvider>(context, listen: false);
                    await provider.deleteNotification(notification.id);
                    if (provider.error != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: ${provider.error}')),
                      );
                    }
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
                  Text(
                    notification.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    notification.time,
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(notification.message),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      // TODO: Navigate to related content or mark as read via provider/backend
                      Navigator.pop(context);
                    },
                    child: const Text('View Details'),
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