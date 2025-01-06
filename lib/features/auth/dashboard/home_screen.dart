// import 'package:crm/features/auth/dashboard/components/drawer_fragment/drawer_widget.dart';
import 'package:crm/constants/app_constants.dart';
import 'package:crm/features/auth/dashboard/components/drawer_fragment/drawer_widget.dart';
import 'package:crm/store/app_store.dart';
import 'package:crm/utils/colors.dart';
import 'package:crm/utils/default_logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Define the list of data
  @override
  void initState() {
    appStore.loadUserData();
    infoLog("---------------------------------");
    infoLog(appStore.token);
    infoLog(appStore.userEmail);
    super.initState();
  }
  final List<Map<String, dynamic>> metricData = [
    {
      'icon': Icons.attach_money,
      'count': '27 of 31',
      'label': 'Invoices Awaiting Payment',
      'color': Colors.black,
    },
    {
      'icon': Icons.refresh,
      'count': '0 of 0',
      'label': 'Converted Leads',
      'color': Colors.black,
    },
    {
      'icon': Icons.file_copy,
      'count': '121 of 121',
      'label': 'Not Completed Tasks',
      'color': Colors.black,
    },
    {
      'icon': Icons.add_box,
      'count': '8 of 21',
      'label': 'Projects In Progress',
      'color': Colors.black,
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(), // Ensure CustomDrawer is defined properly
      appBar: AppBar(
        backgroundColor: secondaryPrimaryColor,
        elevation: 0,
        title: const Text(
          'Home Screen',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 23, color: white),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Observer(builder: (context) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [

                  // Profile and Welcome Section
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(
                            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRchTRZ8A5eyfaCmAQYhVZA4-vgU-dfV94Ufw&s"),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:  [
                          Text(
                            'Welcome ${appStore.fullName}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                           appStore.userEmail,
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Metrics Grid
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 3 / 2.5,
                      crossAxisCount: 2, // Number of columns
                      crossAxisSpacing: 10, // Reduced spacing for smaller cards
                      mainAxisSpacing: 10, // Reduced spacing for smaller cards
                    ),
                    itemCount: metricData.length,
                    itemBuilder: (context, index) {
                      final data = metricData[index];
                      return _buildCard(
                        data['icon'],
                        data['count'],
                        data['label'],
                        data['color'],
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  // Invoice Progress Bars
                  const Text(
                    "Leads Overview",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const InvoiceProgressItem(
                    label: "New Lead",
                    value: 0.1, // Percentage of progress
                    color: Colors.red,
                    count: 2,
                  ),
                  const InvoiceProgressItem(
                    label: "Contacted",
                    value: 0.4,
                    color: Colors.green,
                    count: 4,
                  ),
                  const InvoiceProgressItem(
                    label: "Qualified",
                    value: 0.2,
                    color: Colors.blue,
                    count: 2,
                  ),
                  const InvoiceProgressItem(
                    label: "Negotiating",
                    value: 0.7,
                    color: Colors.orange,
                    count: 23,
                  ),
                  const InvoiceProgressItem(
                    label: "Closed-Won",
                    value: 0.5,
                    color: Colors.green,
                    count: 23,
                  ),
                  const InvoiceProgressItem(
                    label: "Closed-Lost",
                    value: 0.6,
                    color: Colors.red,
                    count: 23,
                  ),
                  const InvoiceProgressItem(
                    label: "Pending",
                    value: 0.7,
                    color: Colors.orange,
                    count: 23,
                  ),
                  const InvoiceProgressItem(
                    label: "On Hold",
                    value: 0.3,
                    color: Colors.grey,
                    count: 23,
                  ),

                  const InvoiceProgressItem(
                    label: "Reopened",
                    value: 0.4,
                    color: Colors.purple,
                    count: 23,
                  ),
                  const InvoiceProgressItem(
                    label: "Converted",
                    value: 0.4,
                    color: Colors.blue,
                    count: 23,
                  ),
                  const InvoiceProgressItem(
                    label: "Customer",
                    value: 0.7,
                    color: Colors.lightGreen,
                    count: 23,
                  ),
                ],
              );
            }
          ),
        ),
      ),
    );
  }

  Widget _buildCard(
      IconData icon, String count, String label, Color iconColor) {
    return Card(
      color: Colors.white, // Set card color to white
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 13),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 28, color: iconColor), // Smaller icon size
            const SizedBox(height: 6),
            Text(
              count,
              style: const TextStyle(
                fontSize: 12, // Smaller font size
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10, // Smaller font size for label
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InvoiceProgressItem extends StatelessWidget {
  final String label;
  final double value; // Progress value (0.0 to 1.0)
  final Color color;
  final int count;

  const InvoiceProgressItem({
    required this.label,
    required this.value,
    required this.color,
    required this.count,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              Text(
                "$count",
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 5),
          LinearProgressIndicator(
            value: value,
            backgroundColor: Colors.grey[300],
            color: color,
            minHeight: 6,
          ),
        ],
      ),
    );
  }
}
