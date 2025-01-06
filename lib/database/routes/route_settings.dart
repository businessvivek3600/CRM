import 'package:crm/Models/leads_model.dart';
import 'package:crm/constants/value_constants.dart';
import 'package:crm/features/auth/auth/auth_screen.dart';
import 'package:crm/features/auth/dashboard/customer/add_customer.dart';
import 'package:crm/features/auth/dashboard/customer/customer_Screen.dart';
import 'package:crm/features/auth/dashboard/leads/addleads.dart';
import 'package:crm/features/auth/dashboard/leads/leads_details.dart';
import 'package:crm/features/auth/dashboard/leads/leads_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:flutter/foundation.dart';

import '../../features/auth/dashboard/home_screen.dart';
import '../../services/auth_services.dart';
import '../../store/app_store.dart';
import '../../utils/default_logger.dart';
import 'route_name.dart';
import 'route_path.dart';

final GoRouter goRouter = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: Paths.dashboard,
    redirect: _redirect,
    routes: <RouteBase>[
  // GoRoute(
  //   path: Paths.splash,
  //   name: Routes.splash,
  //   pageBuilder: (context, state) =>
  //       animatedRoute(state, (state) => const SplashScreen()),
  // ),

  GoRoute(
    path: Paths.dashboard,
    name: Routes.dashboard,
    pageBuilder: (context, state) =>
        animatedRoute(state, (state) => const HomeScreen()),
    onExit: (context, state) async {
      pl('onExit: ${context.widget.runtimeType} from dashboard canAskForExitApp: ${appStore.canAskForExitApp}');
      if (!appStore.canAskForExitApp) return true;
      final bool? confirmed = await showDialog<bool>(
          context: context, builder: (_) => const ExitPermissionDialog());
      return confirmed ?? false;
    },
  ),
 GoRoute(
  path: Paths.login,
  name: Routes.login,
  pageBuilder: (context, state) =>
      animatedRoute(state, (state) => const AuthScreen()),
),
  GoRoute(
    path: Paths.lead,
    name: Routes.lead,
    pageBuilder: (context, state) =>
        animatedRoute(state, (state) => const LeadsScreen()),
  ),
  // GoRoute(
  //   path: Paths.leadDetails,
  //   name: Routes.leadDetails,
  //   pageBuilder: (context, state) =>
  //       animatedRoute(state, (state) =>  LeadDetails(lead: Lead.t ,)),
  // ),
  GoRoute(
    path: Paths.addLead,
    name: Routes.addLead,
    pageBuilder: (context, state) =>
        animatedRoute(state, (state) => const Addleads()),
  ),
  GoRoute(
    path: Paths.customer,
    name: Routes.customer,
    pageBuilder: (context, state) =>
        animatedRoute(state, (state) => const CustomerScreen()),
  ),
  GoRoute(
    path: Paths.customerDetails,
    name: Routes.customerDetails,
    pageBuilder: (context, state) =>
        animatedRoute(state, (state) => const AuthScreen()),
  ),
  GoRoute(
    path: Paths.addCustomer,
    name: Routes.addCustomer,
    pageBuilder: (context, state) =>
        animatedRoute(state, (state) => const AddCustomer()),
  ),
]);

Page animatedRoute(
    GoRouterState state, Widget Function(GoRouterState state) child,
    {RouteTransition? transition}) {
  String? anim = state.uri.queryParameters['anim'] ??
      (state.extra is Map && (state.extra as Map).containsKey('anim')
          ? (state.extra as Map)['anim']
          : null);

  if ((defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.android) &&
      anim == null) {
    return CupertinoPage(
      child: child(state),
      key: state.pageKey,
      title: state.matchedLocation.split('-').last.capitalizeEachWord(),
      arguments: state.extra,
    );
  }

  // Add a fallback return statement for non-iOS/Android platforms or when `anim` is specified.
  return MaterialPage(
    child: child(state),
    key: state.pageKey,
    name: state.matchedLocation.split('-').last.capitalizeEachWord(),
    arguments: state.extra,
  );
}
Future<bool> checkLogin() async {
  await appStore.setLoggedIn(getBoolAsync(IS_LOGGED_IN));
  return appStore.isLoggedIn;
}


Future<String?> _redirect(BuildContext context, GoRouterState state) async {
  infoLog('Redirecting to ${state.matchedLocation}');
  infoLog('isLoggedIn: ${appStore.isLoggedIn}');
  bool loggedIn = await checkLogin();
  if (state.matchedLocation == Paths.login) return null;

  // Redirect logic
  if (loggedIn) {
    return Paths.dashboard; // Redirect to dashboard if logged in
  } else {
    return Paths.login;
  }
}


enum RouteTransition {
  slide,
  fromTop,
  fromBottom,
  fomRight,
  topLeft,
  topRight,
  bottomLeft,
  bottomRight,
  fade,
  scale,
  fromLeft,
}

class ExitPermissionDialog extends StatelessWidget {
  const ExitPermissionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(
            top: 30,
            bottom: 16,
            left: 16,
            right: 16,
          ),
          margin: const EdgeInsets.only(top: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                context.theme.primaryColor,
                context.theme.primaryColor,
                Colors.white,
              ],
              stops: const [0.0, 0.3, 1.0],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: Offset(0.0, 10.0),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                'Are you sure you want to exit the dashboard?',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16.0, color: Colors.white),
              ),
              const SizedBox(height: 24.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  FilledButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsetsDirectional.symmetric(
                          horizontal: 25.0, vertical: 5.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                    ),
                    child: const Text('Yes',
                        style: TextStyle(fontSize: 16.0, color: Colors.white)),
                  ),
                  FilledButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsetsDirectional.symmetric(
                          horizontal: 30.0, vertical: 5.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      backgroundColor: Colors.white,
                    ),
                    child: Text(
                      'No',
                      style: TextStyle(
                          fontSize: 16.0, color: context.theme.primaryColor),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .pop(false); // Dismiss the dialog and return false
            },
            child: const CircleAvatar(
              radius: 20,
              backgroundColor: Colors.red,
              child: Icon(
                Icons.close,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
