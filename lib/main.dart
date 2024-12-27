import 'package:crm/constants/app_constants.dart';
import 'package:crm/features/auth/auth/auth_screen.dart';
import 'package:crm/store/app_store.dart';
import 'package:crm/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'constants/value_constants.dart';
import 'database/dio/dio/dio_client.dart';
import 'database/dio/dio/loging_interceotor.dart';
import 'services/theme_service.dart';
import 'utils/default_logger.dart';

Future<void>  main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await initialize();
  await setupAppStore();
  await initializeUserData();
  await initNbUtils().then((value) async => await initialize());
  runApp(const MyApp());
}

Future<void> initialize() async {
  sharedPreferences = await SharedPreferences.getInstance();
}
Future<void> initializeUserData() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    var token = getStringAsync(TOKEN);
    dioClient = DioClient(
        loggingInterceptor: LoggingInterceptor(), baseUrl: AppConst.baseUrl);
  }catch (e) {
    logger.e('initializeUserData: -------------------------- $e');
  }
}
Future<void> initNbUtils() async {
  passwordLengthGlobal = 6;
  appButtonBackgroundColorGlobal = Colors.blueGrey;
  defaultAppButtonTextColorGlobal = Colors.white;
  defaultBlurRadius = 0;
  defaultSpreadRadius = 0;
  textSecondaryColorGlobal = Colors.grey;
  textPrimaryColorGlobal = Colors.black;
  defaultAppButtonElevation = 0;
  pageRouteTransitionDurationGlobal = 400.milliseconds;
  textBoldSizeGlobal = 14;
  textPrimarySizeGlobal = 14;
  textSecondarySizeGlobal = 12;
}

Future<void> setupAppStore() async {
  ///check for login
  await appStore.setLoggedIn(getBoolAsync(IS_LOGGED_IN), isInitializing: true);

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
        home: AuthScreen());
  }
}
