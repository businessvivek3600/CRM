import 'package:mobx/mobx.dart';

import '../database/notification_database.dart';


part 'notification_store.g.dart';

class NotificationStore = _NotificationStore with _$NotificationStore;

abstract class _NotificationStore with Store {
  // Observable list for notifications
  @observable
  ObservableList<Map<String, dynamic>> notifications = ObservableList<Map<String, dynamic>>();

  // Load all notifications from the database
  @action
  Future<void> loadNotifications() async {
    final data = await NotificationDatabase.instance.getAllNotifications();
    notifications = ObservableList.of(data);
  }

  // Add a new notification (e.g., when it arrives in real-time)
  @action
  Future<void> addNotification(Map<String, dynamic> notification) async {
    await NotificationDatabase.instance.insertNotification(notification);
    notifications.insert(0, notification);  // Add the new notification at the top
  }
}
