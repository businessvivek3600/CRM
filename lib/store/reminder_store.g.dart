// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reminder_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ReminderStore on _ReminderStore, Store {
  late final _$remindersAtom =
      Atom(name: '_ReminderStore.reminders', context: context);

  @override
  ObservableList<Reminder> get reminders {
    _$remindersAtom.reportRead();
    return super.reminders;
  }

  @override
  set reminders(ObservableList<Reminder> value) {
    _$remindersAtom.reportWrite(value, super.reminders, () {
      super.reminders = value;
    });
  }

  late final _$loadingAtom =
      Atom(name: '_ReminderStore.loading', context: context);

  @override
  bool get loading {
    _$loadingAtom.reportRead();
    return super.loading;
  }

  @override
  set loading(bool value) {
    _$loadingAtom.reportWrite(value, super.loading, () {
      super.loading = value;
    });
  }

  late final _$editingReminderAtom =
      Atom(name: '_ReminderStore.editingReminder', context: context);

  @override
  Reminder? get editingReminder {
    _$editingReminderAtom.reportRead();
    return super.editingReminder;
  }

  @override
  set editingReminder(Reminder? value) {
    _$editingReminderAtom.reportWrite(value, super.editingReminder, () {
      super.editingReminder = value;
    });
  }

  late final _$selectedStaffIdAtom =
      Atom(name: '_ReminderStore.selectedStaffId', context: context);

  @override
  String? get selectedStaffId {
    _$selectedStaffIdAtom.reportRead();
    return super.selectedStaffId;
  }

  @override
  set selectedStaffId(String? value) {
    _$selectedStaffIdAtom.reportWrite(value, super.selectedStaffId, () {
      super.selectedStaffId = value;
    });
  }

  late final _$notifyByEmailAtom =
      Atom(name: '_ReminderStore.notifyByEmail', context: context);

  @override
  bool get notifyByEmail {
    _$notifyByEmailAtom.reportRead();
    return super.notifyByEmail;
  }

  @override
  set notifyByEmail(bool value) {
    _$notifyByEmailAtom.reportWrite(value, super.notifyByEmail, () {
      super.notifyByEmail = value;
    });
  }

  late final _$_ReminderStoreActionController =
      ActionController(name: '_ReminderStore', context: context);

  @override
  void setReminders(List<Reminder> data) {
    final _$actionInfo = _$_ReminderStoreActionController.startAction(
        name: '_ReminderStore.setReminders');
    try {
      return super.setReminders(data);
    } finally {
      _$_ReminderStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addReminder(Reminder reminder) {
    final _$actionInfo = _$_ReminderStoreActionController.startAction(
        name: '_ReminderStore.addReminder');
    try {
      return super.addReminder(reminder);
    } finally {
      _$_ReminderStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updateReminder(Reminder updated) {
    final _$actionInfo = _$_ReminderStoreActionController.startAction(
        name: '_ReminderStore.updateReminder');
    try {
      return super.updateReminder(updated);
    } finally {
      _$_ReminderStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void deleteReminder(String id) {
    final _$actionInfo = _$_ReminderStoreActionController.startAction(
        name: '_ReminderStore.deleteReminder');
    try {
      return super.deleteReminder(id);
    } finally {
      _$_ReminderStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void startEditing(Reminder reminder) {
    final _$actionInfo = _$_ReminderStoreActionController.startAction(
        name: '_ReminderStore.startEditing');
    try {
      return super.startEditing(reminder);
    } finally {
      _$_ReminderStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearForm() {
    final _$actionInfo = _$_ReminderStoreActionController.startAction(
        name: '_ReminderStore.clearForm');
    try {
      return super.clearForm();
    } finally {
      _$_ReminderStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
reminders: ${reminders},
loading: ${loading},
editingReminder: ${editingReminder},
selectedStaffId: ${selectedStaffId},
notifyByEmail: ${notifyByEmail}
    ''';
  }
}
