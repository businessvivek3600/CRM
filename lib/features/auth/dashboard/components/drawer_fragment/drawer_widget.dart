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
                        Text(appStore.fullName,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 24,
                            )),
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
            ListTile(
              title: const Text('Customer'),
              leading: const Icon(Icons.people),
              trailing: const Icon(Icons.keyboard_arrow_right),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CustomerScreen(),
                    ));
              },
            ),
            ListTile(
              title: const Text('Leads'),
              trailing: const Icon(Icons.keyboard_arrow_right),
              leading: const Icon(Icons.leaderboard),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LeadsScreen(),
                    ));
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () async {
                pl('Running logout...');
                // Call logout method and wait for completion
                bool success = await AuthService().logout();

                if (success) {
                  // Perform navigation after ensuring logout is complete
                  context.goNamed(Routes.login); // Use only one navigation method
                } else {
                  // Handle logout failure if needed
                  pl('Logout failed.');
                }
              },
            ),
          ],
        ),
      ),
    );
  }


}
