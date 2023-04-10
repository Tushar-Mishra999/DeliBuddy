import 'package:delibuddy/router.dart';
import 'package:delibuddy/views/chat/chat_screen.dart';
import 'package:delibuddy/views/home/home_screen.dart';
import 'package:delibuddy/views/onboarding_screen.dart';
import 'package:delibuddy/views/order_place.dart';
import 'package:delibuddy/views/detail/order_detail.dart';
import 'package:delibuddy/views/order_request/order_request.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoggedIn = false;
  String _type = 'client';
  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  void checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    String type = prefs.getString('type') ?? 'client';
    setState(() {
      _isLoggedIn = isLoggedIn;
      _type = type;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DeliBuddy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      onGenerateRoute: (settings) => generateRoute(settings),
      //home: const OnboardingScreen(),
      home: _isLoggedIn ? _type=='client'?const HomeScreen():const OrderRequest() : const OnboardingScreen(),
    );
  }
}
