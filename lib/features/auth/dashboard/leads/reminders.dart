import 'package:crm/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RemindersTab extends StatefulWidget {
  const RemindersTab({super.key});

  @override
  State<RemindersTab> createState() => _RemindersTabState();
}

class _RemindersTabState extends State<RemindersTab> {
  final TextEditingController dateTimeController = TextEditingController();
  Future<void> _pickDateTime() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      TimeOfDay currentTime = TimeOfDay.now(); // Get the current time
      DateTime combinedDateTime = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        currentTime.hour,
        currentTime.minute,
      );
      setState(() {
        dateTimeController.text =
            DateFormat('yyyy-MM-dd HH:mm').format(combinedDateTime);
      });
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
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: '*', // Red asterisk
                              style: TextStyle(
                                  color: Colors
                                      .red, // Set the color of the asterisk to red
                                  fontSize: 18,
                                  fontWeight: FontWeight
                                      .bold // You can adjust the font size here if necessary
                                  ),
                            ),
                            TextSpan(
                              text: ' Date to be notified', // Bolded text
                              style: TextStyle(
                                color: Colors
                                    .black, // Set the color of the text to black
                                fontWeight:
                                    FontWeight.w500, // Make the text bold
                                fontSize:
                                    16, // Adjust the font size if necessary
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: dateTimeController,
                        readOnly: true,
                        decoration: InputDecoration(
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
                SizedBox(height: 10),
                RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: '*', // Red asterisk
                        style: TextStyle(
                            color: Colors
                                .red, // Set the color of the asterisk to red
                            fontSize: 18,
                            fontWeight: FontWeight
                                .bold // You can adjust the font size here if necessary
                            ),
                      ),
                      TextSpan(
                        text: ' Set remainder to', // Bolded text
                        style: TextStyle(
                          color: Colors
                              .black, // Set the color of the text to black
                          fontWeight: FontWeight.w500, // Make the text bold
                          fontSize: 16, // Adjust the font size if necessary
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
                RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: '*', // Red asterisk
                        style: TextStyle(
                            color: Colors
                                .red, // Set the color of the asterisk to red
                            fontSize: 18,
                            fontWeight: FontWeight
                                .bold // You can adjust the font size here if necessary
                            ),
                      ),
                      TextSpan(
                        text: ' Description', // Bolded text
                        style: TextStyle(
                          color: Colors
                              .black, // Set the color of the text to black
                          fontWeight: FontWeight.w500, // Make the text bold
                          fontSize: 16, // Adjust the font size if necessary
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  maxLines: 4,
                  decoration: InputDecoration(
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
                // Rectangular shaped radio button
                const SizedBox(height: 10),
                // Checkbox for Terms and Conditions or agreement
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
                    Expanded(
                      child: Text(
                        'Send also an email for this reminder',
                        style: TextStyle(color: textPrimaryColor),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Close and Save buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // Close the current screen
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            secondaryPrimaryColor, // Close button color
                      ),
                      child: const Text(
                        'Close',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        // Save action here
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            secondaryPrimaryColor, // Save button color
                      ),
                      child: const Text(
                        'Save',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
