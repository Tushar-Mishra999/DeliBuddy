import 'package:delibuddy/constants.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderDetail extends StatelessWidget {
  const OrderDetail({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: bgcolor,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.arrow_back_ios_new),
                  SizedBox(
                    width: size.width * 0.03,
                  ),
                  // Text(
                  //   'Description',
                  //   style: GoogleFonts.sourceSansPro(
                  //       fontSize: 25,
                  //       color: Colors.black,
                  //       fontWeight: FontWeight.w700),
                  // ),
                  Spacer(),
                ],
              ),
              SizedBox(
                height: size.height * 0.06,
              ),
              Text(
                'Order Detail',
                style: GoogleFonts.sourceSansPro(
                    fontSize: 25,
                    color: Colors.black,
                    fontWeight: FontWeight.w700),
              ),
              SizedBox(
                height: size.height * 0.04,
              ),
              Container(
                width: size.width * 0.9,
                decoration: BoxDecoration(
                  color: bgcolor,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      offset: Offset(0, 0),
                      inset: true,
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.7),
                      blurRadius: 10,
                      offset: Offset(4, 4),
                      inset: true,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    "Triple Chicken Double Anda \n One Ice Tea Nimbu daalke",
                    style: GoogleFonts.sourceSansPro(
                        fontSize: 20,
                        color: color2,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.04,
              ),
              Row(
                children: [
                  Text(
                    'OTP: ',
                    style: GoogleFonts.sourceSansPro(
                        fontSize: 25,
                        color: Colors.black,
                        fontWeight: FontWeight.w700),
                  ),
                  Text(
                    '4569',
                    style: GoogleFonts.sourceSansPro(
                        fontSize: 25,
                        color: Colors.black,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              SizedBox(
                height: size.height * 0.04,
              ),
              Row(
                children: [
                  Text(
                    'UPI ID: ',
                    style: GoogleFonts.sourceSansPro(
                        fontSize: 25,
                        color: Colors.black,
                        fontWeight: FontWeight.w700),
                  ),
                  Text(
                    '9958904763@sidplex',
                    style: GoogleFonts.sourceSansPro(
                        fontSize: 25,
                        color: Colors.black,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              SizedBox(
                height: size.height * 0.04,
              ),
              Center(
                child: Container(
                  width: size.width * 0.8,
                  height: size.height * 0.4,
                  child: Image.asset(
                    'assets/qr.png',
                    fit: BoxFit.cover,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
