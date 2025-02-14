import 'package:crm/features/auth/auth/auth_screen.dart';
import 'package:crm/features/auth/dashboard/components/notification_screen.dart';
import 'package:crm/features/auth/dashboard/customer/customer_Screen.dart';
import 'package:crm/features/auth/dashboard/leads/leads_screen.dart';
import 'package:crm/services/auth_services.dart';
import 'package:crm/store/app_store.dart';
import 'package:crm/store/lead_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../utils/colors.dart';
// import 'package:nb_utils/nb_utils.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        elevation: 6,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            // Compact Drawer Header
            Observer(
              builder: (_) {
                final companyInfo = leadStore.companyInfo;
                return Padding(
                  padding: const EdgeInsets.only(right: 30),
                  child: Container(
                    height: 120, // Reduced height
                    alignment: Alignment.center,
                    child: companyInfo?.logo?.isNotEmpty ?? false
                        ? Image.network(
                            companyInfo!.logo!,
                            width: 230,
                            height: 100,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) =>
                                const SizedBox(),
                          )
                        : const SizedBox(),
                  ),
                );
              },
            ),
            const Divider(),

            // Compact ListView Items
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildDrawerItem(
                    icon: Icons.people,
                    text: "Customer",
                    textStyle: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CustomerScreen()),
                    ),
                  ),
                  _buildDrawerItem(
                    icon: Icons.leaderboard,
                    text: "Leads",
                    textStyle: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LeadsScreen()),
                    ),
                  ),
                  // _buildDrawerItem(
                  //   icon: Icons.notifications,
                  //   text: "Notification",
                  //   textStyle: const TextStyle(
                  //       fontSize: 16, fontWeight: FontWeight.bold),
                  //   onTap: () => Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => const NotificationScreen()),
                  //   ),
                  // ),
                  if(appStore.userEmail == "touchcode@gmail.com")
                  _buildDrawerItem(
                    icon: Icons.delete,
                    text: "Delete",
                    iconColor: Colors.black,
                    textStyle: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                    onTap: () {
                      _showDeleteDialog(context);
                    },
                  ),
                ],
              ),
            ),

            // Profile Section
            _buildProfileSection(),
          ],
        ),
      ),
    );
  }
  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Exclamation Mark Icon with Gradient Background
                Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Colors.redAccent, Colors.red],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: const Icon(
                    Icons.delete_outline,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 16),

                // Title
                const Text(
                  "Delete Account",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // Description
                const Text(
                  "Are you sure that you want to delete your account?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 24),

                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: secondaryPrimaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop(); // Close dialog
                        },
                        child: const Text(
                          "No",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: secondaryPrimaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () async {
                          final Uri url = Uri.parse('https://crm.touchwoodtechnologies.com/delete_account');
                          await launchUrl(url);
                        },
                        child: const Text(
                          "Yes",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  // Compact Drawer Item
  Widget _buildDrawerItem({
    required IconData icon,
    required String text,
    Color iconColor = Colors.black,
    TextStyle textStyle = const TextStyle(fontSize: 14),
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      leading: Icon(icon, color: iconColor, size: 22),
      title: Text(text, style: textStyle),
      trailing: const Icon(Icons.keyboard_arrow_right, size: 18),
      onTap: onTap,
    );
  }

  // Profile Section - Compact
  Widget _buildProfileSection() {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black12, width: 1.0),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25, // Compact size
            backgroundImage: appStore.profileImage.isNotEmpty
                ? NetworkImage(appStore.profileImage)
                : null,
            child: appStore.profileImage.isEmpty
                ? Text(
                    appStore.fullName.isNotEmpty
                        ? appStore.fullName[0].toUpperCase()
                        : '',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  appStore.fullName ?? "User Name",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  appStore.userEmail ?? "user@example.com",
                  style: const TextStyle(
                    color: Colors.lightBlueAccent,
                    fontSize: 12,
                    decoration: TextDecoration.underline,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black, size: 20),
            onPressed: () async {
              bool logoutConfirmed = await _showLogoutDialog(context);
              if (logoutConfirmed) {
                if (mounted) {
                  bool success = await AuthService().logout(
                    context: context,
                    isSessionExpired: true,
                  );

                  if (success) {
                    Fluttertoast.showToast(msg: 'Logged out Successfully!');
                    if (mounted) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const AuthScreen()),
                        (_) => false,
                      );
                    }
                  }
                }
              }
            },
          ),
        ],
      ),
    );
  }

  // Logout Dialog
  Future<bool> _showLogoutDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Are you sure?'),
              content: const Text('Do you want to log out?'),
              actions: [
                TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Cancel')),
                TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('Logout')),
              ],
            );
          },
        ) ??
        false;
  }
}
