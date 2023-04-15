import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:delibuddy/constants.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:google_fonts/google_fonts.dart';

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

  

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.45,
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
