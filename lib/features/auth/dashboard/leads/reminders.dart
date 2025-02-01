import 'package:crm/Models/leads_model.dart';
import 'package:crm/utils/colors.dart';
import 'package:crm/utils/default_logger.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:toastification/toastification.dart';

import '../../../../services/api_services.dart';
import '../../../../store/lead_store.dart';
import '../../../../utils/size_utils.dart';
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

  DateTime? selectedDateTime;
  Reminder? editingReminder;

  String? _selectedItem;
  String? id;
  bool isChecked = false;
  void _populateFieldsForEditing(Reminder reminder) {
    setState(() {
      editingReminder = reminder;
      dateTimeController.text = reminder.date;
      _selectedItem = reminder.staffid;
      descriptionController.text = reminder.description;
      isChecked = reminder.isnotified == "1";
      id = reminder.id;
    });
  }

  void _clearFields() {
    setState(() {
      editingReminder = null;
      dateTimeController.clear();
      _selectedItem = null;
      descriptionController.clear();
      isChecked = false;
    });
  }
  bool isEditing = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Visibility(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      RichText(
                        text: const TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: '*', // Red asterisk
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text: ' Date to be notified',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: dateTimeController,
                        readOnly: true,

                        onTap: _pickDateTime, // Open picker on tap
                        decoration: InputDecoration(
                          hintText: "yyyy-MM-dd HH:mm   ",
                          labelStyle: const TextStyle(color: textPrimaryColors),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.calendar_today,
                                color: textPrimaryColors),
                            onPressed: _pickDateTime,
                          ),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(color: textPrimaryColors),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: textPrimaryColors),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: textPrimaryColors),
                          ),
                        ),
                        style: const TextStyle(color: textPrimaryColors),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                RichText(
                  text: const TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: '*',
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: ' Set reminder to', // Bolded text
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: _selectedItem,
                  items: leadStore.staff
                      .map((item) => DropdownMenuItem<String>(
                            value: item.staffId,
                            child: Text("${item.firstName} ${item.lastName}"),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedItem = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Nothing selected',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const SizedBox(height: 10),
                RichText(
                  text: const TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: '*',
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: ' Description',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: descriptionController,
                  maxLines: 4,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (value) {
                    FocusScope.of(context).unfocus();
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: textPrimaryColors),
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: textPrimaryColors),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: textPrimaryColors),
                    ),
                    hintText: 'Enter description here',
                  ),
                  style: const TextStyle(color: textPrimaryColors),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Checkbox(
                      value: isChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          isChecked = value!;
                        });
                      },
                      activeColor: textPrimaryColors,
                      checkColor: Colors.white,
                    ),
                    const Expanded(
                      child: Text(
                        'Send also an email for this reminder',
                        style: TextStyle(color: textPrimaryColors),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: _clearFields,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: secondaryPrimaryColor,
                      ),
                      child: const Text(
                        'Close',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () async {
                        if (dateTimeController.text.isEmpty ||
                            _selectedItem == null ||
                            descriptionController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Please fill all fields')),
                          );
                          return;
                        }

                        final reminderInfo = {
                          "id": id,
                          "rel_id": widget.lead.id,
                          'date': dateTimeController.text,
                          'staff': _selectedItem,
                          'description': descriptionController.text,
                          'notify_by_email': isChecked ? "1" : "0",
                        };

                        if (editingReminder != null) {
                          // Update existing reminder
                          final (bool success, _, String? message) =
                              await ApiService.editReminder(reminderInfo);

                          if (success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Reminder updated successfully')),
                            );
                            _clearFields();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      message ?? 'Failed to update reminder')),
                            );
                          }
                        } else {
                          // Add new reminder
                          final reminderAdd = {
                            // "id":id,

                            "rel_id": widget.lead.id,
                            'date': dateTimeController.text,
                            'staff': _selectedItem,
                            'description': descriptionController.text,
                            'notify_by_email': isChecked ? "1" : "0",
                          };
                          final (
                            bool status,
                            Map<String, dynamic> response,
                            String? message
                          ) = await ApiService.addReminder(reminderAdd);
                          infoLog("---------$reminderAdd");
                          infoLog("${response['data']}");

                          _clearFields();

                          if (status) {
                            // Check if 'data' is a List or a Map
                            if (response['data'] is List) {
                              final newNoteData = (response['data'] as List)
                                  .map((e) => Reminder.fromJson(e))
                                  .toList();

                              // Update the noteData list and refresh the UI
                              setState(() {
                                widget.remainder.insertAll(
                                    0, newNoteData); // Insert at the top
                              });
                            } else if (response['data'] is Map) {
                              final newNoteData = [
                                Reminder.fromJson(response['data'])
                              ];

                              // Update the noteData list and refresh the UI
                              setState(() {
                                widget.remainder.insertAll(
                                    0, newNoteData); // Insert at the top
                              });
                            }

                            toast(response['message'],
                                gravity: ToastGravity.TOP,
                                textColor: Colors.white,
                                bgColor: completedColor);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text(message ?? 'Failed to add reminder'),
                              ),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: secondaryPrimaryColor,
                      ),
                      child: const Text(
                        'Save',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
                  ],
                ),
                height10(),
                const Divider(
                  thickness: 2,
                  color: Colors.black54,
                ),
                height10(),
                ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    separatorBuilder: (context, index) {
                      return const Divider(
                        thickness: 1.5,
                        color: Colors.grey,
                        height: 10,
                      );
                    },
                    shrinkWrap: true,
                    itemCount: widget.remainder.length,
                    itemBuilder: (context, index) {
                      widget.remainder.sort((a, b) => b.date.compareTo(a.date));
                      final remainder = widget.remainder[index];
                      final TextEditingController descriptionController =
                          TextEditingController(text: remainder.description);

                      // State variable for inline editing


                      return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      radius: 25,
                                      backgroundColor: Colors.grey[200],
                                      backgroundImage: remainder
                                              .smallImage.isNotEmpty
                                          ? NetworkImage(remainder.smallImage)
                                          : null,
                                      child: remainder.smallImage.isEmpty
                                          ? Text(
                                              remainder.firstname.isNotEmpty
                                                  ? remainder.firstname[0]
                                                      .toUpperCase()
                                                  : '',
                                              style: const TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            )
                                          : null,
                                    ),
                                    width10(),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              '${remainder.firstname} ${remainder.lastname}',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  color: acceptColor),
                                            ),
                                            width10(),
                                            Icon(
                                              remainder.isnotified == "0"
                                                  ? Icons.notifications_outlined
                                                  : Icons.notifications_active,
                                              size: 18,
                                              color: acceptColor,
                                            )
                                          ],
                                        ),
                                        Text(
                                          "Note added: ${formatDate(remainder.date)}",
                                          style: const TextStyle(
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                width40(),
                                if (remainder.canDelete == 1 ||
                                    remainder.canEdit == 1 &&
                                        remainder.date != DateTime.now())
                                  PopupMenuButton<String>(
                                    icon: const Icon(Icons.more_vert_outlined,
                                        size: 25),
                                    onSelected: (value) {
                                      if (value == 'edit') {
                                        setState(() {
                                          isEditing = true;
                                        });
                                        _populateFieldsForEditing(remainder);
                                      } else if (value == 'delete') {
                                        _showDeleteConfirmationDialog(
                                            remainder.id);
                                      }
                                    },
                                    itemBuilder: (BuildContext context) {
                                      final List<PopupMenuEntry<String>>
                                          menuItems = [];

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
                                  ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            if (isEditing)
                              Column(
                                children: [
                                  TextField(
                                    controller: descriptionController,
                                    maxLines: 3,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          setState(() {
                                            isEditing = false;

                                            /// Cancel editing
                                            descriptionController.text =
                                                remainder.description;

                                            /// Reset to original value
                                          });
                                        },
                                        child: const Text('Cancel'),
                                      ),
                                      const SizedBox(width: 10),
                                      ElevatedButton(
                                        onPressed: () async {
                                          // Show a loading indicator (optional)
                                          setState(() {
                                            isEditing = false;
                                          });
                                        },
                                        child: const Text('Save'),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            else
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isEditing = true;
                                  });
                                },
                                child: Text(
                                  remainder.description,
                                  textAlign: TextAlign.justify,
                                ),
                              ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],

                      );
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(String reminderId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Reminder'),
          content: const Text('Are you sure you want to delete this reminder?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();

                /// Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                setState(() {

                });
                await _deleteReminder(reminderId);

                /// Call API to delete reminder
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteReminder(String reminderId) async {
    var (bool status, Map<String, dynamic> data, String? message) =
        await ApiService.deleteReminder({'id': reminderId});
    if (status) {
      setState(() {
        widget.remainder.removeWhere((reminder) => reminder.id == reminderId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text(message ?? 'Reminder deleted successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message ?? 'Failed to delete reminder')),
      );
    }
  }

  Future<void> _pickDateTime() async {
    DateTime currentDate = DateTime.now();
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDateTime ?? currentDate,
      firstDate: currentDate,
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      /// Set initial time based on the picked date
      TimeOfDay nowTime = TimeOfDay.fromDateTime(currentDate);
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: (pickedDate.year == currentDate.year &&
            pickedDate.month == currentDate.month &&
            pickedDate.day == currentDate.day)
            ? nowTime // Ensure the current time is used if today is selected
            : const TimeOfDay(hour: 0, minute: 0), // Default to start of the day
      );

      if (pickedTime != null) {
        /// Combine picked date and time
        DateTime combinedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        /// Ensure selected time is in the future
        if (combinedDateTime.isBefore(currentDate)) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please select a date and time in the future.'),
              backgroundColor: Colors.red,
            ),
          );
        } else {
          setState(() {
            selectedDateTime = combinedDateTime;
            dateTimeController.text =
                DateFormat('yyyy-MM-dd HH:mm').format(combinedDateTime);
          });
        }
      }
    }
  }

}
