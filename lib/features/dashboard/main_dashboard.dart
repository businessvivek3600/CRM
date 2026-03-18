
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:crm/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../../store/app_store.dart';
import '../../services/api_services.dart';
import '../auth/auth_screen.dart';
import 'components/notification_screen.dart';
import 'customer/customer_screen.dart';
import 'home/home_screen.dart';
import 'leads/leads_screen.dart';

class MainDashboard extends StatefulWidget {
  const MainDashboard({super.key});

  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  final NotchBottomBarController _controller = NotchBottomBarController();
  int currentIndex = 0;

  final List<Widget> pages = const [
    HomeScreen(),
    LeadsScreen(),
    CustomerScreen(),
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      extendBody: true,
      /// ----------------------
      /// APP BAR
      /// ----------------------
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        toolbarHeight: 70,
surfaceTintColor: Colors.transparent,
        title: Observer(
          builder: (_) {
            return Row(
              children: [

                /// Profile Image
                CircleAvatar(
                  radius: 20,
                  backgroundImage: appStore.profileImage.isNotEmpty
                      ? NetworkImage(appStore.profileImage)
                      : null,
                  child: appStore.profileImage.isEmpty
                      ? Text(
                    appStore.fullName.isNotEmpty
                        ? appStore.fullName[0].toUpperCase()
                        : "",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  )
                      : null,
                ),

                const SizedBox(width: 12),

                /// Title + Subtitle
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const Text(
                      "CRM Dashboard",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),

                    Text(
                      appStore.fullName,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),

        actions: [

          /// Notification
          GestureDetector(
            child: const Icon(Icons.notifications_outlined,color: Colors.black,),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const NotificationScreen(),
                ),
              );
            },
          ),

          /// Profile Menu
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_outlined,color: Colors.black,),

            onSelected: (value) async {

              if (value == "logout") {

                bool logoutConfirmed = await _showLogoutDialog(context);

                if (logoutConfirmed) {

                  String userId = appStore.staffId;

                  var (bool success, Map<String, dynamic> response, String? message) =
                  await ApiService.getLogout({"staffid": userId.toString()});

                  if (success) {

                    Fluttertoast.showToast(msg: "Logged out Successfully");

                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const AuthScreen()),
                          (_) => false,
                    );

                  } else {

                    Fluttertoast.showToast(msg: message ?? "Logout failed");
                  }
                }
              }
            },

            itemBuilder: (context) => [
              const PopupMenuItem(
                value: "logout",
                child: Row(
                  children: [
                    Icon(Icons.logout, color: Colors.red),
                    SizedBox(width: 10),
                    Text("Logout"),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),

      /// ----------------------
      /// BODY
      /// ----------------------
      body: pages[currentIndex],

      /// ----------------------
      /// BOTTOM NAVIGATION
      /// ----------------------
      bottomNavigationBar: AnimatedNotchBottomBar(
        notchBottomBarController: _controller,
        color: Colors.white,
        showLabel: true,
        notchColor: secondaryPrimaryColor,

        // 2. STYLING: Ensure margins are present to create the floating effect
        removeMargins: false,
        bottomBarWidth: 500,
        durationInMilliSeconds: 300,
        kIconSize: 24,
        kBottomRadius: 28, // Slightly increased for a smoother professional look

        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },

        bottomBarItems: const [

          BottomBarItem(
            inActiveItem: Icon(
              Icons.dashboard_outlined,
              color: Colors.grey,
            ),
            activeItem: Icon(
              Icons.dashboard,
              color: Colors.white,
            ),
            itemLabel: 'Home',
          ),

          BottomBarItem(
            inActiveItem: Icon(
              Icons.leaderboard_outlined,
              color: Colors.grey,
            ),
            activeItem: Icon(
              Icons.leaderboard,
              color: Colors.white,
            ),
            itemLabel: 'Leads',
          ),

          BottomBarItem(

            inActiveItem: Icon(
              Icons.people_outline,
              color: Colors.grey,
            ),
            activeItem: Icon(
              Icons.people,
              color: Colors.white,
            ),
            itemLabel: 'Client',

          ),
        ],
      ),
    );
  }
  Future<bool> _showLogoutDialog(BuildContext context) async {

    /// iOS STYLE
    if (Theme.of(context).platform == TargetPlatform.iOS) {

      return await showCupertinoDialog<bool>(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text("Logout"),
            content: const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text("Are you sure you want to logout?"),
            ),
            actions: [

              CupertinoDialogAction(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("Cancel"),
              ),

              CupertinoDialogAction(
                isDestructiveAction: true,
                onPressed: () => Navigator.pop(context, true),
                child: const Text("Logout"),
              ),
            ],
          );
        },
      ) ??
          false;

    }

    /// ANDROID STYLE
    else {

      return await showDialog<bool>(
        context: context,
        builder: (context) {

          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),

            child: Padding(
              padding: const EdgeInsets.all(20),

              child: Column(
                mainAxisSize: MainAxisSize.min,

                children: [

                  /// ICON
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.logout,
                      color: Colors.red,
                      size: 30,
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// TITLE
                  const Text(
                    "Logout",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// MESSAGE
                  const Text(
                    "Are you sure you want to logout from the CRM?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 24),

                  /// BUTTONS
                  Row(
                    children: [

                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context, false);
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text("Cancel"),
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context, true);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text("Logout"),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ) ??
          false;
    }
  }
}