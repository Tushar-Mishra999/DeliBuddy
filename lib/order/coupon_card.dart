import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delibuddy/constants.dart';
import 'package:delibuddy/views/chat/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CouponCard extends StatelessWidget {
  const CouponCard({
    Key? key,
    required this.referralCode,
    required this.description,
  }) : super(key: key);

  final String referralCode;
  final String description;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      decoration:
          BoxDecoration(color: color2, borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.all(10),
      width: size.width * 0.8,
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 12, right: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                referralCode,
                style: GoogleFonts.sourceSansPro(
                    color: bgcolor, fontSize: 24, fontWeight: FontWeight.w500),
              ),
              const Spacer()
            ],
          ),
        ),
        Container(
          width: size.width * 1,
          padding: const EdgeInsets.only(top: 12.0, left: 12, right: 12),
          child: Text(
            description,
            textAlign: TextAlign.left,
            style: GoogleFonts.sourceSansPro(
                color: Colors.white, fontSize: 17, fontWeight: FontWeight.w500),
          ),
        ),
        SizedBox(
          height: size.height * 0.04,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () async {
                // SharedPreferences prefs = await SharedPreferences.getInstance();
                // String? deliveryName = prefs.getString('name');
                // String? deliveryEmail = prefs.getString('email');
                // String? type = prefs.getString('type');
                // final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
                //     await FirebaseFirestore.instance
                //         .collection('orders')
                //         .doc('orders')
                //         .get();

                // List<dynamic> orders = documentSnapshot.data()!['orders'];
                // int otp = Random().nextInt(9000) + 1000;
                // orders.forEach((order) {
                //   if (order['name'] == name) {
                //     order['deliveryName'] = deliveryName;
                //     order['deliveryEmail'] = deliveryEmail;
                //     order['status'] = 'accepted';
                //     order['otp'] = otp.toString();
                //   }
                // });
                // await FirebaseFirestore.instance
                //     .collection('chats')
                //     .doc("$email,$name:$deliveryEmail,$deliveryName")
                //     .set({'chats': []});
                // Navigator.pushNamed(context, ChatScreen.routeName);
                // await FirebaseFirestore.instance
                //     .collection('orders')
                //     .doc('orders')
                //     .update({'orders': orders});
              },
              child: Container(
                margin: EdgeInsets.only(bottom: 5),
                decoration: BoxDecoration(
                    border: Border.all(color: color1, width: 3),
                    color: color1,
                    borderRadius: BorderRadius.circular(10)),
                height: size.height * 0.06,
                width: size.width * 0.8,
                child: Center(
                  child: Text(
                    'APPLY',
                    style: GoogleFonts.sourceSansPro(
                        color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
            ),
          ],
        )
      ]),
    );
  }
}
