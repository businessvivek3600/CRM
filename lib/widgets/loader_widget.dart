import 'package:crm/widgets/spin_kit_chasing_dots.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

import '../constants/value_constants.dart';
import '../database/routes/route_path.dart';
import '../features/auth/auth/auth_screen.dart';
import '../services/auth_services.dart';
import '../store/app_store.dart';
import '../utils/default_logger.dart';
// Import the AuthScreen

class LoaderWidget extends StatefulWidget {
  const LoaderWidget({super.key});

  @override
  _LoaderWidgetState createState() => _LoaderWidgetState();
}

class _LoaderWidgetState extends State<LoaderWidget>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000))
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SpinKitChasingDots(color: Colors.white);
  }
}

class LoadingWidget extends StatelessWidget {
  const LoadingWidget(
      {required this.child,
        super.key,
        required this.context,
        required this.goRouter});
  final BuildContext context;
  final Widget child;
  final GoRouter goRouter;


  @override
  Widget build(BuildContext context) => Material(
    child: Stack(
      children: [
        ResponsiveBreakpoints.builder(
          breakpoints: [
            const Breakpoint(start: 0, end: 450, name: MOBILE),
            const Breakpoint(start: 451, end: 800, name: TABLET),
            const Breakpoint(start: 801, end: 1920, name: DESKTOP),
            const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
          ],
          // child: ToastificationConfigProvider(
          //     config: const ToastificationConfig(
          //       margin: EdgeInsets.fromLTRB(0, 16, 0, 110),
          //       alignment: Alignment.center,
          //       itemWidth: 440,
          //       animationDuration: Duration(milliseconds: 500),
          //     ),
          child: child,
          // ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Observer(builder: (context) {
            if (appStore.isSessionExpired) {
              return _SessionExpiredWidget(goRouter: goRouter);
            } else {
              return Container();
            }
          }),
        ),
        Observer(
          builder: (_) => Visibility(
              visible: appStore.isLoading,
              child: AnimatedContainer(
                  duration: 500.milliseconds,
                  color: Colors.black.withOpacity(0.1),
                  child: Center(
                      child: SpinKitChasingDots(
                        color:  Colors.white

                      )))),
        ),
      ],
    ).onTap(
      isMacOS || isWeb || isWindows || isLinux
          ? null
          : () {
        // if (defaultTargetPlatform == TargetPlatform.android) {
        //   SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
        //     // SystemUiOverlay.bottom,
        //     SystemUiOverlay.top,
        //   ]);
        //   SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        //     statusBarColor: Colors.transparent, // Status bar color
        //     systemNavigationBarColor: Colors.transparent,
        //     systemNavigationBarContrastEnforced: true,
        //   ));
        // }
        hideKeyboard(context);
      },
    ),
  );
}

class _SessionExpiredWidget extends StatefulWidget {
  const _SessionExpiredWidget({super.key, required this.goRouter});

  final GoRouter goRouter;

  @override
  State<_SessionExpiredWidget> createState() => _SessionExpiredWidgetState();
}

class _SessionExpiredWidgetState extends State<_SessionExpiredWidget> {
  @override
  void initState() {
    super.initState();
    AuthService().logout().then((value) {
      pl('running loggout... ');
      1.seconds.delay.then((value) => widget.goRouter.go(Paths.login))
      .then((value) => appStore.setSessionExpired(false))
          ;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.red.shade300,
            Colors.red.shade400,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const SizedBox(
                height: 15,
                width: 15,
                child: CircularProgressIndicator.adaptive(
                  strokeWidth: 1,
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
              ).paddingRight(DEFFAULT_PADDING / 2),
              RichText(
                text: TextSpan(
                  text: 'Your session has expired. ',
                  style: context.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500, color: Colors.white),
                  children: <TextSpan>[
                    TextSpan(
                        text: 'Login',
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            appStore.setSessionExpired(false);
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const AuthScreen()));
                          },
                        style: context.textTheme.bodyMedium?.copyWith(
                            color: const Color.fromARGB(255, 214, 249, 250),
                            fontWeight: FontWeight.bold)),
                    const TextSpan(text: ' to continue.'),
                  ],
                ),
              ).expand(),
            ],
          ),
        ],
      ),
    );
  }
}
