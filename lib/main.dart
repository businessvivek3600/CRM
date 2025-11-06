import 'package:crm/constants/app_constants.dart';
import 'package:crm/features/auth/auth/auth_screen.dart';
import 'package:crm/services/notification_service.dart';
import 'package:crm/store/app_store.dart';
import 'package:crm/utils/colors.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:upgrader/upgrader.dart';
import 'package:workmanager/workmanager.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'constants/value_constants.dart';
import 'database/dio/dio/dio_client.dart';
import 'database/dio/dio/loging_interceotor.dart';
import 'database/routes/route_settings.dart';
import 'features/auth/dashboard/home_screen.dart';
import 'utils/default_logger.dart';
import 'widgets/loader_widget.dart';


@pragma('vm:entry-point')
Future<void> _onBackgroundMessage(RemoteMessage message) async {
  logger.d('onBackgroundMessage: ${message.notification?.title}');
  NotificationService.showNotification(message);
}
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
Future<void> openAppSettingsForLocationPermission() async {
  bool opened = await Geolocator.openAppSettings();
  if (!opened) {
    print('Failed to open app settings.');
  }
}
final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Workmanager().initialize(callbackDispatcher);
  await initialize();
  await setupAppStore();
  await initializeUserDataInMain();
  await requestLocationPermission();
  await initNbUtils().then((value) async => await initialize());
  await getFbToken();
  runApp(const MyApp());
}

Future<void> initialize() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_onBackgroundMessage);
  FirebaseMessaging.onMessage.listen(NotificationService.onMessage);
  FirebaseMessaging.onMessageOpenedApp
      .listen(NotificationService.onMessageOpenedApp);
  NotificationService.instance.initialize();
  sharedPreferences = await SharedPreferences.getInstance();
  await appStore.setToken(getStringAsync(TOKEN), isInitializing: true);
  // Print the device token for debugging
}
Future<String?> getFbToken() async {
  try {
    String? token = defaultTargetPlatform == TargetPlatform.iOS
        ? await firebaseMessaging.getAPNSToken()
        : await firebaseMessaging.getToken();
    debugPrint('FirebaseMessaging token -----: $token');
    return token;
  } catch (e) {
    debugPrint('Error getting FirebaseMessaging token: $e');
    return null;
  }
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
  LocationPermission permission = await Geolocator.checkPermission();

  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      warningLog('Location permissions are denied.');
      return;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    warningLog('Location permissions are permanently denied. Please enable it in Settings.');
    await openAppSettingsForLocationPermission();
    return;
  }

  if (permission == LocationPermission.whileInUse) {
    warningLog('While in use location permission granted.');
    // Notify the user to go to Settings and grant "Always Allow" permission
    warningLog('Please upgrade to "Always Allow" in Settings.');
  }

  if (permission == LocationPermission.always) {
    warningLog('Location permission granted: Always');
  }
}



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
        home: UpgradeAlert(
          upgrader: Upgrader(
            // Automatically detect the Play Store version
            countryCode: 'in', // optional; helps if your app is only in India
            durationUntilAlertAgain: const Duration(days: 1),

            // Enable logging to debug upgrade behavior
            debugLogging: kDebugMode,

            // Optional customization
            messages: UpgraderMessages(
              code:
                  'A new version of the app is available. Please update to continue enjoying the latest features and improvements.',
            ),

          ),
          child: appStore.isLoggedIn
              ? const HomeScreen()
              : const AuthScreen(),
        ),
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
