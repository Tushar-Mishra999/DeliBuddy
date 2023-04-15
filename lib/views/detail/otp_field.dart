import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delibuddy/views/order_request/order_request.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:delibuddy/constants.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtpTextField extends StatefulWidget {
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
  State<OtpTextField> createState() => _OtpTextFieldState();
}

class _OtpTextFieldState extends State<OtpTextField> {

  
  void updateOrderStatus(String deliveryName) {
    try {
      DocumentReference ordersDoc =
          FirebaseFirestore.instance.collection('orders').doc('orders');

      ordersDoc.get().then((docSnapshot) async {
        List<dynamic> orderList = docSnapshot.get('orders');
        for (int i = 0; i < orderList.length; i++) {
          Map<dynamic, dynamic> orderMap = orderList[i];
          if (orderMap['deliveryName'] == deliveryName) {
            orderMap['status'] = 'success';
            orderList[i] = orderMap;
            break;
          }
        }
        ordersDoc.update({'orders': orderList});
        Navigator.pushNamedAndRemoveUntil(
            context, OrderRequest.routeName, (route) => false);
      });
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
            if (value == widget.otp) {
              Fluttertoast.showToast(
                  msg: "OTP accepted",
                  backgroundColor: color2,
                  textColor: Colors.white);
              SharedPreferences sharedPreferences =
                  await SharedPreferences.getInstance();
              String deliveryName = sharedPreferences.getString('name') ?? '';
              updateOrderStatus(deliveryName);
            } else {
              Fluttertoast.showToast(
                  msg: "Wrong otp, please try again",
                  backgroundColor: color2,
                  textColor: Colors.white);
            }
          },
          controller: widget.controller,
          obscureText: widget.obscure,
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
