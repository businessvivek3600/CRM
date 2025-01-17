// import 'package:crm/features/auth/dashboard/components/drawer_fragment/drawer_widget.dart';
import 'package:crm/constants/app_constants.dart';
import 'package:crm/features/auth/dashboard/components/drawer_fragment/drawer_widget.dart';
import 'package:crm/store/app_store.dart';
import 'package:crm/utils/colors.dart';
import 'package:crm/utils/default_logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../services/api_services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    appStore.loadUserData();
    infoLog("User Token: ${appStore.token}");
    infoLog("User Email: ${appStore.userEmail}");
    fetchDashboardData(); // Fetch data when the screen is initialized
  }

  final List<Map<String, dynamic>> metricData = [];
  bool isLoading = true;

  void fetchDashboardData() async {
    try {
      var (bool status, Map<String, dynamic> data, String? message) =
          await ApiService.getDashboardData();
      print('API Response: $data');

      if (status && data.isNotEmpty) {
        setState(() {
          metricData.addAll([
            {
              'icon': Icons.attach_money,
              'count':
                  '${data['invoices']?['pending'] ?? 0} of ${data['invoices']?['total'] ?? 0}',
              'label': 'Invoices Awaiting Payment',
              'color': Colors.black,
            },
            {
              'icon': Icons.refresh,
              'count':
                  '${data['leads']?['converted'] ?? 0} of ${data['leads']?['total'] ?? 0}',
              'label': 'Converted Leads',
              'color': Colors.black,
            },
            {
              'icon': Icons.file_copy,
              'count':
                  '${data['tasks']?['incomplete'] ?? 0} of ${data['tasks']?['total'] ?? 0}',
              'label': 'Not Completed Tasks',
              'color': Colors.black,
            },
            {
              'icon': Icons.add_box,
              'count':
                  '${data['projects']?['inProgress'] ?? 0} of ${data['projects']?['total'] ?? 0}',
              'label': 'Projects In Progress',
              'color': Colors.black,
            },
          ]);
          isLoading = false;
        });
      } else {
        logger.e("Dashboard API Error: ${message ?? 'Unknown error'}");
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      logger.e('Error fetching dashboard data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void getLocation() async {
    LocationPermission permission;

    // Check if permission is granted
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, handle appropriately
        print('Location permissions are denied');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately
      print('Location permissions are permanently denied');
      return;
    }

    // When permissions are granted, get the location
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.low,
    );
    print('Latitude: ${position.latitude}, Longitude: ${position.longitude}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: getLocation,
        child: Icon(Icons.location_history),
      ),
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Observer(builder: (context) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 45,
                            backgroundColor: Colors.grey[200],
                            backgroundImage: appStore.profileImage.isNotEmpty
                                ? NetworkImage(appStore.profileImage)
                                : null,
                            child: appStore.profileImage.isEmpty
                                ? Text(
                                    appStore.fullName.isNotEmpty
                                        ? appStore.fullName[0].toUpperCase()
                                        : '',
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  )
                                : null,
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: 3 / 2.5,
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: metricData.length,
                        itemBuilder: (context, index) {
                          final data = metricData[index];
                          warningLog('metricData: ${data['icon']}');
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
                }),
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
