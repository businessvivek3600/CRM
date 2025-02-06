// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$NotificationStore on _NotificationStore, Store {
  late final _$notificationsAtom =
      Atom(name: '_NotificationStore.notifications', context: context);

  @override
  ObservableList<Map<String, dynamic>> get notifications {
    _$notificationsAtom.reportRead();
    return super.notifications;
  }

  @override
  set notifications(ObservableList<Map<String, dynamic>> value) {
    _$notificationsAtom.reportWrite(value, super.notifications, () {
      super.notifications = value;
    });
  }

  late final _$loadNotificationsAsyncAction =
      AsyncAction('_NotificationStore.loadNotifications', context: context);

  @override
  Future<void> loadNotifications() {
    return _$loadNotificationsAsyncAction.run(() => super.loadNotifications());
  }

  late final _$addNotificationAsyncAction =
      AsyncAction('_NotificationStore.addNotification', context: context);

  @override
  Future<void> addNotification(Map<String, dynamic> notification) {
    return _$addNotificationAsyncAction
        .run(() => super.addNotification(notification));
  }

  @override
  String toString() {
    return '''
notifications: ${notifications}
    ''';
  }
}
