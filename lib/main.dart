import 'package:crm/constants/app_constants.dart';
import 'package:crm/features/auth/auth/auth_screen.dart';
import 'package:crm/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'services/theme_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppConst.appName,
      theme: ThemeData(
        primaryColor: AppConst.defaultPrimaryColor,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: secondaryPrimaryColor,
          foregroundColor: Colors.white,
          titleTextStyle: GoogleFonts.lato(
            textStyle: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        textTheme: GoogleFonts.latoTextTheme(), // Apply Lato to all text
        buttonTheme: ButtonThemeData(
          buttonColor: AppConst.defaultPrimaryColor,
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
