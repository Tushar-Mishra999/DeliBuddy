import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delibuddy/constants.dart';
import 'package:delibuddy/views/chat/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RequestCard extends StatelessWidget {
  const RequestCard(
      {Key? key,
      required this.size,
      required this.name,
      required this.shop,
      required this.description,
      required this.address,
      required this.email})
      : super(key: key);

  final Size size;
  final String name;
  final String shop;
  final String description;
  final String email;
  final String address;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          BoxDecoration(color: color2, borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.all(10),
      width: size.width * 0.8,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 12, right: 12),
          child: Text(
            shop.length > 30 ? name.substring(0, 12) + "..." : name,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            textAlign: TextAlign.left,
            style: GoogleFonts.sourceSansPro(
                color: bgcolor, fontSize: 24, fontWeight: FontWeight.w500),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 12, right: 12),
          child: Text(
            name.length > 30 ? shop.substring(0, 10) + "..." : shop,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: GoogleFonts.sourceSansPro(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ),
        Container(
          width: size.width * 1,
          padding: const EdgeInsets.only(top: 12.0, left: 12, right: 12),
          child: Text(
            "Description: " + description,
            textAlign: TextAlign.left,
            style: GoogleFonts.sourceSansPro(
                color: Colors.white, fontSize: 17, fontWeight: FontWeight.w500),
          ),
        ),
        Container(
          width: size.width * 1,
          padding: const EdgeInsets.all(12.0),
          child: Text(
            "Address: " + address,
            textAlign: TextAlign.left,
            style: GoogleFonts.sourceSansPro(
                color: Colors.white, fontSize: 17, fontWeight: FontWeight.w500),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                String? deliveryName = prefs.getString('name');
                String? deliveryEmail = prefs.getString('email');
                String? type = prefs.getString('type');
                final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
                    await FirebaseFirestore.instance
                        .collection('orders')
                        .doc('orders')
                        .get();

                List<dynamic> orders = documentSnapshot.data()!['orders'];
                int otp = Random().nextInt(9000) + 1000;
                orders.forEach((order) {
                  if (order['name'] == name) {
                    order['deliveryName'] = deliveryName;
                    order['deliveryEmail'] = deliveryEmail;
                    order['status'] = 'accepted';
                    order['otp'] = otp.toString();
                  }
                });
                await FirebaseFirestore.instance
                    .collection('chats')
                    .doc("$email,$name:$deliveryEmail,$deliveryName")
                    .set({'chats': [], 'cancel': false});
                Navigator.popAndPushNamed(context, ChatScreen.routeName);
                await FirebaseFirestore.instance
                    .collection('orders')
                    .doc('orders')
                    .update({'orders': orders});
              },
              child: Container(
                margin: EdgeInsets.only(bottom: 5),
                decoration: BoxDecoration(
                    border: Border.all(color: color1, width: 3),
                    color: color1,
                    borderRadius: BorderRadius.circular(10)),
                height: size.height * 0.06,
                width: size.width * 0.38,
                child: Center(
                  child: Text(
                    'ACCEPT',
                    style: GoogleFonts.sourceSansPro(
                        color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 5),
              decoration: BoxDecoration(
                  color: color1, borderRadius: BorderRadius.circular(10)),
              height: size.height * 0.06,
              width: size.width * 0.38,
              child: Center(
                child: Text(
                  'DENY',
                  style: GoogleFonts.sourceSansPro(
                      color: Colors.white, fontSize: 20),
                ),
              ),
            )
          ],
        )
      ]),
    );
  }
}
