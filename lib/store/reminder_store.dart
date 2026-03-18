import 'package:crm/Models/leads_model.dart';
import 'package:mobx/mobx.dart';

part 'reminder_store.g.dart';

final reminderStore = ReminderStore();

class ReminderStore = _ReminderStore with _$ReminderStore;

abstract class _ReminderStore with Store {

  @observable
  ObservableList<Reminder> reminders = ObservableList<Reminder>();

  @observable
  bool loading = false;

  @observable
  Reminder? editingReminder;

  /// form values
  @observable
  String? selectedStaffId;

  @observable
  bool notifyByEmail = false;


  @action
  void setReminders(List<Reminder> data) {
    reminders
      ..clear()
      ..addAll(data);
  }

  @action
  void addReminder(Reminder reminder) {
    reminders.insert(0, reminder);
  }

  @action
  void updateReminder( Reminder updated) {

    final index = reminders.indexWhere((e) => e.id == updated.id);

    if (index != -1) {
      reminders[index] = updated;
    }

  }
  @action
  void deleteReminder(String id) {
    reminders.removeWhere((e) => e.id == id);
  }

  @action
  void startEditing(Reminder reminder) {
    editingReminder = reminder;
    selectedStaffId = reminder.staffid;
    notifyByEmail = reminder.isnotified == "1";
  }

  @action
  void clearForm() {
    editingReminder = null;
    selectedStaffId = null;
    notifyByEmail = false;
  }
}