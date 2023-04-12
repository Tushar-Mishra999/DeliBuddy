import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:delibuddy/constants.dart';
import 'package:delibuddy/views/auth/login_screen.dart';
import 'package:delibuddy/views/auth/registration_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../components/rounded_button.dart';

class OnboardingScreen extends StatefulWidget {
  static const routeName = '/onboarding-screen';
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int activeIndex = 0;

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
            Column(
              children: [
                CarouselSlider.builder(
                  options: CarouselOptions(
                      viewportFraction: 1,
                      height: size.height * 0.2,
                      pageSnapping: true,
                      enableInfiniteScroll: false,
                      enlargeCenterPage: false,
                      onPageChanged: ((index, reason) {
                        activeIndex = index;
                        setState(() {});
                      })),
                  itemCount: 3,
                  itemBuilder: (context, index, realIndex) {
                    return Column(
                      children: [
                        Container(
                          width: size.width * 0.9,
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: onboardingScreen[index]['first'],
                                  style: GoogleFonts.inter(
                                    color: color1,
                                    fontSize: 25,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                TextSpan(
                                  text: onboardingScreen[index]['second'],
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
                          height: size.height * 0.03,
                        ),
                        Container(
                          height: size.height * 0.1,
                          width: size.width * 0.8,
                          child: Text(
                            onboardingScreen[index]['third']!,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                AnimatedSmoothIndicator(
                  activeIndex: activeIndex,
                  count: 3,
                  effect: SlideEffect(
                      activeDotColor: color1,
                      dotWidth: 10,
                      dotHeight: 10,
                      dotColor: color2),
                )
              ],
            ),
            SizedBox(
              height: size.height * 0.02,
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
