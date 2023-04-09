import 'package:delibuddy/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RequestCard extends StatelessWidget {
  const RequestCard(
      {Key? key,
      required this.size,
      required this.name,
      required this.price,
      required this.description,
      required this.email})
      : super(key: key);

  final Size size;
  final String name;
  final String price;
  final String description;
  final String email;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          BoxDecoration(color: color2, borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.all(10),
      height: size.height * 0.2,
      width: size.width * 0.8,
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 12, right: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: GoogleFonts.sourceSansPro(
                    color: bgcolor, fontSize: 24, fontWeight: FontWeight.w500),
              ),
              Text(
                "\u20B9$price",
                style: GoogleFonts.sourceSansPro(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                description,
                textAlign: TextAlign.left,
                style: GoogleFonts.sourceSansPro(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        const Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 5),
              decoration: BoxDecoration(
                  border: Border.all(color: color1, width: 3),
                  color: color1,
                  borderRadius: BorderRadius.circular(10)),
              height: size.height * 0.06,
              width: size.width * 0.38,
              child: Center(
                child: Text(
                  'ACCEPT',
                  style: GoogleFonts.sourceSansPro(
                      color: Colors.white, fontSize: 20),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 5),
              decoration: BoxDecoration(
                  color: color1, borderRadius: BorderRadius.circular(10)),
              height: size.height * 0.06,
              width: size.width * 0.38,
              child: Center(
                child: Text(
                  'DENY',
                  style: GoogleFonts.sourceSansPro(
                      color: Colors.white, fontSize: 20),
                ),
              ),
            )
          ],
        )
      ]),
    );
  }
}
