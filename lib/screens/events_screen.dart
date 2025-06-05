import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';
import '../providers/event_provider.dart';
import '../models/event.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  
  @override
  void initState() {
    super.initState();
    // Fetch dynamic events from backend via provider
    Future.microtask(() => Provider.of<EventProvider>(context, listen: false).fetchEvents());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Company Events'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterOptions(context),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEventDialog(context),
        child: const Icon(Icons.add),
      ),
      body: Consumer<EventProvider>(
        builder: (context, eventProvider, _) {
          if (eventProvider.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (eventProvider.error != null) {
            return Center(child: Text('Error: \\${eventProvider.error}'));
          }
          // Dynamic data: events from provider
          final events = eventProvider.events;
          return Column(
            children: [
              TableCalendar(
                firstDay: DateTime.utc(2024, 1, 1),
                lastDay: DateTime.utc(2026, 12, 31),
                focusedDay: _focusedDay,
                calendarFormat: _calendarFormat,
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                onFormatChanged: (format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                },
                eventLoader: (day) {
                  // Dynamic data: events for the selected day from provider
                  return events.where((e) => e.date == day.toString().substring(0, 10)).toList();
                },
              ),
              const Divider(height: 1),
              Expanded(
                child: events.isEmpty
                  ? const Center(child: Text('No events found.'))
                  : ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: events.length,
                      itemBuilder: (context, index) {
                        return _EventCard(event: events[index]);
                      },
                    ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showFilterOptions(BuildContext context) {
    final provider = Provider.of<EventProvider>(context, listen: false);
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.location_on),
            title: const Text('Filter by Location'),
            onTap: () async {
              // Example: filter by location 'HQ'
              await provider.fetchEvents();
              provider.events.retainWhere((e) => e.location == 'HQ');
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.category),
            title: const Text('Filter by Type'),
            onTap: () async {
              // Example: filter by type 'Conference'
              await provider.fetchEvents();
              provider.events.retainWhere((e) => e.title.contains('Conference'));
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _showAddEventDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final titleController = TextEditingController();
    final locationController = TextEditingController();
    String? eventType;
    final provider = Provider.of<EventProvider>(context, listen: false);
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Event'),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Event Title',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an event title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: locationController,
                  decoration: const InputDecoration(
                    labelText: 'Location',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a location';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Event Type',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'IN_PERSON',
                      child: Text('In Person'),
                    ),
                    DropdownMenuItem(
                      value: 'VIRTUAL',
                      child: Text('Virtual'),
                    ),
                  ],
                  onChanged: (value) {
                    eventType = value;
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select an event type';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState?.validate() ?? false) {
                await provider.addEvent({
                  'title': titleController.text,
                  'location': locationController.text,
                  'type': eventType,
                });
                if (provider.error != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: ${provider.error}')),
                  );
                } else {
                  Navigator.pop(context);
                }
              }
            },
            child: provider.loading ? const CircularProgressIndicator() : const Text('Create'),
          ),
        ],
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  final Event event;
  const _EventCard({required this.event});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          ListTile(
            leading: const CircleAvatar(
              child: Icon(Icons.event),
            ),
            title: Text(event.title),
            subtitle: Text('${event.date} • ${event.time}'),
            trailing: PopupMenuButton(
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Text('Edit'),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Text('Delete'),
                ),
              ],
              onSelected: (value) async {
                final provider = Provider.of<EventProvider>(context, listen: false);
                if (value == 'edit') {
                  // Show edit dialog (similar to add, pre-filled)
                  // For brevity, just show a snackbar here
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Edit not implemented.')),
                  );
                } else if (value == 'delete') {
                  await provider.deleteEvent(event.id);
                  if (provider.error != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: ${provider.error}')),
                    );
                  }
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Icon(Icons.location_on, size: 16),
                const SizedBox(width: 8),
                Text(event.location),
                const Spacer(),
                const Icon(Icons.group, size: 16),
                const SizedBox(width: 8),
                Text('${event.participants} Participants'),
              ],
            ),
          ),
          ButtonBar(
            children: [
              TextButton.icon(
                icon: const Icon(Icons.calendar_today),
                label: const Text('Add to Calendar'),
                onPressed: () {},
              ),
              TextButton.icon(
                icon: const Icon(Icons.share),
                label: const Text('Share'),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}