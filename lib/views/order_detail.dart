import 'package:delibuddy/constants.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderDetails extends StatelessWidget {
  const OrderDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: bgcolor,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(Icons.arrow_back_ios_new),
                  SizedBox(
                    width: size.width * 0.03,
                  ),
                  Text(
                    'Description',
                    style: GoogleFonts.sourceSansPro(
                        fontSize: 25,
                        color: Colors.black,
                        fontWeight: FontWeight.w700),
                  ),
                  Spacer(),
                  Container(
                    padding: EdgeInsets.all(2),
                    height: size.height * 0.055,
                    width: size.width * 0.22,
                    decoration: BoxDecoration(
                      color: Color(0xffE1573A),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Center(
                      child: Text(
                        'Order',
                        style: GoogleFonts.sourceSansPro(
                            fontSize: 25,
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: size.height * 0.06,
              ),
              DottedBorder(
                strokeWidth: 2,
                borderType: BorderType.RRect,
                radius: Radius.circular(12),
                child: Container(
                  height: size.height * 0.5,
                  decoration: BoxDecoration(),
                  child: Padding(
                    padding: EdgeInsets.all(15.0),
                    child: TextField(
                      style: GoogleFonts.sourceSansPro(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.w800),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "What's on your mind",
                      ),
                      maxLines: null,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
