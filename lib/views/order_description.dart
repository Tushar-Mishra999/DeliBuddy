import 'package:delibuddy/components/rounded_button.dart';
import 'package:delibuddy/constants.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderDescription extends StatelessWidget {
  const OrderDescription({super.key});

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
            crossAxisAlignment: CrossAxisAlignment.center,
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
                  // Container(
                  //   padding: EdgeInsets.all(2),
                  //   height: size.height * 0.055,
                  //   width: size.width * 0.22,
                  //   decoration: BoxDecoration(
                  //     color: Color(0xffE1573A),
                  //     borderRadius: BorderRadius.circular(25),
                  //   ),
                  //   child: Center(
                  //     child: Text(
                  //       'Order',
                  //       style: GoogleFonts.sourceSansPro(
                  //           fontSize: 25,
                  //           color: Colors.white,
                  //           fontWeight: FontWeight.w600),
                  //     ),
                  //   ),
                  // )
                ],
              ),
              SizedBox(
                height: size.height * 0.06,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: size.width * 0.05,
                  ),
                  Text(
                    'Surya Truck Shop',
                    style: GoogleFonts.sourceSansPro(
                        fontSize: 25,
                        color: Colors.black,
                        fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              SizedBox(
                height: size.height * 0.04,
              ),
              // strokeWidth: 2,
              // borderType: BorderType.RRect,
              // radius: Radius.circular(12),
              Container(
                height: size.height * 0.35,
                width: size.width * 0.82,
                decoration: BoxDecoration(
                  color: bgcolor,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 15,
                      offset: Offset(0, 0),
                      inset: true,
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.7),
                      blurRadius: 15,
                      offset: Offset(7, 7),
                      inset: true,
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: TextField(
                    style: GoogleFonts.sourceSansPro(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.w800),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Please type your order",
                    ),
                    maxLines: null,
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.2,
              ),
              RoundedButton(
                title: "Order",
                size: size,
                second: false,
                func: () {
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => RegistrationScreen()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
