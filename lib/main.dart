import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart'; // Location package
import 'package:workmanager/workmanager.dart'; // Add this import
import 'package:wealthyfy/background_task.dart'; // Add this import
import 'APIs/user_data.dart';
import 'Routes/AppPages.dart';
import 'Routes/AppRoutes.dart';
import 'helper/colors.dart';
import 'helper/textview.dart';
import 'screens/splash.dart';
import 'firebase_options.dart';
import 'dart:io';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  if (kIsWeb) {
    runApp(const MyApp());
    return;
  }

  if (!kIsWeb) {
    // Initialize Workmanager (not supported on web)
    Workmanager().initialize(
      callbackDispatcher,
    );
  }

  if (!kIsWeb) {
    try {
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        final bool isApplePlatform =
            defaultTargetPlatform == TargetPlatform.iOS ||
                defaultTargetPlatform == TargetPlatform.macOS;
        if (isApplePlatform) {
          String? token = await FirebaseMessaging.instance.getAPNSToken();
          print("APNs Token: $token");
        }
      } else {
        print('User declined or has not accepted notification permissions.');
      }
    } catch (e) {
      // Avoid startup crash on unsupported platforms.
      print('Firebase Messaging init skipped: $e');
    }
  }
  // Enables full screen layout
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FirebaseMessaging? _firebaseMessaging;

  @override
  void initState() {
    super.initState();
    onInit();
  }

  void onInit() {
    if (kIsWeb) {
      return;
    }
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Message received in foreground: ${message.notification?.title}");
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("Message opened from background: ${message.notification?.title}");
    });

    checkForInitialMessage() async {
      RemoteMessage? initialMessage =
          await FirebaseMessaging.instance.getInitialMessage();
      if (initialMessage != null) {
        print(
            "Message received on app launch: ${initialMessage.notification?.title}");
      }
    }

    _firebaseMessaging = FirebaseMessaging.instance;
    _firebaseMessaging!.getToken().then((value) {
      print("check value is same $value");
      _firebaseMessaging!.subscribeToTopic("topics");
      FirebaseMessaging.onMessage.listen((event) async {
        NotificationSettings settings =
            await _firebaseMessaging!.requestPermission(
          alert: true,
          badge: true,
          provisional: false,
          sound: true,
        );
        if (settings.authorizationStatus == AuthorizationStatus.authorized) {
          checkForInitialMessage();
        }
      });
    });
  }

  void checkForInitialMessage() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      PushNotification(
        title: initialMessage.notification?.title,
        body: initialMessage.notification?.body,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wealthyfy',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
            backgroundColor: ColorConstants.DarkMahroon,
            titleTextStyle: TextStyle(
                color: ColorConstants.APPTIRLE,
                fontSize: 20,
                fontWeight: FontWeight.bold),
            iconTheme: const IconThemeData(color: ColorConstants.WHITECOLOR)),
        colorScheme: ColorScheme.fromSeed(seedColor: ColorConstants.WHITECOLOR),
        useMaterial3: true,
      ),
      initialRoute: Routes.WELCOME,
      navigatorKey: navigatorKey,
      builder: EasyLoading.init(),
      getPages: AppPages.routes,
      //  home: TeamLisView(),
    );
  }
}

class WelcomeStateController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _checkLocationPermission();
    configLoading();
  }

  void configLoading() {
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 2000)
      ..indicatorType = EasyLoadingIndicatorType.fadingCube
      ..loadingStyle = EasyLoadingStyle.custom
      ..indicatorSize = 45.0
      ..radius = 10.0
      ..progressColor = Color(0xFF5d0c1d)
      ..backgroundColor = Colors.white
      ..indicatorColor = Color(0xFF5d0c1d)
      ..textColor = Colors.yellow
      ..maskColor = Colors.blue.withValues(alpha: 0.5)
      ..userInteractions = true
      ..dismissOnTap = false
      ..customAnimation = CustomAnimation();
  }

  /// Check and request location permission
  Future<void> _checkLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showServiceDisabledDialog();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      await _requestPermission();
    } else {
      _navigateToApp();
    }
  }

  Future<void> _requestPermission() async {
    if (Platform.isIOS) {
      // On iOS, only request permission once.
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showPermissionDeniedDialog();
      } else if (permission == LocationPermission.deniedForever) {
        _showSettingsDialog();
      } else {
        _navigateToApp();
      }
    } else {
      // On other platforms (e.g., Android), keep the original logic.
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.whileInUse) {
        // Try to upgrade to "always" for background tasks.
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied) {
        _showPermissionDeniedDialog();
      } else if (permission == LocationPermission.deniedForever) {
        _showSettingsDialog();
      } else {
        _navigateToApp();
      }
    }
  }

  void _showPermissionDeniedDialog() {
    Get.dialog(
      AlertDialog(
        title: Text("Location Required"),
        content: Text("This app requires location access to continue."),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
              _requestPermission(); // Re-request permission
            },
            child: Text("Grant Permission"),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  void _showSettingsDialog() {
    Get.dialog(
      AlertDialog(
        title: Text("Location Permanently Denied"),
        content: Text("Please enable location permissions from settings."),
        actions: [
          TextButton(
            onPressed: () {
              Geolocator.openAppSettings();
            },
            child: Text("Open Settings"),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  void _showServiceDisabledDialog() {
    Get.dialog(
      AlertDialog(
        title: Text("Location Services Disabled"),
        content: Text("Please enable location services to continue."),
        actions: [
          TextButton(
            onPressed: () async {
              await Geolocator.openLocationSettings();
              _checkLocationPermission();
            },
            child: Text("Enable Location"),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  void _navigateToApp() {
    Future.delayed(const Duration(seconds: 2), () {
      getLoginModelDetail().then((value) {
        if (value == null) {
          Get.off(() => const SplashScreen());
        } else {
          Get.offAllNamed(Routes.DASHBOARD);
        }
      });
    });
  }
}

class WelcomeState extends GetView<WelcomeStateController> {
  const WelcomeState({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
            child: headingText(
          title: 'WEALTHYFY',
          fontSize: 30,
          color: ColorConstants.DarkMahroon,
          fontWeight: FontWeight.bold,
        )),
      );
}

class PushNotification {
  PushNotification({
    this.title,
    this.body,
  });
  String? title;
  String? body;
}

class CustomAnimation extends EasyLoadingAnimation {
  CustomAnimation();

  @override
  Widget buildWidget(
    Widget child,
    AnimationController controller,
    AlignmentGeometry alignment,
  ) {
    return Opacity(
      opacity: controller.value,
      child: RotationTransition(
        turns: controller,
        child: child,
      ),
    );
  }
}
