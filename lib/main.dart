import 'package:delibuddy/firstscreen.dart';
import 'package:delibuddy/router.dart';
import 'package:delibuddy/views/auth/email_verification.dart';
import 'package:delibuddy/views/auth/login_screen.dart';
import 'package:delibuddy/views/chat/chat_screen.dart';
import 'package:delibuddy/views/home/home_screen.dart';
import 'package:delibuddy/views/onboarding_screen.dart';
import 'package:delibuddy/views/order/order_place.dart';
import 'package:delibuddy/views/detail/order_detail.dart';
import 'package:delibuddy/views/order_request/order_request.dart';
import 'package:delibuddy/views/profile/profile_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DeliBuddy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      onGenerateRoute: (settings) => generateRoute(settings),
      home: FirstScreen(),
    );
  }
}
