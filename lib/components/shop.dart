import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants.dart';

class Shop extends StatelessWidget {
  const Shop({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15),
      width: size.width * 0.8,
      height: size.height * 0.06,
      decoration: BoxDecoration(
          border: Border.all(color: color1, width: 3),
          borderRadius: BorderRadius.circular(10)),
      child: Center(
        child: Text(
          "Mahesh Restro Bar",
          style: GoogleFonts.sourceSansPro(
              fontSize: 20, color: Colors.black, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
