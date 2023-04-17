import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delibuddy/constants.dart';
import 'package:delibuddy/views/order/order_place.dart';
import 'package:delibuddy/views/chat/chat_screen.dart';
import 'package:delibuddy/views/home/home_screen.dart';
import 'package:delibuddy/views/onboarding_screen.dart';
import 'package:delibuddy/views/order_request/order_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
      bool isChat = false;
      bool isOrder = false;
      String type = prefs.getString('type') ?? 'client';
      String name = prefs.getString('name') ?? '';
      String searchCategory = type == 'client' ? 'name' : 'deliveryName';
      final QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('orders')
              .where('status', isEqualTo: 'accepted')
              .where(searchCategory, isEqualTo: name)
              .limit(1)
              .get();

      if (querySnapshot.docs.isNotEmpty) {
        isChat = true;
      }

      _timer = Timer(const Duration(seconds: 1), () {
        if (isLoggedIn) {
          if (isChat) {
            Navigator.pushNamedAndRemoveUntil(
                context, ChatScreen.routeName, (route) => false);
          } else if (type == 'client') {
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
    } catch (e) {
      Fluttertoast.showToast(
          msg: 'Something went wrong, please try again',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: color2,
          textColor: Colors.white);
    }
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
