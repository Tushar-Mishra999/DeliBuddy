import 'package:delibuddy/version_update.dart';
import 'package:delibuddy/views/order/referral_screen.dart';
import 'package:delibuddy/views/auth/email_verification.dart';
import 'package:delibuddy/views/chat/chat_screen.dart';
import 'package:delibuddy/views/detail/order_detail.dart';
import 'package:delibuddy/views/home/home_screen.dart';
import 'package:delibuddy/views/auth/login_screen.dart';
import 'package:delibuddy/views/auth/registration_screen.dart';
import 'package:delibuddy/views/onboarding_screen.dart';
import 'package:delibuddy/views/order/order_place.dart';
import 'package:delibuddy/views/order_request/order_request.dart';
import 'package:delibuddy/views/profile/profile_screen.dart';
import 'package:delibuddy/views/settings/setting_screen.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case OnboardingScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => OnboardingScreen(),
      );
    case ProfileScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const ProfileScreen(),
      );
    case ReferralScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const ReferralScreen(),
      );
    case LoginScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => LoginScreen(),
      );
    case RegistrationScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const RegistrationScreen(),
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
        builder: (_) => const EmailVerification(),
      );
    case OrderDescription.routeName:
      Map<String, dynamic> arguments =
          routeSettings.arguments as Map<String, dynamic>;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => OrderDescription(
          shopName: arguments['shopName'],
        ),
      );
    case VersionUpdate.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => VersionUpdate(
        ),
      );
    case ChatScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const ChatScreen(
            ),
      );
    case SettingScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const SettingScreen(
            ),
      );
    case OrderDetail.routeName:
      Map<String, dynamic> arguments =
          routeSettings.arguments as Map<String, dynamic>;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => OrderDetail(
          chatRoomId: arguments['chatRoomId'],
          address:arguments['address'],
          deliveryName: arguments['deliveryName'],
          otp: arguments['otp'],
          description: arguments['description'],
          type: arguments['type'],
        ),
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
