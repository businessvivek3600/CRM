import 'package:crm/features/auth/dashboard/components/drawer_fragment/leads_screen.dart';
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
          title: Text('Lead Details',
              style: TextStyle(
                color: Colors.white,
              )),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LeadsScreen()),
              );
            },
          ),
          bottom: TabBar(
            labelColor: Colors.white, // Color for selected tab text
            unselectedLabelColor:
                Colors.white70, // Color for unselected tab text
            indicatorColor: Colors.white, // Color for the tab indicator
            tabs: [
              Tab(text: 'Profile'),
              Tab(text: 'Notes'),
              Tab(text: 'Remainder'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ProfileTab(),
            Center(child: Text('Notes')),
            Center(child: Text('Remainder')),
          ],
        ),
      ),
    );
  }
}

class ProfileTab extends StatelessWidget {
  // List of lead details for dynamic cards
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
        'Country': '236',
      },
    },
    // Add more entries here for additional cards
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
// Merged Details Card
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
                      // Company Details with Divider
                      ...detail['companyDetails'].entries.map((entry) {
                        int index = detail['companyDetails']
                            .entries
                            .toList()
                            .indexOf(entry);
                        bool isLast = index ==
                            detail['companyDetails'].entries.length - 1;
                        return Column(
                          children: [
                            DetailRow(
                              label: entry.key,
                              value: entry.value,
                            ),
                            if (!isLast)
                              Divider(), // Add divider except after the last item
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
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween, // Adjust alignment as needed
            children: [
              Text(
                '$label :',
                // First label-value pair
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 10),
              Text(
                '$value', // Second label-value pair
                style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Divider()
            ],
          )
          // Text(
          //   value,
          //   style: TextStyle(fontWeight: FontWeight.bold),
          // ),
        ],
      ),
    );
  }
}
