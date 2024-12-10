import 'package:crm/constants/app_constants.dart';
import 'package:crm/features/auth/auth/auth_screen.dart';
import 'package:crm/utils/colors.dart';
import 'package:flutter/material.dart';

import 'services/theme_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner:false,
      title: AppConst.appName,
      theme: ThemeData(
        primaryColor: AppConst.defaultPrimaryColor, // Set your default primary color
        scaffoldBackgroundColor: Colors.white, // Optional: Customize scaffold color
        appBarTheme: AppBarTheme(
          backgroundColor: AppConst.defaultPrimaryColor,
          foregroundColor: Colors.white, // Text/icon color for AppBar
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: AppConst.defaultPrimaryColor, // Button color
          textTheme: ButtonTextTheme.primary,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: secondaryPrimaryColor,
            foregroundColor: Colors.white,
          ),
        ),
      ),


      home: const AuthScreen(),
    );
  }
}


