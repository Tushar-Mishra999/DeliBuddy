import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delibuddy/components/rounded_button.dart';
import 'package:delibuddy/constants.dart';
import 'package:delibuddy/views/order/referral_screen.dart';
import 'package:delibuddy/views/chat/chat_screen.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderDescription extends StatefulWidget {
  static const routeName = '/order-description';
  OrderDescription({super.key, required this.shopName});
  String shopName;

  @override
  State<OrderDescription> createState() => _OrderDescriptionState();
}

class _OrderDescriptionState extends State<OrderDescription> {
  TextEditingController descriptionController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  late Timer _timer;
  String referralCode = '';
  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      statusChecking();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel(); // Stop the timer when the widget is disposed
  }

  void statusChecking() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('shop', widget.shopName);
      final DocumentReference ordersDocument =
          FirebaseFirestore.instance.collection('orders').doc('orders');
      final DocumentSnapshot<dynamic> orderDoc = await ordersDocument.get();

      List<dynamic> orders = orderDoc.data()!['orders'];
      String? email = prefs.getString('email');
      Map<String, dynamic>? orderMap = orders
          .firstWhere((order) => order['email'] == email, orElse: () => null);

      if (orderMap == null) {
        return;
      }

      String status = orderMap['status'];
      final orderTimestamp = orderMap['timestamp'].millisecondsSinceEpoch;
      final now = DateTime.now().millisecondsSinceEpoch;
      print(orderMap);
      if (now - orderTimestamp > 60000) {
        Fluttertoast.showToast(
            msg: 'No delivery buddies were available',
            backgroundColor: color2,
            textColor: Colors.white);
        orders.remove(orderMap);
        print(orders);
        await ordersDocument.set({
          'orders': orders,
        });
      } else if (status == 'pending') {
        Fluttertoast.showToast(
            msg: 'Waiting for delivery buddies to accept',
            backgroundColor: color2,
            textColor: Colors.white);
      } else if (status == 'reject') {
        Fluttertoast.showToast(
            msg: 'Order rejected, please try again after sometime',
            backgroundColor: color2,
            textColor: Colors.white);
        orders.remove(orderMap);
        await ordersDocument.set({
          'orders': orders,
        });
      } else if (status == 'accepted') {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? clientEmail = prefs.getString('email');
        if (referralCode.isNotEmpty && referralCode != 'null') {
          final DocumentSnapshot documentSnapshot2 = await FirebaseFirestore
              .instance
              .collection('users')
              .doc(clientEmail)
              .get();
          List<dynamic> referralList = documentSnapshot2['referralList'];
          referralList.remove(referralCode);
          DocumentReference ordersDoc =
              FirebaseFirestore.instance.collection('users').doc(clientEmail);
          ordersDoc.update({'referralList': referralList});
        }

        Navigator.popAndPushNamed(context, ChatScreen.routeName);
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg: 'Something went wrong, please try again',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: color2,
          textColor: Colors.white);
    }
  }

  void addOrder() async {
    try {
      // Get a reference to the 'orders' collection
      final documentSnapshot = await FirebaseFirestore.instance
          .collection('orders')
          .doc('orders')
          .get();
      final documentRef =
          FirebaseFirestore.instance.collection('orders').doc('orders');

      final currentOrders = (documentSnapshot.data()!['orders']);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? name = prefs.getString('name');
      String? email = prefs.getString('email');
      final order = {
        'name': name,
        'email': email,
        'description': descriptionController.text,
        'address': addressController.text,
        'shop': widget.shopName,
        'status': 'pending',
        'isReferral':
            referralCode.isNotEmpty && referralCode != 'null' ? true : false,
        'timestamp': Timestamp.now()
      };

      currentOrders.add(order);

      await documentRef.update({'orders': currentOrders});

      Fluttertoast.showToast(
          msg: 'Order has been placed successfully',
          backgroundColor: color2,
          textColor: Colors.white);
    } catch (e) {
      Fluttertoast.showToast(
          msg: 'Error adding order to orders array: $e',
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
                Row(
                  children: [
                    GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(Icons.arrow_back_ios_new)),
                    SizedBox(
                      width: size.width * 0.03,
                    ),
                  ],
                ),
                SizedBox(
                  height: size.height * 0.06,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: size.width * 0.05,
                    ),
                    Text(
                      widget.shopName,
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
                  height: size.height * 0.2,
                  width: size.width * 0.82,
                  decoration: BoxDecoration(
                    color: bgcolor,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 0),
                        inset: true,
                      ),
                      BoxShadow(
                        color: Colors.black.withOpacity(0.7),
                        blurRadius: 15,
                        offset: const Offset(7, 7),
                        inset: true,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: TextField(
                      controller: descriptionController,
                      style: GoogleFonts.sourceSansPro(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.w800),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Please type your order",
                      ),
                      maxLines: null,
                      textAlignVertical: TextAlignVertical.top,
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.05,
                ),
                Container(
                  height: size.height * 0.2,
                  width: size.width * 0.82,
                  decoration: BoxDecoration(
                    color: bgcolor,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 0),
                        inset: true,
                      ),
                      BoxShadow(
                        color: Colors.black.withOpacity(0.7),
                        blurRadius: 15,
                        offset: const Offset(7, 7),
                        inset: true,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: TextField(
                      controller: addressController,

                      style: GoogleFonts.sourceSansPro(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight
                              .w800), // allow unlimited number of lines
                      decoration: const InputDecoration(
                        hintMaxLines: 4,
                        border: InputBorder.none,
                        hintText:
                            "Delivery location (Please type in the exact address with your hostel name/building) ",
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.04,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, ReferralScreen.routeName)
                        .then((value) {
                      referralCode = value.toString();
                      if (referralCode.isNotEmpty && referralCode != 'null') {
                        Fluttertoast.showToast(
                            msg: "Coupon applied successfully",
                            backgroundColor: color2,
                            textColor: Colors.white);
                      }
                    });
                  },
                  child: Text(
                    'Apply Coupon',
                    style: GoogleFonts.sourceSansPro(
                        fontSize: 22,
                        color: color1,
                        fontWeight: FontWeight.w800),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.05,
                ),
                RoundedButton(
                  title: "Order",
                  size: size,
                  second: false,
                  func: () {
                    addOrder();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
