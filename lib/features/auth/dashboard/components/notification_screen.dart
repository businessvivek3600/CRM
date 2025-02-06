import 'package:crm/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../../store/notification_store.dart';
import '../../../../utils/colors.dart';


class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

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
    return Scaffold(
      backgroundColor: Colors.grey[200],
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
            padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
            child: ListView.builder(
              itemCount: notificationStore.notifications.length,
              itemBuilder: (context, index) {
                var item = notificationStore.notifications[index];
                return Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient:RadialGradient(colors: [
                       Colors.black12,
                        secondaryPrimaryColor,
                      ],
                      focal: Alignment.topRight)
                    ),
                    child: ListTile(
                      leading: item['image'] != null ?
                    CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage( item['image']),
                                    ) : SizedBox(),

                      title: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          width20(),
                          Text(
                            item['title'] ?? 'No Title',
                            style: const TextStyle(fontWeight: FontWeight.bold,color: white),
                          ),
                        ],
                      ),
                      subtitle: Text(item['body'] ?? 'No Message',style: TextStyle(color: Colors.white),),
                      trailing: Text(
                        item['timestamp']?.substring(0, 10) ?? '',
                        style: const TextStyle(fontSize: 12, color: Colors.black),
                      ),
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
