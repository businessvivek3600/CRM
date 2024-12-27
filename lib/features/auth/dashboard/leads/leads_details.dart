import 'package:crm/features/auth/dashboard/leads/addnotes.dart';
import 'package:crm/features/auth/dashboard/leads/leads_screen.dart';
import 'package:crm/features/auth/dashboard/leads/reminders.dart';
import 'package:crm/features/auth/dashboard/leads/updatelead.dart';
import 'package:crm/utils/colors.dart';
import 'package:flutter/material.dart';

class Leads_Details extends StatefulWidget {
  const Leads_Details({super.key});

  @override
  State<Leads_Details> createState() => _Leads_DetailsState();
}

class _Leads_DetailsState extends State<Leads_Details> {
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
          title: Text(
            'Lead Details',
            style: TextStyle(color: Colors.white),
          ),
          leading: IconButton(
            icon: Icon(
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
              icon: Icon(
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
              icon: Icon(
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
              color: Color(0xfffef7ff), // Background color for TabBar
              child: TabBar(
                labelColor: textPrimaryColor, // Color for selected tab text
                unselectedLabelColor:
                    textPrimaryColor.withOpacity(0.6), // Unselected tab text
                indicatorColor:
                    textPrimaryColor.withOpacity(0.8), // Tab indicator color
                tabs: [
                  Tab(text: 'Profile'),
                  Tab(text: 'Notes'),
                  Tab(text: 'Reminder'),
                ],
              ),
            ),
            Expanded(
              // Ensures TabBarView takes remaining space
              child: TabBarView(
                children: [
                  ProfileTab(), // Includes cards
                  AddNotesTab(),
                  RemindersTab()
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
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Colors.orange, Colors.red],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  padding: EdgeInsets.all(16),
                  child: Icon(
                    Icons.error_outline,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
                SizedBox(height: 16),

                // Title
                Text(
                  "Delete Lead",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),

                // Description
                Text(
                  "Are you sure that you want to delete this Lead?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
                SizedBox(height: 24),

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
                          padding: EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop(); // Close dialog
                        },
                        child: Text(
                          "No",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: secondaryPrimaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LeadsScreen(),
                            ),
                          ); // Close dialog
                          // Add delete functionality here
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Lead deleted!"),
                          ));
                        },
                        child: Text(
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
      padding: EdgeInsets.all(16.0),
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
                  padding: EdgeInsets.all(16.0),
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
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                detail['role'],
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                detail['balance'],
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                detail['company'],
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Divider(),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.check_circle, color: Colors.green),
                              SizedBox(width: 8),
                              Text(
                                detail['status'],
                                style: TextStyle(color: Colors.green),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.calendar_today, color: Colors.blue),
                              SizedBox(width: 8),
                              Text(
                                detail['date'],
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              // Details Card
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 4,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
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
                            Divider(),
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
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
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
