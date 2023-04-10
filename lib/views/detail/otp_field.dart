import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:delibuddy/constants.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class OtpTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final int maxLines;
  final bool obscure;
  final String title;
  final String otp;
  const OtpTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.title,
    this.obscure = false,
    required this.otp,
    this.maxLines = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(top: 20),
      width: size.width * 0.8,
      height: size.height * 0.07,
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
      child: Center(
        child: TextFormField(
          onFieldSubmitted: (value) {
            if (value == otp) {
              Fluttertoast.showToast(
                  msg: "Order verified", backgroundColor: color1);
            } else {
              Fluttertoast.showToast(
                  msg: "Wrong otp, please try again", backgroundColor: color1);
            }
          },
          controller: controller,
          obscureText: obscure,
          style: GoogleFonts.sourceSansPro(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15),
          decoration: InputDecoration(
            hintText: hintText,
            contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintStyle:
                GoogleFonts.sourceSansPro(color: Colors.grey, fontSize: 15),
            border: InputBorder.none,
          ),
          validator: (val) {
            if (val == null || val.isEmpty) {
              return 'Enter your $hintText';
            }
            return null;
          },
          maxLines: maxLines,
        ),
      ),
    );
  }
}
