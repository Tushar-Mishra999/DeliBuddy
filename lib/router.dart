import 'package:delibuddy/views/auth/email_verification.dart';
import 'package:delibuddy/views/home/home_screen.dart';
import 'package:delibuddy/views/auth/login_screen.dart';
import 'package:delibuddy/views/auth/registration_screen.dart';
import 'package:delibuddy/views/order_description.dart';
import 'package:delibuddy/views/order_request/order_request.dart';
import 'package:flutter/material.dart';


Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case LoginScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => LoginScreen(),
      );
    case RegistrationScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => RegistrationScreen(),
      );
    case HomeScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const HomeScreen(),
      );
    case OrderRequest.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const OrderRequest(),
      );
    case EmailVerification.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => EmailVerification(),
      );
     case OrderDescription.routeName:
     Map<String, dynamic> arguments =
          routeSettings.arguments as Map<String, dynamic>;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => OrderDescription(shopName: arguments['shopName'],),
      );
    default:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const Scaffold(
          body: Center(
            child: Text('Screen does not exist!'),
          ),
        ),
      );
  }
}