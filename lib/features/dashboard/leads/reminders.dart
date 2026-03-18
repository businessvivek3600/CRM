import 'package:crm/Models/leads_model.dart';
import 'package:crm/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../services/api_services.dart';
import '../../../../store/lead_store.dart';
import '../../../../store/reminder_store.dart';

import '../../../../widgets/custom_dropdown.dart';
import '../../../../widgets/date_formation.dart';

class RemindersTab extends StatefulWidget {
  const RemindersTab({super.key, required this.remainder, required this.lead});

  final List<Reminder> remainder;
  final Lead lead;

  @override
  State<RemindersTab> createState() => _RemindersTabState();
}

class _RemindersTabState extends State<RemindersTab> {
  final TextEditingController dateTimeController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Reminder? editingReminder;
  String? _selectedStaffId;
  bool isChecked = false;

  DateTime? selectedDateTime;

  @override
  void initState() {
    super.initState();

    if (reminderStore.reminders.isEmpty) {
      reminderStore.setReminders(widget.remainder);
    }
  }

  void _populateFieldsForEditing(Reminder reminder) {
    editingReminder = reminder;

    dateTimeController.text = reminder.date;
    _selectedStaffId = reminder.staffid;
    descriptionController.text = reminder.description;
    isChecked = reminder.isnotified == "1";

    _showReminderBottomSheet(context);
  }

  void _clearFields() {
    editingReminder = null;

    dateTimeController.clear();
    _selectedStaffId = null;
    descriptionController.clear();
    isChecked = false;
  }

  String? getStaffId(String name) {
    try {
      return leadStore.staff
          .firstWhere((staff) => "${staff.firstName} ${staff.lastName}" == name)
          .staffId;
    } catch (e) {
      return null;
    }
  }

  void _showReminderBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      /// drag indicator
                      Center(
                        child: Container(
                          width: 45,
                          height: 5,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),

                      16.height,

                      Text(
                        editingReminder != null
                            ? "Edit Reminder"
                            : "Add Reminder",
                        style: boldTextStyle(size: 18),
                      ),

                      18.height,

                      /// DATE FIELD

                      TextFormField(
                        controller: dateTimeController,
                        readOnly: true,
                        onTap: () async {
                          await _pickDateTime();
                          setModalState(() {});
                        },
                        decoration: InputDecoration(
                          hintText: "Select date & time",
                          prefixIcon: const Icon(Icons.schedule),
                          filled: true,
                          fillColor: CRMColors.surface,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (v) => v!.isEmpty ? 'Required' : null,
                      ),

                      14.height,

                      /// STAFF DROPDOWN

                      CustomDropdown(
                        hint: 'Assign to staff',
                        items: leadStore.staff
                            .map((e) => "${e.firstName} ${e.lastName}")
                            .toList(),
                        selectedValue: leadStore.staff
                            .firstWhere(
                              (e) => e.staffId == _selectedStaffId,
                          orElse: () => Staff(
                              firstName: '', lastName: '', staffId: ''),
                        )
                            .firstName
                            .isEmpty
                            ? null
                            : "${leadStore.staff.firstWhere((e) => e.staffId == _selectedStaffId).firstName} ${leadStore.staff.firstWhere((e) => e.staffId == _selectedStaffId).lastName}",
                        onChanged: (value) {
                          setModalState(() {
                            _selectedStaffId = getStaffId(value ?? "");
                          });
                        },
                      ),

                      14.height,

                      /// DESCRIPTION

                      TextFormField(
                        controller: descriptionController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: "Description...",
                          filled: true,
                          fillColor: CRMColors.surface,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (v) => v!.isEmpty ? 'Required' : null,
                      ),

                      12.height,

                      Row(
                        children: [
                          Checkbox(
                            value: isChecked,
                            onChanged: (v) => setModalState(() => isChecked = v!),
                          ),
                          const Text("Send reminder email"),
                        ],
                      ),

                      20.height,

                      /// SAVE BUTTON

                      AppButton(
                        text: "Save Reminder",
                        width: context.width(),
                        color: CRMColors.primary,
                        onTap: () async {
                          if (!_formKey.currentState!.validate()) return;

                          await _handleSave();
                          finish(context);
                        },
                      ),

                      10.height,
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    ).then((value) => _clearFields());
  }

