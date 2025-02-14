import 'package:crm/constants/app_constants.dart';
import 'package:crm/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../../store/notification_store.dart';
import '../../../../utils/colors.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final NotificationStore notificationStore = NotificationStore();

  @override
  void initState() {
    super.initState();
    notificationStore.loadNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Notification'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: notificationStore.loadNotifications,
          )
        ],
      ),
      body: Observer(
        builder: (context) {
          if (notificationStore.notifications.isEmpty) {
            return const Center(child: Text('No notifications found.'));
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: ListView.builder(
              itemCount: notificationStore.notifications.length,
              itemBuilder: (context, index) {
                var item = notificationStore.notifications[index];
                return Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: const LinearGradient(
                        colors: [secondaryPrimaryColor, Colors.black87, Colors.black54],
                      ),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Leading image
                        if (item['image'] != null)
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(item['image']),
                          )
                        else
                          const SizedBox(width: 60),

                        const SizedBox(width: 20),

                        // Content section
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title
                              Text(
                                item['title'] ?? 'No Title',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 16),
                              ),

                              const SizedBox(height: 5),

                              // Subtitle (Body text)
                              Text(
                                item['body'] ?? 'No Message',
                                style: const TextStyle(
                                    color: Colors.white70, fontSize: 14),
                              ),
                            ],
                          ),
                        ),

                        // Trailing timestamp
                        Text(
                          item['timestamp'] ?? '',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 11, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),

    );
  }
}
