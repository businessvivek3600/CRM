import 'package:crm/Models/leads_model.dart';
import 'package:crm/utils/colors.dart';
import 'package:crm/utils/default_logger.dart';
import 'package:crm/utils/size_utils.dart';
import 'package:crm/widgets/date_formation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../services/api_services.dart';
import '../../../../widgets/toastification/toastification.dart';

class AddNotesTab extends StatefulWidget {
  const AddNotesTab({super.key, required this.noteData, required this.lead});
  final List<NoteData> noteData;
  final Lead lead;
  @override
  State<AddNotesTab> createState() => _AddNotesTabState();
}

class _AddNotesTabState extends State<AddNotesTab> {
  String selectedStatus = "I have not contacted this lead";
  final TextEditingController noteController = TextEditingController();
  final TextEditingController dateTimeController = TextEditingController();

  // Method to pick a date and set the time to current time automatically
  DateTime? selectedDateTime;

  Future<void> _pickDateTime() async {
    // Step 1: Pick a date
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDateTime ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      // Step 2: Pick a time
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: selectedDateTime != null
            ? TimeOfDay.fromDateTime(selectedDateTime!)
            : TimeOfDay.now(),
      );

      if (pickedTime != null) {
        // Combine the picked date and time
        DateTime combinedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        setState(() {
          selectedDateTime = combinedDateTime;
          dateTimeController.text =
              DateFormat('yyyy-MM-dd HH:mm').format(combinedDateTime);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                height10(),
                TextField(
                  controller: noteController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: 'Add Note',
                    labelStyle: TextStyle(color: textPrimaryColor),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: textPrimaryColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: textPrimaryColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: textPrimaryColor),
                    ),
                  ),
                  style: const TextStyle(color: textPrimaryColor),
                ),
                height10(),
                Visibility(
                  visible: selectedStatus == "I got in touch with this lead",
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      TextField(
                        controller: dateTimeController,
                        readOnly: true, // Prevent keyboard from opening
                        onTap: _pickDateTime, // Open calendar picker on tap
                        decoration: InputDecoration(
                          labelText: 'Select Date and Time',
                          labelStyle: const TextStyle(color: textPrimaryColor),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.calendar_today,
                                color: textPrimaryColor),
                            onPressed: _pickDateTime,
                          ),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(color: textPrimaryColor),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: textPrimaryColor),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: textPrimaryColor),
                          ),
                        ),
                        style: const TextStyle(color: textPrimaryColor),
                      ),
                    ],
                  ),
                ),
                height20(),
                RadioListTile(
                  title: const Text(
                    "I got in touch with this lead",
                    style: TextStyle(color: textPrimaryColor),
                  ),
                  value: "I got in touch with this lead",
                  groupValue: selectedStatus,
                  activeColor: textPrimaryColor,
                  onChanged: (value) {
                    setState(() {
                      selectedStatus = value!;
                    });
                  },
                ),
                height20(),
                RadioListTile(
                  title: const Text(
                    "I have not contacted this lead",
                    style: TextStyle(color: textPrimaryColor),
                  ),
                  value: "I have not contacted this lead",
                  groupValue: selectedStatus,
                  activeColor: textPrimaryColor,
                  onChanged: (value) {
                    setState(() {
                      selectedStatus = value!;
                    });
                  },
                ),
                height20(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        // Prepare the data to be passed to the API
                        final String noteDescription = noteController.text;
                        final int contactedIndicator =
                            selectedStatus == "I got in touch with this lead"
                                ? 1
                                : 0;

                        // Create the data map
                        final Map<String, dynamic> data = {
                          'rel_id': widget.lead.id.toString(),
                          'lead_note_description': noteDescription.toString(),
                          'contacted_indicator': contactedIndicator.toString(),
                          'custom_contact_date': selectedDateTime.toString()
                        };

                        // Call the API to add the note
                        final (
                          bool status,
                          Map<String, dynamic> response,
                          String? message
                        ) = await ApiService.addNote(data);

                        // Check the status and handle accordingly
                        if (status) {
                          // Success - Optionally show a success message and clear the form or do other actions
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content:
                                    Text(message ?? "Note added successfully")),
                          );
                          // Optionally clear the input fields
                          noteController.clear();
                          setState(() {
                            selectedStatus =
                                "I have not contacted this lead"; // Reset status if needed
                          });
                        } else {
                          // Failure - Show an error message
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(message ?? "Failed to add note")),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: secondaryPrimaryColor,
                      ),
                      child: const Text(
                        'Add Notes',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 17,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                height20(),
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
                  itemCount: widget.noteData.length,
                  itemBuilder: (context, index) {
                    widget.noteData
                        .sort((a, b) => b.dateadded.compareTo(a.dateadded));

                    final note = widget.noteData[index];
                    final TextEditingController descriptionController =
                        TextEditingController(text: note.description);

                    // State variable for inline editing
                    bool isEditing = false;

                    return StatefulBuilder(
                      builder: (context, setState) => Column(
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
                                    backgroundImage: note.smallImage.isNotEmpty
                                        ? NetworkImage(note.smallImage)
                                        : null,
                                    child: note.smallImage.isEmpty
                                        ? Text(
                                            note.firstname.isNotEmpty
                                                ? note.firstname[0]
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
                                    children: [
                                      Text(
                                        '${note.firstname} ${note.lastname}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: acceptColor),
                                      ),
                                      Text(
                                        "Note added: ${formatDate(note.dateadded)}",
                                        style: const TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              if (note.editDelete == 1)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          isEditing = true;
                                        });
                                      },
                                      child: const Icon(
                                        Icons.edit_note_sharp,
                                        size: 25,
                                        color: acceptColor,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    GestureDetector(
                                      onTap: () {
                                        // Show warning dialog when delete icon is tapped
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title:
                                                  const Text('Are you sure?'),
                                              content: const Text(
                                                  'Do you want to delete this note?'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pop(); // Close dialog
                                                  },
                                                  child: const Text('Cancel'),
                                                ),
                                                TextButton(
                                                  onPressed: () async {
                                                    Navigator.of(context)
                                                        .pop(); // Close dialog
                                                    final Map<String, dynamic>
                                                        deleteNote = {
                                                      'id': note.id,
                                                    };
                                                    // Call API to delete the note
                                                    final (
                                                      bool status,
                                                      Map<String, dynamic> data,
                                                      String? message
                                                    ) = await ApiService
                                                        .deleteNote(deleteNote);
                                                    if (status) {
                                                      // Remove the note from the list if deletion is successful
                                                      setState(() {
                                                        widget.noteData
                                                            .removeAt(index);
                                                      });
                                                    } else {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        const SnackBar(
                                                            content: Text(
                                                                "Failed to delete note")),
                                                      );
                                                    }
                                                  },
                                                  child: const Text('Yes'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      child: const Icon(
                                        Icons.delete_outline,
                                        color: Colors.red,
                                        size: 25,
                                      ),
                                    ),
                                  ],
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
                                  maxLines: 5,
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
                                          isEditing = false; // Cancel editing
                                          descriptionController.text = note
                                              .description; // Reset to original value
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

                                        // Prepare data for the API call
                                        final Map<String, dynamic>
                                            editNoteData = {
                                          'rel_id': widget.lead.id,
                                          'lead_note_description':
                                              descriptionController.text,
                                          'id': note.id,
                                        };
                                        infoLog("edit Note----------------");
                                        infoLog("$editNoteData");
                                        // Call the API
                                        final (
                                          bool status,
                                          Map<String, dynamic> data,
                                          String? message
                                        ) = await ApiService.editNote(
                                            editNoteData);

                                        if (status) {
                                          // Update the note's description locally
                                          setState(() {
                                            note.description =
                                                descriptionController.text;
                                            isEditing = false; // Exit edit mode
                                          });

                                          // Show success message (optional)
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content: Text(message ??
                                                    "Note updated successfully")),
                                          );
                                        } else {
                                          // Show error message
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content: Text(message ??
                                                    "Failed to update note")),
                                          );

                                          // Restore the previous state
                                          setState(() {
                                            isEditing =
                                                true; // Keep editing mode active
                                          });
                                        }
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
                                note.description,
                                textAlign: TextAlign.justify,
                              ),
                            ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
