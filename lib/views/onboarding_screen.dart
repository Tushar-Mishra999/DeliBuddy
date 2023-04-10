import 'package:flutter/material.dart';
import 'package:delibuddy/constants.dart';
import 'package:delibuddy/views/auth/login_screen.dart';
import 'package:delibuddy/views/auth/registration_screen.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../components/rounded_button.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: bgcolor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Image.asset(
                'assets/logo.png',
                height: size.height * 0.5,
              ),
            ),
            Container(
              width: size.width * 0.8,
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Delivery",
                      style: GoogleFonts.inter(
                        color: color1,
                        fontSize: 25,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    TextSpan(
                      text: " at your doorstep, made easy.",
                      style: GoogleFonts.inter(
                        color: color2,
                        fontSize: 25,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: size.height * 0.05,
            ),
            Container(
              height: size.height * 0.1,
              width: size.width * 0.8,
              child: Text(
                "Now get anything delivered to you at your hostel’s in just a few clicks from our affiliated stores and vendors",
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
            SizedBox(
              height: size.height * 0.01,
            ),
            RoundedButton(
              title: "Login",
              size: size,
              second: false,
              func: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
            ),
            SizedBox(
              height: size.height * 0.01,
            ),
            RoundedButton(
              title: "Register",
              size: size,
              second: true,
              func: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RegistrationScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
