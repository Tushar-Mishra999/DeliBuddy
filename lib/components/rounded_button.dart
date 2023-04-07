import 'package:flutter/material.dart';
import 'package:delibuddy/constants.dart';
import 'package:google_fonts/google_fonts.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton(
      {Key? key,
      required this.title,
      required this.size,
      required this.func,
      required this.second})
      : super(key: key);

  final size;
  final title;
  final func;
  final second;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: func,
      child: Container(
          width: size.width * 0.82,
          height: size.height * 0.07,
          decoration: BoxDecoration(
              color: second ? color2 : color1,
              borderRadius: const BorderRadius.all(Radius.circular(10))),
          child: Center(
            child: Text(
              title,
              style: GoogleFonts.sourceSansPro(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: second ? color1 : Colors.white,
              ),
            ),
          )),
    );
  }
}
