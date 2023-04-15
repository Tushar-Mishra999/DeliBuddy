import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delibuddy/views/order_request/order_request.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:delibuddy/constants.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PhoneNumberField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final int maxLines;
  final bool obscure;
  final String title;
  final String phoneNumber;
  const PhoneNumberField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.title,
    this.obscure = false,
    this.maxLines = 1,
    required this.phoneNumber,
  }) : super(key: key);

  @override
  State<PhoneNumberField> createState() => _PhoneNumberFieldState();
}

class _PhoneNumberFieldState extends State<PhoneNumberField> {
  @override
  void initState() {
    super.initState();
    widget.controller.text = widget.phoneNumber;
  }

  void updatePhoneNumber(String phoneNumber) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String email = pref.getString('email')!;
      final DocumentReference<Map<String, dynamic>> docReference =
          await FirebaseFirestore.instance.collection('users').doc(email);
      await docReference.update({'phoneNumber': phoneNumber});
      
      Fluttertoast.showToast(
          msg: "Phone number updated",
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: color2,
          textColor: Colors.white);
    } catch (e) {
      Fluttertoast.showToast(
          msg: 'Something went wrong, please try again',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: color2,
          textColor: Colors.white);
    }
  }

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
          onFieldSubmitted: (value) async {
            updatePhoneNumber(value);
          },
          controller: widget.controller,
          style: GoogleFonts.sourceSansPro(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15),
          decoration: InputDecoration(
            hintText: widget.hintText,
            contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintStyle:
                GoogleFonts.sourceSansPro(color: Colors.grey, fontSize: 15),
            border: InputBorder.none,
          ),
          validator: (val) {
            if (val == null || val.isEmpty) {
              return 'Enter your ${widget.hintText}';
            }
            return null;
          },
          maxLines: widget.maxLines,
        ),
      ),
    );
  }
}
