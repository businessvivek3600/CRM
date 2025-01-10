import 'package:crm/Models/leads_model.dart';
import 'package:crm/utils/colors.dart';
import 'package:crm/utils/size_utils.dart';
import 'package:crm/widgets/date_formation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddNotesTab extends StatefulWidget {
  const AddNotesTab({super.key, required this.noteData});
  final List<NoteData> noteData;
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
                      onPressed: () {},
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
                      widget.noteData.sort((a, b) => b.dateadded.compareTo(a.dateadded));

                      final note = widget.noteData[index];
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
                              if(note.editDelete == 1)
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.edit_note_sharp,
                                    size: 25,
                                    color: acceptColor,
                                  ),
                                  Icon(
                                    Icons.close,
                                    color: Colors.red,
                                    size: 25,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            note.description,
                            textAlign: TextAlign.justify,
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
}
