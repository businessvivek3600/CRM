import 'package:crm/features/auth/auth/auth_screen.dart';
import 'package:crm/features/auth/dashboard/customer/customer_Screen.dart';
import 'package:crm/features/auth/dashboard/leads/leads_screen.dart';
import 'package:crm/services/auth_services.dart';
import 'package:crm/utils/default_logger.dart';
import 'package:flutter/material.dart';
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
                  const SizedBox(width: 20),
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
                            fontSize: 16,
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
                // Await the dialog result
                bool logoutConfirmed = await showLogoutDialog(context);

                if (logoutConfirmed) {
                  // Proceed with logout
                  bool success = await AuthService().logout(
                    context: context,
                    isSessionExpired: true,
                  );

                  if (success) {
                    // Navigate to login screen after successful logout
                    Navigator.pushReplacementNamed(context, '/login');
                  } else {
                    // Notify the user about logout failure
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Logout failed. Please try again.')),
                    );
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

  Future<bool> showLogoutDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Confirm Logout'),
              content: const Text('Are you sure you want to log out?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false); // User cancels
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true); // User confirms logout
                  },
                  child: const Text('Logout'),
                ),
              ],
            );
          },
        ) ??
        false; // Default to false if dialog is dismissed
  }
}
