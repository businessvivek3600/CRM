import 'package:crm/constants/app_constants.dart';
import 'package:crm/features/auth/auth/auth_screen.dart';
import 'package:crm/store/app_store.dart';
import 'package:crm/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:workmanager/workmanager.dart';

import 'constants/value_constants.dart';
import 'database/dio/dio/dio_client.dart';
import 'database/dio/dio/loging_interceotor.dart';
import 'database/routes/route_settings.dart';
import 'features/auth/dashboard/home_screen.dart';
import 'utils/default_logger.dart';
import 'widgets/loader_widget.dart';

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    WidgetsFlutterBinding.ensureInitialized();
    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    final userId = inputData?['id'];
    final latitude = position.latitude;
    final longitude = position.longitude;
    logger.d("Location fetched: $latitude, $longitude for user: $userId");
    await hitApiWithLocation(userId, latitude, longitude);
    return Future.value(true);
  });
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Workmanager().initialize(callbackDispatcher);
  await initialize();
  await setupAppStore();
  await initializeUserDataInMain();
  requestLocationPermission();
  await initNbUtils().then((value) async => await initialize());
  runApp(const MyApp());
}

Future<void> initialize() async {
  sharedPreferences = await SharedPreferences.getInstance();
  await appStore.setToken(getStringAsync(TOKEN), isInitializing: true);
}

Future<void> initializeUserDataInMain() async {
  // Renamed this function
  WidgetsFlutterBinding.ensureInitialized();
  try {
    var token = getStringAsync(TOKEN);
    dioClient = DioClient(
        loggingInterceptor: LoggingInterceptor(), baseUrl: AppConst.baseUrl);
  } catch (e) {
    logger.e('initializeUserData: -------------------------- $e');
  }
}

Future<void> setupAppStore() async {
  ///check for login
  await appStore.setLoggedIn(getBoolAsync(IS_LOGGED_IN), isInitializing: true);
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

Future<void> requestLocationPermission() async {
  LocationPermission permission;

  // Check current permission status
  permission = await Geolocator.checkPermission();

  if (permission == LocationPermission.denied) {
    // Request location permission
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      print('Location permissions are denied.');
      return;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Notify the user about permanently denied permissions
    print('Location permissions are permanently denied.');
    return;
  }

  if (permission == LocationPermission.whileInUse) {
    // Upgrade to always permission
    permission = await Geolocator.requestPermission();
    if (permission != LocationPermission.always) {
      print('Failed to get "always" location permission.');
      return;
    }
  }

  if (permission == LocationPermission.always) {
    print('Location permission granted: Always');
  }
}

// Future<void> setupAppStore() async {
//   ///check for login
//   await appStore.setLoggedIn(getBoolAsync(IS_LOGGED_IN), isInitializing: true);

// }
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GoRouter _goRouter = goRouter;
  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => MaterialApp(
        debugShowCheckedModeBanner: false,
        // routerConfig: _goRouter,
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
        title: AppConst.appName,
        home: appStore.isLoggedIn ? const HomeScreen() : const AuthScreen(),
        builder: (context, child) {
          return LoadingWidget(
            context: context,
            goRouter: _goRouter,
            child: child!,
          );
        },
      ),
    );
  }
}
