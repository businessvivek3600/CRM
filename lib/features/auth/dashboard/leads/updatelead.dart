import 'package:crm/features/auth/dashboard/leads/leads_details.dart';
import 'package:crm/utils/colors.dart';
import 'package:crm/utils/text_field.dart';
import 'package:flutter/material.dart';

class Updatelead extends StatefulWidget {
  const Updatelead({super.key});

  @override
  State<Updatelead> createState() => _UpdateleadState();
}

class _UpdateleadState extends State<Updatelead> {
  final List<String> _dropdownItems = [
    'Facebook',
    'Google',
    'Instagram',
    'LinkedIn',
    'Pinterest',
    'Reddit',
    'Snapchat',
    'Twitter',
    'Youtube'
  ];
  final List<Map<String, dynamic>> _statusdropdownItems = [
    {'label': 'New Lead', 'color': Colors.blue},
    {'label': 'Contacted', 'color': Colors.green},
    {'label': 'Qualified', 'color': Colors.yellow},
    {'label': 'Negotiating', 'color': Colors.pink},
    {'label': 'Closed - Won', 'color': Colors.green},
    {'label': 'Closed - Lost', 'color': Colors.red},
    {'label': 'Pending', 'color': Colors.orange},
    {'label': 'On Hold', 'color': Colors.grey},
    {'label': 'Reopened', 'color': Colors.purple},
    {'label': 'Converted', 'color': Colors.blue},
    {'label': 'Customer', 'color': Colors.green},
  ];
  String? _selectedItem;
  Map<String, dynamic>? _statusselectedItem;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondaryPrimaryColor,
        title: const Text(
          'Update Leads',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      resizeToAvoidBottomInset: true, // Adjusts UI when keyboard appears
      body: Column(
        children: [
          // Scrollable form content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DropdownButtonFormField<String>(
                    value: _selectedItem,
                    items: _dropdownItems
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
                      labelText: 'Select Source',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  DropdownButtonFormField<Map<String, dynamic>>(
                    value: _statusselectedItem,
                    items: _statusdropdownItems.map((item) {
                      return DropdownMenuItem<Map<String, dynamic>>(
                        value: item,
                        child: Text(
                          item['label'],
                          style: TextStyle(
                            color: item['color'],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _statusselectedItem = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Select Status',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  const CommonTextField(
                    label: 'Name',
                    hint: 'Enter Your Name',
                  ),
                  const SizedBox(height: 15),
                  const CommonTextField(
                    label: 'Lead Value',
                    hint: 'Lead Value',
                  ),
                  const SizedBox(height: 15),
                  const CommonTextField(
                    label: 'Position',
                    hint: 'Position',
                  ),
                  const SizedBox(height: 15),
                  const CommonTextField(
                    label: 'Email',
                    hint: 'Enter Your Email',
                  ),
                  const SizedBox(height: 15),
                  const CommonTextField(
                    label: 'Website',
                    hint: 'Enter Website Name',
                  ),
                  const SizedBox(height: 15),
                  const CommonTextField(
                    label: 'Company',
                    hint: 'Enter Company Name',
                  ),
                  const SizedBox(height: 15),
                  const CommonTextField(
                    label: 'Address',
                    hint: 'Enter Address',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10),
        child: ElevatedButton(
          onPressed: () {},
          child: const Text(
            'Update',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 17, color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: secondaryPrimaryColor,
            padding: const EdgeInsets.symmetric(horizontal: 135, vertical: 12),
          ),
        ),
      ),
    );
  }
}
