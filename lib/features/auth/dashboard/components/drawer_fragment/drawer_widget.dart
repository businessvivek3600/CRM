import 'package:crm/features/auth/auth/auth_screen.dart';
import 'package:crm/features/auth/dashboard/customer/customer_Screen.dart';
import 'package:crm/features/auth/dashboard/leads/leads_screen.dart';
import 'package:crm/services/auth_services.dart';
import 'package:crm/utils/default_logger.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../../constants/value_constants.dart';
import '../../../../../database/routes/route_name.dart';
import '../../../../../database/routes/route_path.dart';
import '../../../../../database/routes/route_settings.dart';
import '../../../../../store/app_store.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {

  @override
  Widget build(BuildContext context) {
    infoLog(appStore.profileImage);
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Drawer(
        elevation: 6,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        child: ListView(
          children: [
            // Drawer Header
            DrawerHeader(
              decoration: const BoxDecoration(),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
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
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          appStore.fullName,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                          ),
                        ),
                        Text(
                          appStore.userEmail,
                          style: const TextStyle(
                            color: Colors.lightBlueAccent,
                            fontSize: 14,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Customer ListTile
            ListTile(
              title: const Text('Customer'),
              leading: const Icon(Icons.people),
              trailing: const Icon(Icons.keyboard_arrow_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CustomerScreen(),
                  ),
                );
              },
            ),
            // Leads ListTile
            ListTile(
              title: const Text('Leads'),
              leading: const Icon(Icons.leaderboard),
              trailing: const Icon(Icons.keyboard_arrow_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LeadsScreen(),
                  ),
                );
              },
            ),
            // Logout ListTile
            ListTile(
              leading: const Icon(
                Icons.logout,
                color: Colors.red,
              ),
              title: const Text(
                'Logout',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () async {
                bool logoutConfirmed = await _showLogoutDialog(context);
                if (logoutConfirmed) {
                  // Proceed with logout
                  bool success = await AuthService().logout(
                    context: context, // Passing context
                    isSessionExpired: true, // Passing isSessionExpired
                  );
                  if (success) {
                    // Redirect to login screen after successful logout
                    Navigator.pushReplacementNamed(context, '/login');
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  // Logout Confirmation Dialog

  Future<bool> _showLogoutDialog(BuildContext context) async {
    bool result = await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Are you sure?'),
              content: const Text('Do you want to log out?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false); // Cancel
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    // Simulate session expiration (remove user session data here if needed)
                    _logout(context);
                  },
                  child: const Text('Logout'),
                ),
              ],
            );
          },
        ) ??
        false; // Default value if dialog returns null

    return result; // Ensure returning a bool
  }

  void _logout(BuildContext context) {
    // Navigate to AuthScreen and clear all previous routes
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const AuthScreen()),
      (Route<dynamic> route) => false, // Clear all previous routes
    );
  }
}
