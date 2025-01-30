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
import '../../../../services/api_services.dart';
import '../../../../store/app_store.dart';
import '../../../../store/lead_store.dart';
import '../../../../widgets/date_formation.dart';

class LeadsScreen extends StatefulWidget {
  const LeadsScreen({super.key});

  @override
  State<LeadsScreen> createState() => _LeadsScreenState();
}

class _LeadsScreenState extends State<LeadsScreen> {
  bool isShow = true;
  int currentPage = 0;
  bool isLoadingMore = false;
  bool hasMore = true;
  final ScrollController _scrollController = ScrollController();


  @override
  void initState() {
    super.initState();
    leadStore.getLeads(page: currentPage).then((_) {
      setState(() {
        isShow = true;
      });
    });
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent &&
        !isLoadingMore &&
        hasMore) {
      _loadMoreLeads();
    }
  }

  Future<void> _loadMoreLeads() async {
    setState(() {
      isLoadingMore = true;
    });

    currentPage++; // Increment the current page
    int previousLength = leadStore.leads.length;
    await leadStore.getLeads(page: currentPage);

    setState(() {
      isLoadingMore = false; // Stop the loading state
      if (leadStore.leads.length == previousLength) {
        hasMore = false; // No new data, stop loading
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    warningLog(" LOGIN TOKEN ____________${appStore.token}");
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
            MaterialPageRoute(builder: (context) => const AddLeads()),
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
                  ? Observer(builder: (_) {
                List<LeadSummary> leadsSummary = leadStore.leadSummary;
                if (leadsSummary.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                return SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: leadStore.leadSummary.length,
                    itemBuilder: (context, index) {
                      final summary = leadsSummary[index];
                      return Padding(
                        padding: const EdgeInsets.only(
                            right: 8.0), // Add spacing between cards
                        child: _buildSummaryCard(summary),
                      );
                    },
                  ),
                );
              })
                  : const SizedBox(),
              const SizedBox(height: 20),

              // Leads Section
              Row(
                children: [
                  Container(
                    width: 4,
                    height: 24,
                    color: Colors.blue,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Leads',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Observer(builder: (_) {
                List<Lead> leads = leadStore.leads;

                return Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: leadStore.leads.length + (hasMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == leadStore.leads.length) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final lead = leads[index];
                      return _buildLeadCard(lead);
                    },
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard(LeadSummary leadSummary) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        width: 100,
        height: 100,
        padding: const EdgeInsets.all(6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              leadSummary.total.toString(),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              leadSummary.name,
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

  Widget _buildLeadCard(Lead lead) {
    final status = leadStore.getStatusById(lead.status);
    final source = leadStore.getSourceById(lead.source);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => LeadDetails(
                lead: lead,
              )),
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
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                    color: getStatusColor(lead.status),
                  ),
                  width: 5,
                  height: 137,
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
                                    lead.name ?? "--",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    lead.title ?? '',
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
                                lead.leadValue ?? "",
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
                                lead.company ?? "",
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            Text(
                              source?.name ?? "",
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
                                  color: getStatusColor(lead.status),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  status?.name ?? "",
                                  style: TextStyle(
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
                                  formatDate(lead.dateadded) ?? '',
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

Color getStatusColor(String statusId) {

  final summary = leadStore.leadSummary.firstWhere(
        (leadSummary) => leadSummary.id == statusId,
    orElse: () => LeadSummary(
        id: '',
        name: '',
        total: 0,
        color: '#5f615c',
        statusOrder: '',
        isDefault: ''), // Default value
  );

  // Return the dynamic color or a default color if not found
  return _hexToColor(summary.color);
}

// Helper function to convert hex color to Flutter Color
Color _hexToColor(String hexColor) {
  hexColor = hexColor.replaceAll('#', '');
  if (hexColor.length == 6) {
    hexColor = 'FF$hexColor'; // Add alpha value if missing
  }
  return Color(int.parse(hexColor, radix: 16));
}
