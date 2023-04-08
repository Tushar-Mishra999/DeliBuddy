import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants.dart';

class Shop extends StatelessWidget {
  const Shop({
    Key? key,
    required this.size,
    required this.name,
  }) : super(key: key);

  final Size size;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15),
      width: size.width * 0.8,
      height: size.height * 0.08,
      decoration: BoxDecoration(
          border: Border.all(color: color1, width: 2),
          color: color2,
          borderRadius: BorderRadius.circular(10)),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              name,
              style: GoogleFonts.sourceSansPro(
                  fontSize: 20, color: bgcolor, fontWeight: FontWeight.w500),
            ),
            Text(
              'OPEN',
              style: GoogleFonts.sourceSansPro(
                  fontSize: 20,
                  color: Colors.green,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
