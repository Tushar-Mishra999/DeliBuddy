import 'package:delibuddy/components/search_bar.dart';
import 'package:delibuddy/components/shop.dart';
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
        body: SafeArea(
      child: Center(
          child: Column(
        children: [
          SizedBox(
            height: size.height * 0.1,
          ),
          RoundedSearchBar(
            hintText: "Search what you need",
            onSubmitted: (value) {},
          ),
          SizedBox(
            height: size.height * 0.06,
          ),
          Column(
            children: [
              Shop(size: size),
              Shop(size: size),
              Shop(size: size),
              Shop(size: size),
              Shop(size: size),
            ],
          )
        ],
      )),
    ));
  }
}
