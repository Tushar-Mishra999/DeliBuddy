import 'dart:async';

import 'package:delibuddy/constants.dart';
import 'package:delibuddy/views/chat/chat_screen.dart';
import 'package:delibuddy/views/home/home_screen.dart';
import 'package:delibuddy/views/onboarding_screen.dart';
import 'package:delibuddy/views/order_request/order_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  Timer? _timer;
  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  void checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    bool isChat = prefs.getBool('isChat') ?? false;
    String type = prefs.getString('type') ?? 'client';
    _timer = Timer(const Duration(seconds: 1), () {
      if (isLoggedIn) {
        if(isChat){
           Navigator.pushNamedAndRemoveUntil(
              context, ChatScreen.routeName, (route) => false);
        }
        else if (type == 'client') {
          Navigator.pushNamedAndRemoveUntil(
              context, HomeScreen.routeName, (route) => false);
        } else {
          Navigator.pushNamedAndRemoveUntil(
              context, OrderRequest.routeName, (route) => false);
        }
      } else {
        Navigator.pushNamedAndRemoveUntil(
            context, OnboardingScreen.routeName, (route) => false);
      }
    });
  }

  @override
  void dispose() {
    _timer!.cancel(); // cancel the timer to avoid memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: bgcolor,
      body: Center(
          child: CircularProgressIndicator(
        color: Colors.orange,
      )),
    );
  }
}
