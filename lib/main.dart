// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newsfeedapp/views/login_page.dart';
import 'package:newsfeedapp/views/news_feed_page.dart';
import 'package:newsfeedapp/views/theme.dart';

import 'controller/auth_controller.dart';
import 'controller/theme_controll.dart';
import 'firebase_options.dart';

Future<void> _initializeFirebaseMessaging() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // Request permissions for notifications
  await messaging.requestPermission();

  // Get the token for the device
  String? token = await messaging.getToken();
  print("FCM Token: $token");
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Handle background messages here
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final ThemeController themeController = Get.put(ThemeController());
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await _initializeFirebaseMessaging();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ThemeController _themeController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Obx(() => GetMaterialApp(
      title: 'News Feed App',
      theme: _themeController.themeData,
      home: NewsFeedView(),
    ));
  }
}

class AuthStateHandler extends StatelessWidget {
  final authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasData) {
          return NewsFeedView();
        } else {
          return LoginPage();
        }
      },
    );
  }
}
