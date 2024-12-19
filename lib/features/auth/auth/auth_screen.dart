import 'package:crm/features/auth/dashboard/home_screen.dart';
import 'package:crm/utils/colors.dart';
import 'package:crm/utils/text_field.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen height
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF373b44),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  height: screenHeight /
                      2.1, // First container takes half of the screen height
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                  ),
                  child: Column(
                    children: [
                      //Logo and Text
                      Expanded(
                        child: Image.asset(
                          "assets/logo.png",
                        ),
                      ),

                      Container(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Login",
                              style: TextStyle(
                                fontSize: 35,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Login to your account",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white70,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: screenHeight / 2,
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    const CommonTextField(
                      label: "Email",
                      hint: "test@gmail.com",
                    ),

                    const SizedBox(height: 20),
                    // Password TextField
                    const CommonTextField(
                      label: "Password",
                      isPassword: true,
                    ),
                    const SizedBox(height: 20),
                    // Remember Me and Forgot Password
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: false,
                              shape: const CircleBorder(),
                              onChanged: (value) {},
                              activeColor: Theme.of(context)
                                  .primaryColor, // Primary color for the checkbox
                            ),
                            const Text(
                              "Remember Me",
                              style: TextStyle(color: Colors.black54),
                            ),
                          ],
                        ),
                        const Text(
                          "Forgot Password?",
                          style: TextStyle(
                            color: Color(0xFF007BFF),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    // Sign In Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeScreen()));
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          backgroundColor:
                              secondaryPrimaryColor, // Primary color for the button
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: const Text(
                          "Sign In",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
