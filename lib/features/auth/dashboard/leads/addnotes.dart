import 'package:crm/Models/leads_model.dart';
import 'package:crm/utils/colors.dart';
import 'package:crm/utils/default_logger.dart';
import 'package:crm/utils/size_utils.dart';
import 'package:crm/widgets/date_formation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../../services/api_services.dart';


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
  final FocusNode noteFocusNode = FocusNode();
  final FocusNode dateTimeFocusNode = FocusNode();
  DateTime? selectedDateTime;

  Future<void> _pickDateTime() async {
    FocusScope.of(context).unfocus();
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
  void dispose() {
    noteController.dispose();
    dateTimeController.dispose();
    noteFocusNode.dispose();
    dateTimeFocusNode.dispose();
    super.dispose();
  }
  bool isEditing = false;
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
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) {
                    // Move focus to the date/time field
                    FocusScope.of(context).requestFocus(dateTimeFocusNode);
                  },
                  decoration: const InputDecoration(
                    labelText: 'Add Note',
                    labelStyle: TextStyle(color: textPrimaryColors),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: textPrimaryColors),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: textPrimaryColors),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: textPrimaryColors),
                    ),
                  ),
                  style: const TextStyle(color: textPrimaryColors),
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
                height10(),
                RadioListTile(
                  title: const Text(
                    "I got in touch with this lead",
                    style: TextStyle(color: textPrimaryColors),
                  ),
                  value: "I got in touch with this lead",
                  groupValue: selectedStatus,
                  activeColor: textPrimaryColors,
                  onChanged: (value) {
                    setState(() {
                      selectedStatus = value!;
                    });
                  },
                ),
                RadioListTile(
                  title: const Text(
                    "I have not contacted this lead",
                    style: TextStyle(color: textPrimaryColors),
                  ),
                  value: "I have not contacted this lead",
                  groupValue: selectedStatus,
                  activeColor: textPrimaryColors,
                  onChanged: (value) {
                    setState(() {
                      selectedStatus = value!;
                    });
                  },
                ),
                height10(),
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

                        if (selectedStatus == "I got in touch with this lead" &&
                            dateTimeController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Please select a date and time."),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return; // Stop execution
                        }


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

                        if (response["status"] == true) {
                          // Parse the new note from response
                          final newNoteData = (response['data'] as List)
                              .map((e) => NoteData.fromJson(e))
                              .toList();

                          // Update the noteData list and refresh the UI
                          setState(() {
                            widget.noteData
                                .insertAll(0, newNoteData); // Insert at the top
                          });

                          // Clear the form and reset status
                          noteController.clear();
                          setState(() {
                            selectedStatus = "I have not contacted this lead";
                          });

                          toast(response['message'],
                              gravity: ToastGravity.TOP,
                              textColor: Colors.white,
                              bgColor: completedColor);
                        } else {
                          // Show an error message
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  response['message'] ?? "Failed to add note"),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: secondaryPrimaryColor,
                      ),
                      child: const Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        child: Text(
                          'Add Notes',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 17,
                            color: Colors.white,
                          ),
                        ),
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
                  itemCount: widget.noteData.length,
                  itemBuilder: (context, index) {
                    widget.noteData
                        .sort((a, b) => b.dateadded.compareTo(a.dateadded));

                    final note = widget.noteData[index];
                    final TextEditingController descriptionController =
                        TextEditingController(text: note.description);

                    // State variable for inline editing


                    return  Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 10,
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

                                                    var (bool status, Map<String, dynamic> data, String? message) = await ApiService
                                                        .deleteNote(deleteNote);
                                                    if (data["status"]) {
                                                      setState(() {
                                                       widget.noteData.removeAt(index);
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
                          height10(),
                        ],

                    );},
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