  Future<void> _handleSave() async {
    final Map<String, dynamic> data = {
      "rel_id": widget.lead.id.toString(),
      "date": dateTimeController.text,
      "staff": _selectedStaffId ?? '',
      "description": descriptionController.text,
      "notify_by_email": isChecked ? "1" : "0",
    };

    if (editingReminder != null) {
      data["id"] = editingReminder!.id;

      final (bool success, Map<String, dynamic>? response, String? message) =
          await ApiService.editReminder(data);

      if (success && response != null && response['data'] != null) {
        var updatedData = Reminder.fromJson(response['data']);
        reminderStore.updateReminder(updatedData);
        toast("Reminder updated",bgColor: Colors.green,textColor: Colors.white);
      } else {
        toast(message ?? "Update failed");
      }
    } else {
      final (bool status, Map<String, dynamic> response, String? message) =
          await ApiService.addReminder(data);

      if (status && response['data'] != null) {
        reminderStore.addReminder(
          Reminder.fromJson(response['data']),
        );

        toast("Reminder Added Successfully",bgColor: Colors.green,textColor: Colors.white);
      }
    }
  }

  Future<void> _deleteReminder(String reminderId) async {
    var (bool status, Map<String, dynamic> data, String? message) =
        await ApiService.deleteReminder({'id': reminderId});

    if (status) {
      reminderStore.deleteReminder(reminderId);

      toast(message ?? "Reminder deleted");
    } else {
      toast(message ?? "Failed to delete reminder");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          /// ADD REMINDER BUTTON

          Container(
            width: double.infinity,
            margin: const EdgeInsets.fromLTRB(20, 6, 20, 12),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: CRMColors.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: CRMColors.primary.withOpacity(0.15)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: CRMColors.primary.withOpacity(0.15),
                      shape: BoxShape.circle),
                  child: const Icon(Icons.notification_add,
                      size: 18, color: CRMColors.primary),
                ),
                12.width,
                Expanded(
                  child:
                      Text("Schedule Reminder", style: boldTextStyle(size: 14)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CRMColors.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () => _showReminderBottomSheet(context),
                  child:
                      const Text("Add", style: TextStyle(color: Colors.white)),
                )
              ],
            ),
          ),

          20.height,

          /// HISTORY LIST

          Observer(
            builder: (_) => ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: reminderStore.reminders.length,
              separatorBuilder: (_, __) => 12.height,
              itemBuilder: (context, index) {
                final remainder = reminderStore.reminders[index];

                return Container(
                  key: ValueKey(remainder.id),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: CRMColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: CRMColors.surface,
                            child: Text(
                              remainder.firstname[0],
                              style: boldTextStyle(color: CRMColors.primary),
                            ),
                          ),
                          10.width,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${remainder.firstname} ${remainder.lastname}',
                                  style: boldTextStyle(size: 13),
                                ),
                                Text(
                                  formatDate(remainder.date) ?? "",
                                  style: secondaryTextStyle(size: 11),
                                ),
                              ],
                            ),
                          ),
                          PopupMenuButton<String>(
                            onSelected: (val) {
                              if (val == 'edit') {
                                _populateFieldsForEditing(remainder);
                              } else if (val == 'delete') {
                                _showDeleteConfirmationDialog(remainder.id);
                              }
                            },
                            itemBuilder: (context) {
                              List<PopupMenuEntry<String>> menuItems = [];

                              if (remainder.canEdit == 1) {
                                menuItems.add(
                                  const PopupMenuItem<String>(
                                    value: 'edit',
                                    child: Text('Edit'),
                                  ),
                                );
                              }

                              if (remainder.canDelete == 1) {
                                menuItems.add(
                                  const PopupMenuItem<String>(
                                    value: 'delete',
                                    child: Text('Delete'),
                                  ),
                                );
                              }

                              return menuItems;
                            },
                          )
                        ],
                      ),
                      8.height,
                      Text(
                        remainder.description,
                        style: secondaryTextStyle(),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  void _showDeleteConfirmationDialog(String reminderId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 22, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              /// Icon
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.delete_outline,
                  color: Colors.red,
                  size: 28,
                ),
              ),

              16.height,

              /// Title
              Text(
                "Delete Reminder",
                style: boldTextStyle(size: 18),
                textAlign: TextAlign.center,
              ),

              8.height,

              /// Message
              Text(
                "Are you sure you want to delete this reminder?",
                style: secondaryTextStyle(),
                textAlign: TextAlign.center,
              ),

              22.height,

              /// Buttons
              Row(
                children: [

                  /// Cancel
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancel"),
                    ),
                  ),

                  12.width,

                  /// Delete
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () async {
                        Navigator.pop(context);
                        await _deleteReminder(reminderId);
                      },
                      child: const Text(
                        "Delete",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickDateTime() async {

    DateTime now = DateTime.now();

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: CRMColors.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate == null) return;

    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: CRMColors.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime == null) return;

    DateTime combined = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    selectedDateTime = combined;

    dateTimeController.text =
        DateFormat('yyyy-MM-dd HH:mm').format(combined);
  }
}
