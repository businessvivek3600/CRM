import 'package:crm/features/auth/dashboard/leads/addleads.dart';

import 'package:crm/features/auth/dashboard/leads/leads_details.dart';
import 'package:crm/features/auth/dashboard/home_screen.dart';
import 'package:crm/utils/colors.dart';
import 'package:crm/utils/default_logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';

import '../../../../Models/leads_model.dart';
import '../../../../store/lead_store.dart';

class LeadsScreen extends StatefulWidget {
  const LeadsScreen({super.key});

  @override
  State<LeadsScreen> createState() => _LeadsScreenState();
}

class _LeadsScreenState extends State<LeadsScreen> {
  bool isShow = true;
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

  @override
  void initState() {
    super.initState();
    // Calling getLeads method on screen initialization
    leadStore.getLeads();
  }

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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your action here, e.g., navigate to a new screen.
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Addleads()),
          );
        },
        shape: const CircleBorder(),
        backgroundColor: secondaryPrimaryColor,
        child: const Icon(
          Icons.add,
          color: Colors.white,
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
                        isShow = !isShow; // Toggle the visibility of the list
                      });
                    },
                    icon: Icon(
                      isShow
                          ? Icons.keyboard_arrow_up_outlined // Show up arrow
                          : Icons
                              .keyboard_arrow_down_outlined, // Show down arrow
                      size: 25,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              isShow
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
              Observer(builder: (_) {
                if (leadStore.leads == null) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  // You can print the lead values here for debugging
                  List<Lead> leads = leadStore
                      .leads;
                  if (leads.isNotEmpty) {
                    for (var lead in leads) {
                      successLog(
                          'Lead: ${lead.name}, ${lead.title}, ${lead.company}');
                    }
                  }

                  // Displaying leads on the screen
                  return Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      // physics: const NeverScrollableScrollPhysics(),
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: leads.length,
                      itemBuilder: (context, index) {
                        final lead = leads[index];

                        final leadMap = {
                          "statusColor": lead.status  ?? "User",
                          "name": lead.name ?? "",
                          "amount": lead.leadValue ?? "",
                          "role": lead.company ?? "",
                          "platform": lead.website ?? "",
                          "status": getStatusText(lead.status) ?? "",
                          "date": formatDate(lead.dateadded) ?? "",
                          "color" : getStatusColor(lead.status) ?? "",
                          "company": lead.company ?? "",
                        };
                        return _buildLeadCard(leadMap);
                      },
                    ),
                  );
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
  String getStatusText(status) {
    switch (status) {
      case "1":
        return "Customer";
      case "2":
        return "New Lead";
      case "3":
        return "Calling";
      case "4":
        return "Contacted";
      case "5":
        return "Follow Up";
      case "6":
        return "Demo Sent";
      case "7":
        return "Proposal sent";
      case "8":
        return "Hot";
      case "9":
        return "Cold";
      case "10":
        return "Meeting Done";
      case "11":
        return "Budget Issues";
      case "12":
        return "Awaiting";
      case "13":
        return "Duplicate Lead";
      case "14":
        return "Not Required";
      case "15":
        return "Wrong";
      case "16":
        return "WA Sent";
      case "17":
        return "Language Barrier";
      case "18":
        return "Test Lead";
      case "19":
        return "Invalid Lead";
      case "20":
        return "Potential";
      default:
        return "";
    }
  }
  Color getStatusColor(status) {
    switch (status) {
      case "1":
        return Colors.lightGreen;
      case "2":
        return  Colors.lightBlueAccent;
      case "4":
        return Colors.green;
      default:
        return Colors.redAccent;
    }
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
  String formatDate(String date) {
    try {
      DateTime parsedDate = DateTime.parse(date);
      return DateFormat('dd MMM yyyy h:mm a').format(parsedDate);
    } catch (e) {
      return date;
    }
  }
  Widget _buildLeadCard(Map<String, dynamic> lead) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Leads_Details()),
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
                  decoration:  BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                    color: lead["color"],
                  ),
                  width: 5,
                  height: 120,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
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
                                  const SizedBox(height: 8,),
                                  Text(
                                    lead["company"],
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Text(
                                lead["amount"],
                                textAlign: TextAlign.end,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                lead["role"],
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            Text(
                              lead["platform"],
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                              ),
                            ),
                          ],
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
                                  color: lead["color"]
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  lead["status"],
                                  style:  TextStyle(
                                    color: Colors.grey.shade400,
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

                // Padding(
                //   padding: const EdgeInsets.all(12.0),
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.end,
                //     children: [
                //       Text(
                //         lead["platform"],
                //         style: const TextStyle(
                //           fontSize: 12,
                //           color: Colors.grey,
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
