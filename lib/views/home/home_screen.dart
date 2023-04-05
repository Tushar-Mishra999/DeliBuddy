import 'package:delibuddy/components/search_bar.dart';
import 'package:delibuddy/views/home/shop.dart';
import 'package:delibuddy/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/homescreen';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: bgcolor,
        body: SafeArea(
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Shop(size: size),
              Shop(size: size),
              Shop(size: size),
              Shop(size: size),
              Shop(size: size),
            ],
          )),
        ));
  }
}
