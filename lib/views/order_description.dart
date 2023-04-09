import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delibuddy/components/rounded_button.dart';
import 'package:delibuddy/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderDescription extends StatelessWidget {
  OrderDescription({super.key});
  TextEditingController textController = TextEditingController();
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
      print("adadas $currentOrders");
      final order = {
        'name': 'Harcoded name',
        'email': FirebaseAuth.instance.currentUser!.email,
        'description': textController.text,
        'price': '10',
        'timestamp': Timestamp.now()
      };
      print("NEw order $order");
      currentOrders.add(order);

      await documentRef.update({'orders': currentOrders});

      Fluttertoast.showToast(msg: 'Order added to orders array successfully.');
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error adding order to orders array: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: bgcolor,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  const Icon(Icons.arrow_back_ios_new),
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
                    'Surya Truck Shop',
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
              // strokeWidth: 2,
              // borderType: BorderType.RRect,
              // radius: Radius.circular(12),
              Container(
                height: size.height * 0.35,
                width: size.width * 0.82,
                decoration: BoxDecoration(
                  color: bgcolor,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 15,
                      offset: Offset(0, 0),
                      inset: true,
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.7),
                      blurRadius: 15,
                      offset: Offset(7, 7),
                      inset: true,
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: TextField(
                    controller: textController,
                    style: GoogleFonts.sourceSansPro(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.w800),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Please type your order",
                    ),
                    maxLines: null,
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.2,
              ),
              RoundedButton(
                title: "Order",
                size: size,
                second: false,
                func: () {
                  addOrder();
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => RegistrationScreen()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
