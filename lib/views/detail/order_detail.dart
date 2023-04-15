import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delibuddy/components/rounded_button.dart';
import 'package:delibuddy/constants.dart';
import 'package:delibuddy/views/detail/otp_field.dart';
import 'package:delibuddy/views/home/home_screen.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter/services.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderDetail extends StatefulWidget {
  static const routeName = '/order-detail';
  const OrderDetail({
    super.key,
    required this.otp,
    required this.description,
    required this.type,
    required this.chatRoomId,
    this.deliveryName = '',
  });
  final String otp;
  final String description;
  final String type;
  final String deliveryName;
  final String chatRoomId;
  @override
  State<OrderDetail> createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {
  TextEditingController otpController = TextEditingController();

  void checkOrderDelivery(String name) {
    try {
      DocumentReference ordersDoc =
          FirebaseFirestore.instance.collection('orders').doc('orders');

      ordersDoc.get().then((docSnapshot) async {
        List<dynamic> orderList = docSnapshot.get('orders');

        for (int i = 0; i < orderList.length; i++) {
          Map<dynamic, dynamic> orderMap = orderList[i];
          if (orderMap['name'] == name && orderMap['status'] == 'success') {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            orderList.remove(orderMap);
            await ordersDoc.update({'orders': orderList});


            DocumentReference docRef = await FirebaseFirestore.instance
                .collection('chats')
                .doc(widget.chatRoomId);
            await docRef.update({'cancel': false, 'chats': []});
            Fluttertoast.showToast(
                msg: "Order delivered",
                backgroundColor: color2,
                textColor: Colors.white);
            Navigator.pushNamedAndRemoveUntil(
                context, HomeScreen.routeName, (route) => false);
            return;
          }
        }

        Fluttertoast.showToast(
            msg: "Order not delivered yet",
            backgroundColor: color2,
            textColor: Colors.white);
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
    return Scaffold(
      backgroundColor: bgcolor,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: size.height * 0.04,
                ),
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
                  height: size.height * 0.03,
                ),
                widget.type == 'client'
                    ? Row(
                        children: [
                          SizedBox(
                            width: size.width * 0.05,
                          ),
                          Text(
                            'OTP: ',
                            style: GoogleFonts.sourceSansPro(
                                fontSize: 25,
                                color: Colors.black,
                                fontWeight: FontWeight.w700),
                          ),
                          Text(
                            widget.otp,
                            style: GoogleFonts.sourceSansPro(
                                fontSize: 25,
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      )
                    : Container(),
                SizedBox(
                  height: size.height * 0.02,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: size.width * 0.05,
                    ),
                    Text(
                      'Order Detail',
                      style: GoogleFonts.sourceSansPro(
                          fontSize: 25,
                          color: Colors.black,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                SizedBox(
                  height: size.height * 0.04,
                ),
                Container(
                  width: size.width * 0.8,
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
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      widget.description,
                      style: GoogleFonts.sourceSansPro(
                          fontSize: 20,
                          color: color2,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                widget.type == 'delivery'
                    ? OtpTextField(
                        otp: widget.otp,
                        controller: otpController,
                        hintText: "Enter otp",
                        title: "")
                    : Container(),
                SizedBox(
                  height: size.height * 0.02,
                ),
                widget.type == 'client'
                    ? Column(children: [
                        Container(
                          width: size.width * 0.8,
                          height: size.height * 0.4,
                          child: Image.asset(
                            upiId[widget.deliveryName]!['image']!,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.03,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'UPI ID: ',
                              style: GoogleFonts.sourceSansPro(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
                            ),
                            SelectableText(
                              upiId[widget.deliveryName]!['id']!,
                              style: GoogleFonts.sourceSansPro(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
                              onTap: () {
                                Clipboard.setData(ClipboardData(
                                    text: upiId[widget.deliveryName]!['id']));
                                Fluttertoast.showToast(
                                    msg: "UPI Id copied",
                                    backgroundColor: color2,
                                    textColor: Colors.white);
                              },
                            )
                          ],
                        ),
                      ])
                    : Container(),
                SizedBox(
                  height: size.height * 0.02,
                ),
                widget.type == 'client'
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RoundedButton(
                              title: "Order Received",
                              size: size,
                              func: () async {
                                SharedPreferences sharedPreferences =
                                    await SharedPreferences.getInstance();
                                String name =
                                    sharedPreferences.getString('name') ?? '';
                                checkOrderDelivery(name);
                              },
                              second: false),
                        ],
                      )
                    : Container()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
