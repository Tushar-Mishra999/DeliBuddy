import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delibuddy/components/rounded_button.dart';
import 'package:delibuddy/constants.dart';
import 'package:delibuddy/views/detail/otp_field.dart';
import 'package:delibuddy/views/onboarding_screen.dart';
import 'package:delibuddy/views/profile/phonenumber_field.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/profile-screen';
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String name = '';
  String email = '';
  String referralCode = '';
  String phoneNumber = '';
  bool isLoading = true;
  TextEditingController phoneController = TextEditingController();
  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  void fetchUserData() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      email = pref.getString('email')!;
      final DocumentSnapshot<Map<String, dynamic>> docSnapshot =
          await FirebaseFirestore.instance.collection('users').doc(email).get();

      final userData = docSnapshot.data();
      setState(() {
        name = userData!['name'];
        referralCode = userData['referralCode'];
        isLoading = false;
        if (userData['phoneNumber'] != null) {
          phoneNumber = userData['phoneNumber'];
        }
      });
    } catch (e) {
      Fluttertoast.showToast(
          msg: 'Something went wrong, please try again',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: color2,
          textColor: Colors.white);
    }
  }

  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('name', '');
      prefs.setString('email', '');
      prefs.setBool('isLoggedIn', false);
      Navigator.pushNamedAndRemoveUntil(
          context, OnboardingScreen.routeName, (route) => false);
    } catch (e) {
      print(e.toString());
    }
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
    return Scaffold(
      backgroundColor: bgcolor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: isLoading
                ? const CircularProgressIndicator(
                    color: color1,
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: const Icon(
                                  Icons.arrow_back_ios_new,
                                )),
                            SizedBox(
                              width: size.width * 0.8,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: size.height * 0.05,
                        ),
                        Container(
                          height: size.width * 0.5,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10)),
                          child: Image.asset(
                            'assets/profile.png',
                            fit: BoxFit.fill,
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.05,
                        ),
                        Text(
                          name,
                          style: GoogleFonts.sourceSansPro(
                              fontSize: 30, fontWeight: FontWeight.w700),
                        ),
                        SizedBox(
                          height: size.height * 0.05,
                        ),
                        Text(
                          'Email- $email',
                          style: GoogleFonts.sourceSansPro(
                              fontSize: 25, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: size.height * 0.03,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Referral Code : ',
                              style: GoogleFonts.sourceSansPro(
                                fontSize: 25,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            DottedBorder(
                              color: Colors.black,
                              borderType: BorderType.RRect,
                              radius: Radius.circular(5),
                              strokeWidth: 1,
                              child: SelectableText(
                                ' $referralCode',
                                style: GoogleFonts.sourceSansPro(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w800,
                                ),
                                onTap: () {
                                  Clipboard.setData(
                                      ClipboardData(text: referralCode));
                                  Fluttertoast.showToast(
                                      msg: "Referral code copied",
                                      backgroundColor: color2,
                                      textColor: Colors.white);
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: size.height * 0.04,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            PhoneNumberField(
                              controller: phoneController,
                              hintText: "Enter whatsapp no.",
                              title: "",
                              phoneNumber: phoneNumber,
                            ),
                            SizedBox(
                              width: size.width * 0.04,
                            ),
                            GestureDetector(
                              onTap: () {
                                updatePhoneNumber(phoneController.text);
                              },
                              child: Container(
                                width: size.width * 0.25,
                                height: size.height * 0.07,
                                decoration: BoxDecoration(
                                    color: color2,
                                    borderRadius: BorderRadius.circular(12)),
                                child: Center(
                                  child: Text(
                                    'SAVE',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: size.height * 0.06,
                        ),
                        RoundedButton(
                            title: "Logout",
                            size: size,
                            func: () {
                              signOut();
                            },
                            second: false),
                      ]),
          ),
        ),
      ),
    );
  }
}
