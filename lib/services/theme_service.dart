
import '../constants/value_constants.dart';
import '/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';

class AppTheme {
  //
  AppTheme._();

  static ThemeData lightTheme({Color? color}) => ThemeData(
        useMaterial3: true,
        primarySwatch: createMaterialColor(color ?? primaryColor),
        primaryColor: color ?? primaryColor,
        colorScheme: ColorScheme.fromSeed(
            seedColor: color ?? primaryColor, outlineVariant: borderColor),
        scaffoldBackgroundColor: Colors.white,
        fontFamily: GoogleFonts.workSans().fontFamily,
        bottomNavigationBarTheme:
            const BottomNavigationBarThemeData(backgroundColor: Colors.white),
        iconTheme: const IconThemeData(color: appTextSecondaryColor),
        textTheme: GoogleFonts.workSansTextTheme(),
        unselectedWidgetColor: Colors.black,
        dividerColor: borderColor,
        bottomSheetTheme: BottomSheetThemeData(
            shape: RoundedRectangleBorder(
                borderRadius: radiusOnly(
                    topLeft: DEFFAULT_RADIUS, topRight: DEFFAULT_RADIUS)),
            backgroundColor: Colors.white),
        cardColor: cardColor,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: color ?? primaryColor),
        appBarTheme: AppBarTheme(
            foregroundColor: Colors.white,
            backgroundColor: primaryColor,
            systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarIconBrightness: Brightness.light)),
    dialogTheme: DialogThemeData(shape: dialogShape(20)),
        navigationBarTheme: NavigationBarThemeData(
            labelTextStyle:
                WidgetStateProperty.all(primaryTextStyle(size: 10))),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: <TargetPlatform, PageTransitionsBuilder>{
            TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
            TargetPlatform.linux: OpenUpwardsPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
      );

  static ThemeData darkTheme({Color? color}) => ThemeData(
        useMaterial3: true,
        primarySwatch: createMaterialColor(color ?? primaryColor),
        primaryColor: color ?? primaryColor,
        colorScheme: ColorScheme.fromSeed(
            seedColor: color ?? primaryColor, outlineVariant: borderColor),
        appBarTheme: const AppBarTheme(
          foregroundColor: Colors.white,
          backgroundColor: scaffoldColorDark,
          systemOverlayStyle:
              SystemUiOverlayStyle(statusBarIconBrightness: Brightness.light),
        ),
        scaffoldBackgroundColor: scaffoldColorDark,
        fontFamily: GoogleFonts.workSans().fontFamily,
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: scaffoldSecondaryDark),
        iconTheme: const IconThemeData(color: Colors.white),
        textTheme: GoogleFonts.workSansTextTheme(),
        unselectedWidgetColor: Colors.white60,
        bottomSheetTheme: BottomSheetThemeData(
          shape: RoundedRectangleBorder(
              borderRadius: radiusOnly(
                  topLeft: DEFFAULT_RADIUS, topRight: DEFFAULT_RADIUS)),
          backgroundColor: scaffoldSecondaryDark,
        ),
        dividerColor: dividerDarkColor,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: color ?? primaryColor),
        cardColor: scaffoldSecondaryDark,
    dialogTheme: DialogThemeData(shape: dialogShape()),
        navigationBarTheme: NavigationBarThemeData(
            labelTextStyle: WidgetStateProperty.all(
                primaryTextStyle(size: 10, color: Colors.white))),
      ).copyWith(
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: <TargetPlatform, PageTransitionsBuilder>{
            TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
            TargetPlatform.linux: OpenUpwardsPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
      );

  static ThemeData dynamicTheme(ThemeSetColor set, [bool darkMode = false]) {
  
    ThemeData themeData = ThemeData(
      brightness: darkMode ? Brightness.dark : Brightness.light,
      primarySwatch: createMaterialColor(set.primaryColor),
      primaryColor: set.primaryColor,
      colorScheme: ColorScheme.fromSeed(
          seedColor: set.primaryColor, outlineVariant: borderColor),

      ///appbar
      appBarTheme: AppBarTheme(
        foregroundColor: set.appBarTextColor,
        backgroundColor: set.appBarColor,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: set.brightness == Brightness.dark
              ? Brightness.light
              : Brightness.dark,
          systemNavigationBarColor: set.scaffoldColor,
          systemNavigationBarIconBrightness: set.brightness == Brightness.dark
              ? Brightness.light
              : Brightness.dark,
        ),
      ),
      scaffoldBackgroundColor: set.scaffoldColor,
      fontFamily: set.fontFamily,
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: set.bottomNavigationBarColor,
          selectedItemColor: set.bottomNavigationBarSelectedIconColor,
          unselectedItemColor: set.bottomNavigationBarUnSelectedTextColor,
          selectedLabelStyle: primaryTextStyle(
              size: 10, color: set.bottomNavigationBarSelectedTextColor)),
      iconTheme: IconThemeData(color: set.iconColor, opacity: 1, size: 24.0),
      textTheme: set.textTheme,
      unselectedWidgetColor: set.unselectedWidgetColor,
      dividerColor: set.dividerColor,
      bottomSheetTheme: BottomSheetThemeData(
          shape: RoundedRectangleBorder(
              borderRadius: radiusOnly(
                  topLeft: DEFFAULT_RADIUS, topRight: DEFFAULT_RADIUS)),
          backgroundColor: set.bottomSheetBackgroundColor),
      cardColor: set.cardColor,
      floatingActionButtonTheme:
          FloatingActionButtonThemeData(backgroundColor: set.primaryColor),
      dialogTheme: DialogThemeData(shape: dialogShape(20)),

      navigationBarTheme: NavigationBarThemeData(
          labelTextStyle: WidgetStateProperty.all(
              primaryTextStyle(size: 10, color: set.navigationBarLabelColor)),
          backgroundColor: set.navigationBarBackgroundColor),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return set.unselectedWidgetColor.withValues(alpha: 0.2);
            }
            if (states.contains(WidgetState.selected)) {
              return set.primaryColor;
            }
            return set.primaryColor;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return set.unselectedWidgetColor.withValues(alpha: 0.5);
            }
            if (states.contains(WidgetState.selected)) {
              return Colors.white;
            }
            return Colors.white;
          }),
          textStyle: WidgetStateProperty.all(primaryTextStyle()),
          shape: WidgetStateProperty.all(
              RoundedRectangleBorder(borderRadius: radius(DEFFAULT_RADIUS))),
          padding: WidgetStateProperty.all(const EdgeInsets.symmetric(
              horizontal: DEFFAULT_PADDING, vertical: DEFFAULT_PADDING / 2)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return set.unselectedWidgetColor.withValues(alpha: 0.5);
            }
            if (states.contains(WidgetState.selected)) {
              return Colors.white;
            }
            return Colors.white;
          }),
          textStyle: WidgetStateProperty.all(primaryTextStyle()),
          shape: WidgetStateProperty.all(
              RoundedRectangleBorder(borderRadius: radius(DEFFAULT_RADIUS))),
          padding: WidgetStateProperty.all(const EdgeInsets.symmetric(
              horizontal: DEFFAULT_PADDING, vertical: DEFFAULT_PADDING / 2)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          shape: WidgetStateProperty.all(
              RoundedRectangleBorder(borderRadius: radius(DEFFAULT_RADIUS))),
          side: WidgetStateProperty.all(BorderSide(color: set.primaryColor)),
        ),
      ),
      inputDecorationTheme: inputDecorationTheme(set),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: set.dialogBackgroundColor,
          borderRadius: radius(DEFFAULT_RADIUS),
          boxShadow: [
            BoxShadow(
                color: set.shadowColor..withValues(alpha: 0.5),
                spreadRadius: 5,
                blurRadius: 15,
                offset: const Offset(0, 1)),
          ],
        ),
        // triggerMode: TooltipTriggerMode.tap,
        padding: const EdgeInsets.all(DEFFAULT_PADDING),
        margin:
            const EdgeInsetsDirectional.symmetric(horizontal: DEFFAULT_PADDING),
        textStyle: primaryTextStyle(),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return Colors.grey.withValues(alpha: 0.2);
          }
          if (states.contains(WidgetState.selected)) {
            return set.primaryColor;
          }
          return set.scaffoldColor;
        }),
        checkColor: WidgetStateProperty.all(Colors.white),
        overlayColor: WidgetStateProperty.all(Colors.grey.withValues(alpha: 0.1)),
        splashRadius: 20,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(borderRadius: radius(5)),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
    return themeData;
  }

  static InputDecorationTheme inputDecorationTheme(ThemeSetColor set) {
    // bool isDark = set.brightness == Brightness.dark;
    return InputDecorationTheme(
      fillColor: set.inputFillColor,
      filled: true,
      hintStyle: secondaryTextStyle(),
      labelStyle: primaryTextStyle(),
      contentPadding: const EdgeInsets.symmetric(
          horizontal: DEFFAULT_PADDING, vertical: DEFFAULT_PADDING / 2),
      border: OutlineInputBorder(
        borderRadius: radius(DEFFAULT_RADIUS),
        borderSide: BorderSide(color: set.inputBorderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: radius(DEFFAULT_RADIUS),
        borderSide: BorderSide(color: set.inputBorderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: radius(DEFFAULT_RADIUS),
        borderSide: BorderSide(color: set.inputBorderColor),
      ),
    );
  }
}

class ThemeSetColor {
  final Brightness brightness;
  final Color primaryColor;
  final Color secondaryColor;
  final Color appBarColor;
  final Color appBarTextColor;
  final Color appBarIconColor;
  final Color scaffoldColor;
  String? fontFamily;
  final Color bottomNavigationBarColor;
  final Color bottomNavigationBarIconColor;
  final Color bottomNavigationBarSelectedIconColor;
  final Color bottomNavigationBarSelectedTextColor;
  final Color bottomNavigationBarUnSelectedTextColor;
  final Color iconColor;
  final Color dialogBackgroundColor;
  final Color unselectedWidgetColor;
  final TextTheme textTheme;
  final Color dividerColor;
  final Color bottomSheetBackgroundColor;
  final Color cardColor;
  final Color floatingActionButtonColor;
  final Color navigationBarLabelColor;
  final Color navigationBarUnselectedLabelColor;
  final Color navigationBarBackgroundColor;
  final Color inputFillColor;
  final Color inputBorderColor;
  final Color shadowColor;

  ThemeSetColor({
    this.brightness = Brightness.light,
    required this.primaryColor,
    required this.secondaryColor,
    required this.appBarColor,
    required this.appBarTextColor,
    required this.appBarIconColor,
    required this.scaffoldColor,
    this.fontFamily,
    required this.bottomNavigationBarColor,
    required this.bottomNavigationBarIconColor,
    required this.bottomNavigationBarSelectedIconColor,
    required this.bottomNavigationBarSelectedTextColor,
    required this.bottomNavigationBarUnSelectedTextColor,
    required this.iconColor,
    required this.dialogBackgroundColor,
    required this.unselectedWidgetColor,
    required this.textTheme,
    this.dividerColor = Colors.grey,
    required this.bottomSheetBackgroundColor,
    required this.cardColor,
    required this.floatingActionButtonColor,
    required this.navigationBarLabelColor,
    required this.navigationBarUnselectedLabelColor,
    required this.navigationBarBackgroundColor,
    this.inputFillColor = Colors.white12,
    this.inputBorderColor = Colors.black12,
    this.shadowColor = Colors.grey,
  }) {
    fontFamily = fontFamily ?? GoogleFonts.workSans().fontFamily;
  }
}

/// dark theme set color extends ThemeSetColor
ThemeSetColor get darkThemeSetColor {
  const primaryColor = Color(0xFF2F3D46);
  const appBarColor = Color(0xFF2F3D46);
  const scaffoldColorDark = Color.fromARGB(255, 0, 0, 0);
  const scaffoldSecondaryDark = Color.fromARGB(255, 41, 72, 90);
  const dividerDarkColor = Color.fromARGB(255, 124, 126, 128);
  return ThemeSetColor(
    brightness: Brightness.dark,
    primaryColor: primaryColor,
    secondaryColor: primaryColor.withValues(alpha: 0.1),
    appBarColor: appBarColor,
    appBarTextColor: Colors.white,
    appBarIconColor: Colors.white,
    scaffoldColor: scaffoldColorDark,
    bottomNavigationBarColor: scaffoldSecondaryDark,
    bottomNavigationBarIconColor: Colors.white,
    bottomNavigationBarSelectedIconColor: primaryColor,
    bottomNavigationBarSelectedTextColor: primaryColor,
    bottomNavigationBarUnSelectedTextColor: Colors.white,
    iconColor: Colors.white,
    dialogBackgroundColor: scaffoldSecondaryDark,
    unselectedWidgetColor: Colors.white60,
    textTheme: GoogleFonts.workSansTextTheme().apply(
      bodyColor: Colors.white,
      displayColor: Colors.white,
    ),
    dividerColor: dividerDarkColor,
    bottomSheetBackgroundColor: scaffoldSecondaryDark,
    cardColor: scaffoldSecondaryDark,
    floatingActionButtonColor: primaryColor,
    navigationBarLabelColor: Colors.white,
    navigationBarUnselectedLabelColor: Colors.white60,
    navigationBarBackgroundColor: scaffoldSecondaryDark,
  );
}

TextStyle ts([
  Color? color,
  double? size,
  FontWeight? weight,
  FontStyle? style,
  double? letterSpacing,
  double? wordSpacing,
  TextDecoration? decoration,
  Color? decorationColor,
  TextDecorationStyle? decorationStyle,
  double? height,
  TextBaseline? textBaseline,
]) =>
    TextStyle(
      color: color,
      fontSize: size,
      fontWeight: weight,
      fontStyle: style,
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationStyle: decorationStyle,
      height: height,
      textBaseline: textBaseline,
    );

ThemeSetColor get lightThemeSetColor {
  // const primaryColor = Color(0xFF2962FF);
  const primaryColor = Color(0xFF5BA704);

  ///website color
  // const primaryColor = Color(0xFF1701AB);
  // const primaryColor = Color.fromARGB(255, 29, 24, 60);

  return ThemeSetColor(
      brightness: Brightness.light,
      primaryColor: primaryColor,
      secondaryColor: primaryColor.withValues(alpha: 0.1),
      appBarColor: primaryColor,
      appBarTextColor: Colors.white,
      appBarIconColor: Colors.white,
      scaffoldColor: Colors.white,
      bottomNavigationBarColor: Colors.white,
      bottomNavigationBarIconColor: Colors.black,
      bottomNavigationBarSelectedIconColor: primaryColor,
      bottomNavigationBarSelectedTextColor: primaryColor,
      bottomNavigationBarUnSelectedTextColor: Colors.black,
      iconColor: Colors.black,
      dialogBackgroundColor: Colors.white,
      unselectedWidgetColor: Colors.black54,
      textTheme: GoogleFonts.poppinsTextTheme(),
      dividerColor: dividerDarkColor,
      bottomSheetBackgroundColor: Colors.white,
      cardColor: Colors.white,
      floatingActionButtonColor: primaryColor,
      navigationBarLabelColor: Colors.black,
      navigationBarUnselectedLabelColor: Colors.black54,navigationBarBackgroundColor: Colors.white);
}


