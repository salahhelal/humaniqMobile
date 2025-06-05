import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/chat_provider.dart';
import '../models/chat_room.dart';
import '../models/message.dart';
import '../providers/user_provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  bool _isSearching = false;
  
  @override
  void initState() {
    super.initState();
    // Fetch dynamic chat rooms from backend via provider
    Future.microtask(() {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final userId = userProvider.user?.id ?? 0;
      Provider.of<ChatProvider>(context, listen: false).fetchChatRooms(userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userId = userProvider.user?.id ?? 0;
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                decoration: const InputDecoration(
                  hintText: 'Search conversations...',
                  border: InputBorder.none,
                ),
                autofocus: true,
              )
            : const Text('Messages'),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
              });
            },
          ),
        ],
      ),
      body: Consumer<ChatProvider>(
        builder: (context, chatProvider, _) {
          if (chatProvider.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (chatProvider.error != null) {
            return Center(child: Text('Error: \\${chatProvider.error}'));
          }
          // Dynamic data: chat rooms from provider
          final chatRooms = chatProvider.chatRooms;
          return Column(
            children: [
              _ChatTabs(),
              Expanded(
                child: chatRooms.isEmpty
                  ? const Center(child: Text('No chats found.'))
                  : ListView.builder(
                      itemCount: chatRooms.length,
                      itemBuilder: (context, index) {
                        return _ChatListItem(
                          chatRoom: chatRooms[index],
                          onTap: () => _navigateToChatDetail(context, chatRooms[index]),
                        );
                      },
                    ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _navigateToChatDetail(BuildContext context, ChatRoom chatRoom) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _ChatDetailScreen(chatRoom: chatRoom),
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}

class _ChatTabs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextButton.icon(
              icon: const Icon(Icons.chat),
              label: const Text('Chats'),
              style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
              ),
              onPressed: () {},
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextButton.icon(
              icon: const Icon(Icons.group),
              label: const Text('Users'),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatListItem extends StatelessWidget {
  final ChatRoom chatRoom;
  final VoidCallback onTap;
  const _ChatListItem({required this.chatRoom, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: const CircleAvatar(
        backgroundImage: AssetImage('assets/img/anonyme.jpg'),
      ),
      title: Text(chatRoom.name),
      subtitle: Text(chatRoom.lastMessage ?? 'No messages yet'),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Text('10:30 AM', style: TextStyle(fontSize: 12)),
          const SizedBox(height: 2),
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              shape: BoxShape.circle,
            ),
            child: const Text(
              '2',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatDetailScreen extends StatelessWidget {
  final ChatRoom chatRoom;
  const _ChatDetailScreen({required this.chatRoom});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userId = userProvider.user?.id ?? 0;
    return Scaffold(
      appBar: AppBar(title: Text(chatRoom.name)),
      body: Consumer<ChatProvider>(
        builder: (context, chatProvider, _) {
          if (chatProvider.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (chatProvider.error != null) {
            return Center(child: Text('Error: \\${chatProvider.error}'));
          }
          // Dynamic data: messages from provider
          final messages = chatProvider.messages;
          return Column(
            children: [
              Expanded(
                child: messages.isEmpty
                  ? const Center(child: Text('No messages yet.'))
                  : ListView.builder(
                      padding: const EdgeInsets.all(8),
                      reverse: true,
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final bool isMe = messages[index].senderId == userId;
                        return _MessageBubble(message: messages[index], isMe: isMe);
                      },
                    ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.attach_file),
                      onPressed: () {},
                    ),
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          hintText: 'Type a message...',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () {
                        // TODO: Send message via provider/backend
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final Message message;
  final bool isMe;
  const _MessageBubble({required this.message, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isMe ? Theme.of(context).primaryColorLight : Colors.grey[200],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(message.content),
      ),
    );
  }
}