import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final List<Map<String, String>> notifications = [
    {'date': 'Today', 'message': 'You have 3 new notifications'},
    {'date': 'Yesterday', 'message': 'You received a call from James'},
    {'date': '02 Feb', 'message': 'Bruce sent you a message'},
    {'date': '01 Feb', 'message': 'Ben called you by mobile'},
    {'date': '31 Jan', 'message': 'Donald sent you a message'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('Notification'),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {},
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView.builder(
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            var item = notifications[index];
            return Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              margin: const EdgeInsets.symmetric(vertical: 6),
              child: ListTile(
                title: Text(
                  item['date']!,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(item['message']!),
              ),
            );
          },
        ),
      ),
    );
  }
}
