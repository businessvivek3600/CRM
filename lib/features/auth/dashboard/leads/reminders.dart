import 'package:crm/Models/leads_model.dart';
import 'package:crm/utils/colors.dart';
import 'package:crm/utils/default_logger.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:toastification/toastification.dart';

import '../../../../utils/size_utils.dart';
import '../../../../widgets/date_formation.dart';

class RemindersTab extends StatefulWidget {
  const RemindersTab({super.key, required this.remainder});
  final List<Reminder> remainder;
  @override
  State<RemindersTab> createState() => _RemindersTabState();
}

class _RemindersTabState extends State<RemindersTab> {
  final TextEditingController dateTimeController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

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

  final List<String> _setremainderItems = [
    'Touchwood Tech',
    'Sonu Kumar',
    'Rakesh Mukhi',
    'Manpreet Baggar',
    'Jannat preet',
    'Deepak Kumar',
  ];
  String? _selectedItem;
  bool isChecked = false;

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
                const SizedBox(height: 10),
                RichText(
                  text: const TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: '*',
                        style: TextStyle(
                            color: Colors
                                .red,
                            fontSize: 18,
                            fontWeight: FontWeight
                                .bold
                            ),
                      ),
                      TextSpan(
                        text: ' Set reminder to', // Bolded text
                        style: TextStyle(
                          color: Colors
                              .black,
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
                  items: _setremainderItems
                      .map((item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
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
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: textPrimaryColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: textPrimaryColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: textPrimaryColor),
                    ),
                    hintText: 'Enter description here',
                  ),
                  style: const TextStyle(color: textPrimaryColor),
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
                      activeColor: textPrimaryColor,
                      checkColor: Colors.white,
                    ),
                    const Expanded(
                      child: Text(
                        'Send also an email for this reminder',
                        style: TextStyle(color: textPrimaryColor),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // Close the current screen
                      },
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
                      onPressed: () {
                        // Save action here
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

                height20(),
                ListView.separated(
                    physics: NeverScrollableScrollPhysics(),
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
                      final note = widget.remainder[index];
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
                                        "Note added: ${formatDate(note.date)}",
                                        style: const TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                                  Icon(
                                    note.isnotified == "0" ?  Icons.notifications_outlined : Icons.notifications_active,
                                  size: 25,
                                    color: acceptColor,
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
