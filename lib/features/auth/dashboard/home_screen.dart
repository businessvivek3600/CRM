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
import '../../../../store/lead_store.dart';
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
    _initializeData();
  }

  Future<void> _initializeData() async {
    // Display a loading state while fetching data
    appStore.setLoading(true);

    // Fetch dashboard data and user data
    await leadStore.getDashboard();
    await appStore.loadUserData();

    // Hide loading state
    appStore.setLoading(false);
  }

  void getLocation() async {
    LocationPermission permission;

    // Check if permission is granted
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Location permissions are denied');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
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
        child: const Icon(Icons.location_history),
      ),
      drawer: const CustomDrawer(),
      appBar: AppBar(
        backgroundColor: secondaryPrimaryColor,
        elevation: 0,
        title: const Text(
          'Home Screen',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 23, color: white),
        ),
      ),
      body: Observer(
        builder: (context) {
          if (appStore.isLoading) {
            // Show a loading indicator while data is being fetched
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // Show content after data has loaded
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // User Profile Section
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

                  // Dashboard Stats Section
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 3 / 2,
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      String label;
                      IconData icon;
                      String count;
                      Color iconColor;

                      switch (index) {
                        case 0:
                          label = "Total Leads";
                          icon = Icons.star;
                          count = leadStore.firstBox.totalLeads.toString();
                          iconColor = Colors.orange;
                          break;
                        case 1:
                          label = "Converted Leads";
                          icon = Icons.group_add_outlined;
                          count = leadStore.secondBox.totalConverted.toString();
                          iconColor = Colors.green;
                          break;
                        case 2:
                          label = "New Leads";
                          icon = Icons.notifications;
                          count = leadStore.thirdBox.totalNewLeads.toString();
                          iconColor = Colors.red;
                          break;
                        case 3:
                          label = "Total Contacted";
                          icon = Icons.phone;
                          count = leadStore.fourthBox.totalContactLeads.toString();
                          iconColor = Colors.blue;
                          break;
                        default:
                          label = "";
                          icon = Icons.help;
                          count = "0";
                          iconColor = Colors.grey;
                      }

                      return _buildCard(icon, count, label, iconColor);
                    },
                  ),
                  const SizedBox(height: 20),

                  // Leads Overview Section
                  Row(
                    children: [
                      Container(
                        width: 4,
                        height: 24,
                        color: Colors.blue,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        "Leads Overview",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 300,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: leadStore.leadStatusDashboard.length,
                      itemBuilder: (context, index) {
                        final leadStatus = leadStore.leadStatusDashboard[index];
                        final colorCode = leadStatus.color.replaceFirst('#', '');
                        double progressValue = leadStore.firstBox.totalLeads > 0
                            ? leadStatus.total / leadStore.firstBox.totalLeads
                            : 0.0;
                        return InvoiceProgressItem(
                          label: leadStatus.name,
                          value: progressValue,
                          color: Color(int.parse('0xFF$colorCode')),
                          count: leadStatus.total,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, size: 28, color: iconColor), // Smaller icon size
            const SizedBox(height: 6),
            Text(
              count,
              style: const TextStyle(
                fontSize: 16, // Smaller font size
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                fontWeight: FontWeight.bold
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
  final double value;
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
