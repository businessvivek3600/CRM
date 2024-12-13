import 'package:crm/features/auth/dashboard/components/drawer_fragment/leads_details.dart';
import 'package:crm/features/auth/dashboard/home_screen.dart';
import 'package:crm/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LeadsScreen extends StatefulWidget {
  const LeadsScreen({super.key});

  @override
  State<LeadsScreen> createState() => _LeadsScreenState();
}

class _LeadsScreenState extends State<LeadsScreen> {
  bool? isShow;
  final List<Map<String, String>> summaryData = [
    {"count": "2", "label": "New Lead"},
    {"count": "4", "label": "Contacted"},
    {"count": "0", "label": "Qualified"},
    {"count": "3", "label": "Missed"},
    {"count": "2", "label": "New Lead"},
    {"count": "4", "label": "Contacted"},
    {"count": "0", "label": "Qualified"},
    {"count": "3", "label": "Missed"},
  ];

  final List<Map<String, dynamic>> leads = [
    {
      "name": "John Smith",
      "role": "CEO - SmithTech Solutions",
      "status": "Customer",
      "statusColor": Colors.green,
      "amount": "7500.00",
      "platform": "Google",
      "date": "03 Dec 2024",
    },
    {
      "name": "Emily Johnson",
      "role": "Marketing Manager - Marketing Pros Inc.",
      "status": "Converted",
      "statusColor": Colors.blue,
      "amount": "5500.00",
      "platform": "Facebook",
      "date": "03 Dec 2024",
    },
    {
      "name": "Michael Williams",
      "role": "Sales Director - SalesCorp Ltd.",
      "status": "Reopened",
      "statusColor": Colors.purple,
      "amount": "6200.00",
      "platform": "Google",
      "date": "03 Dec 2024",
    },
    {
      "name": "Sophia Brown",
      "role": "Marketing Coordinator - Digital Marketers...",
      "status": "New Lead",
      "statusColor": Colors.teal,
      "amount": "4800.00",
      "platform": "Facebook",
      "date": "03 Dec 2024",
    },
    {
      "name": "John Smith",
      "role": "CEO - SmithTech Solutions",
      "status": "Customer",
      "statusColor": Colors.green,
      "amount": "7500.00",
      "platform": "Google",
      "date": "03 Dec 2024",
    },
    {
      "name": "Emily Johnson",
      "role": "Marketing Manager - Marketing Pros Inc.",
      "status": "Converted",
      "statusColor": Colors.blue,
      "amount": "5500.00",
      "platform": "Facebook",
      "date": "03 Dec 2024",
    },
    {
      "name": "Michael Williams",
      "role": "Sales Director - SalesCorp Ltd.",
      "status": "Reopened",
      "statusColor": Colors.purple,
      "amount": "6200.00",
      "platform": "Google",
      "date": "03 Dec 2024",
    },
    {
      "name": "Sophia Brown",
      "role": "Marketing Coordinator - Digital Marketers...",
      "status": "New Lead",
      "statusColor": Colors.teal,
      "amount": "4800.00",
      "platform": "Facebook",
      "date": "03 Dec 2024",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondaryPrimaryColor,
        title: const Text(
          'Leads',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const HomeScreen(),
              ),
            );
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Lead Summary Section
              Row(
                children: [
                  Container(
                    width: 4,
                    height: 24,
                    color: Colors.blue,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Lead Summary',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        if (isShow == true) {
                          isShow = false;
                        } else {
                          isShow = true;
                        }
                      });
                    },
                    icon: const Icon(
                      Icons.keyboard_arrow_down_outlined,
                      size: 25,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10),
              isShow == true
                  ? SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: summaryData.map((data) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 2.0),
                            child: _buildSummaryCard(
                                data["count"]!, data["label"]!),
                          );
                        }).toList(),
                      ),
                    )
                  : const SizedBox(),
              const SizedBox(height: 20),
              // Leads Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Leads',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.filter_list,
                          color: Theme.of(context).colorScheme.primary,
                          size: 25,
                        ),
                      ),
                      Text(
                        'Filter',
                        style: TextStyle(
                          fontSize: 18,
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  // physics: const NeverScrollableScrollPhysics(),
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: leads.length,
                  itemBuilder: (context, index) {
                    final lead = leads[index];
                    return _buildLeadCard(lead);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard(String count, String label) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        width: 100,
        height: 80,
        padding: const EdgeInsets.all(6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              count,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeadCard(Map<String, dynamic> lead) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Leads_Details()),
        );
      },
      child: Stack(children: [
        SingleChildScrollView(
          child: Card(
            elevation: 8,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child: Row(
              children: [
                // Colored bar
                Container(
                  width: 5,
                  height: 100,
                  color: lead["statusColor"],
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lead["name"],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          lead["role"],
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        const Divider(),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  size: 16,
                                  color: lead["statusColor"],
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  lead["status"],
                                  style: TextStyle(
                                    color: lead["statusColor"],
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.calendar_today,
                                  size: 16,
                                  color: Colors.blue,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  lead["date"],
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        lead["amount"],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        lead["platform"],
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
