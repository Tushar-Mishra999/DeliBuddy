import 'package:delibuddy/views/order_description.dart';
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
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, OrderDescription.routeName,arguments: {
          'shopName':name,
        });
      },
      child: Container(
        margin: const EdgeInsets.all(15),
        padding: const EdgeInsets.all(20),
        width: size.width * 0.8,
        height: size.height * 0.08,
        decoration: BoxDecoration(
            color: color2, borderRadius: BorderRadius.circular(10)),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: GoogleFonts.sourceSansPro(
                    fontSize: 20, color: bgcolor, fontWeight: FontWeight.w800),
              ),
              Text(
                'OPEN',
                style: GoogleFonts.sourceSansPro(
                    fontSize: 20, color: bgcolor, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
