import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delibuddy/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'coupon_card.dart';

class ReferralScreen extends StatefulWidget {
  static const routeName = '/referral-screen';
  const ReferralScreen({super.key});

  @override
  State<ReferralScreen> createState() => _ReferralScreenState();
}

class _ReferralScreenState extends State<ReferralScreen> {
  List<dynamic> couponList = [];
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  void fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');
    final DocumentSnapshot<Map<String, dynamic>> docSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(email).get();

    final userData = docSnapshot.data();
    setState(() {
      couponList = userData!['referralList'];
    });
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: bgcolor,
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: color1,
              ),
            )
          : SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: size.height * 0.1,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: size.width * 0.09,
                      ),
                      Text(
                        'Coupons',
                        style: GoogleFonts.sourceSansPro(
                            fontSize: 25,
                            color: Colors.black,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: size.height * 0.03,
                  ),
                  Container(
                    width: size.width * 0.9,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: couponList.length,
                      itemBuilder: (context, index) {
                        String referralCode = couponList[index].toString();
                        return CouponCard(
                          description: 'Get 1 order delivered to your location',
                          referralCode: referralCode,
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
