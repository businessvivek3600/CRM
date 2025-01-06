import 'package:crm/features/auth/dashboard/leads/addnotes.dart';
import 'package:crm/features/auth/dashboard/leads/leads_screen.dart';
import 'package:crm/features/auth/dashboard/leads/reminders.dart';
import 'package:crm/features/auth/dashboard/leads/updatelead.dart';
import 'package:crm/utils/colors.dart';
import 'package:flutter/material.dart';

class LeadDetails extends StatefulWidget {
  const LeadDetails({super.key});

  @override
  State<LeadDetails> createState() => _LeadDetailsState();
}

class _LeadDetailsState extends State<LeadDetails> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LeadDetailsScreen(),
    );
  }
}

class LeadDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: secondaryPrimaryColor,
          title: const Text(
            'Lead Details',
            style: TextStyle(color: Colors.white),
          ),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LeadsScreen(),
                ),
              );
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.edit,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Updatelead(),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(
                Icons.delete,
                color: Colors.white,
              ),
              onPressed: () {
                _showDeleteDialog(
                    context); // Show the delete confirmation dialog
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Material(
              color: const Color(0xfffef7ff), // Background color for TabBar
              child: TabBar(
                labelColor: textPrimaryColor, // Color for selected tab text
                unselectedLabelColor:
                    textPrimaryColor.withOpacity(0.6), // Unselected tab text
                indicatorColor:
                    textPrimaryColor.withOpacity(0.8), // Tab indicator color
                tabs: [
                  const Tab(text: 'Profile'),
                  const Tab(text: 'Notes'),
                  const Tab(text: 'Reminder'),
                ],
              ),
            ),
            Expanded(
              // Ensures TabBarView takes remaining space
              child: TabBarView(
                children: [
                  ProfileTab(), // Includes cards
                  const AddNotesTab(),
                  const RemindersTab()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Exclamation Mark Icon with Gradient Background
                Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Colors.orange, Colors.red],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: const Icon(
                    Icons.error_outline,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 16),

                // Title
                const Text(
                  "Delete Lead",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // Description
                const Text(
                  "Are you sure that you want to delete this Lead?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 24),

                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: secondaryPrimaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop(); // Close dialog
                        },
                        child: const Text(
                          "No",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: secondaryPrimaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LeadsScreen(),
                            ),
                          ); // Close dialog
                          // Add delete functionality here
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text("Lead deleted!"),
                          ));
                        },
                        child: const Text(
                          "Yes",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ProfileTab extends StatelessWidget {
  final List<Map<String, dynamic>> leadDetails = [
    {
      'name': 'John Smith',
      'role': 'CEO',
      'balance': '7500.00',
      'company': 'Google',
      'status': 'Customer',
      'date': '03 Dec 2024',
      'companyDetails': {
        'Company': 'SmithTech Solutions',
        'VAT Number': '-',
        'Phone': '+1 (123) 456-7890',
        'Website': 'https://www.exampleco.com',
        'Address': '456 Oak Street',
        'City': 'San Francisco',
        'State': 'CA',
        'Zip Code': '94110',
        'Country': 'USA',
      },
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: leadDetails.map((detail) {
          return Column(
            children: [
              // Top Summary Card
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                detail['name'],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                detail['role'],
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                detail['balance'],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                detail['company'],
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Divider(),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.check_circle, color: Colors.green),
                              const SizedBox(width: 8),
                              Text(
                                detail['status'],
                                style: const TextStyle(color: Colors.green),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(Icons.calendar_today, color: Colors.blue),
                              const SizedBox(width: 8),
                              Text(
                                detail['date'],
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Details Card
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...detail['companyDetails'].entries.map((entry) {
                        return Column(
                          children: [
                            DetailRow(
                              label: entry.key,
                              value: entry.value,
                            ),
                            const Divider(),
                          ],
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class DetailRow extends StatelessWidget {
  final String label;
  final String value;

  DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label:',
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
