import 'package:crm/features/auth/auth/auth_screen.dart';
import 'package:crm/features/auth/dashboard/components/drawer_fragment/customer_Screen.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
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
            const DrawerHeader(
              decoration: BoxDecoration(),
              child: Row(
                children: [
                  CircleAvatar(

                    radius: 45,
                    backgroundImage: NetworkImage(
                        "https://img.freepik.com/free-psd/expressive-man-gesturing_23-2150198787.jpg"),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('John Doe',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 24,
                            )),
                        Text(
                          'johndoe23@gmail.com',
                          style: TextStyle(
                            color: Colors.lightBlueAccent,
                            fontSize: 16,decoration: TextDecoration.underline,
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
                Navigator.push(context, MaterialPageRoute(builder: (context) => const CustomerScreen(),));
              },
            ),
            ListTile(
              title: const Text('Leads'),
              trailing: const Icon(Icons.keyboard_arrow_right),
              leading: const Icon(Icons.leaderboard),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              trailing: const Icon(Icons.keyboard_arrow_right),
              title: const Text('Logout'),
              onTap: () {
               Navigator.push(context, MaterialPageRoute(builder: (context) => const AuthScreen(),));
              },
            ),
          ],
        ),
      ),
    );
  }
}
