import 'package:crm/utils/colors.dart'; // Ensure textPrimaryColor is defined here
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddNotesTab extends StatefulWidget {
  const AddNotesTab({super.key});

  @override
  State<AddNotesTab> createState() => _AddnotesTabState();
}

class _AddnotesTabState extends State<AddNotesTab> {
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
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: noteController,
                  maxLines: 4,
                  decoration: InputDecoration(
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
                  style: TextStyle(color: textPrimaryColor),
                ),
                const SizedBox(height: 10),
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
                          labelStyle: TextStyle(color: textPrimaryColor),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.calendar_today,
                                color: textPrimaryColor),
                            onPressed: _pickDateTime,
                          ),
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
                        style: TextStyle(color: textPrimaryColor),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                RadioListTile(
                  title: Text(
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
                const SizedBox(height: 10),
                RadioListTile(
                  title: Text(
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
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    print("Note: ${noteController.text}");
                    print("Selected Status: $selectedStatus");
                    if (selectedStatus == "I got in touch with this lead") {
                      print("Date and Time: ${dateTimeController.text}");
                    }
                  },
                  child: const Text(
                    'Add Notes',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 17,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: secondaryPrimaryColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
