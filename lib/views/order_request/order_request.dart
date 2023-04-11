import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delibuddy/constants.dart';
import 'package:delibuddy/views/order_request/request_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import '../profile/profile_screen.dart';

class OrderRequest extends StatefulWidget {
  static const routeName = '/order-request';
  const OrderRequest({super.key});

  @override
  State<OrderRequest> createState() => _OrderRequestState();
}

class _OrderRequestState extends State<OrderRequest> {
  TextEditingController messageController = new TextEditingController();
  Stream<DocumentSnapshot>? orderStream;

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection('orders')
        .doc('orders')
        .get()
        .then((docSnapshot) {
      if (!docSnapshot.exists) {
        FirebaseFirestore.instance
            .collection('orders')
            .doc('orders')
            .set({'orders': []});
      }
    });

    orderStream = FirebaseFirestore.instance
        .collection('orders')
        .doc('orders')
        .snapshots();
    // Timer.periodic(const Duration(seconds: 30), (timer) {
    //   deleteOldOrders();
    // });
  }

  Future<void> deleteOldOrders() async {
    final currentTime = DateTime.now().millisecondsSinceEpoch;
    final ordersRef =
        FirebaseFirestore.instance.collection('orders').doc('orders');
    final docSnapshot = await ordersRef.get();
    if (docSnapshot.exists) {
      final orders =
          List<Map<String, dynamic>>.from(docSnapshot.data()!['orders']);
      final updatedOrders = <Map<String, dynamic>>[];
      orders.forEach((order) {
        final orderTime = order['timestamp'].millisecondsSinceEpoch;
        if (currentTime - orderTime < 60000) {
          updatedOrders.add(order);
        }
      });
      await ordersRef.update({'orders': updatedOrders});
    }
  }

  Widget OrderList() {
    //final user = Provider.of<UserProvider>(context, listen: false).user;
    final size = MediaQuery.of(context).size;
    return StreamBuilder(
      stream: orderStream,
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          List<dynamic> orderList = snapshot.data!['orders'];
          return Container(
            width: size.width * 0.9,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: orderList.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> details = orderList[index];
                return details['status'] == 'pending'
                    ? RequestCard(
                        size: size,
                        name: details['name'],
                        description: details['description'],
                        shop: details['shop'],
                        address: details['address'],
                        email: details['email'],
                      )
                    : Container();
              },
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: bgcolor,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, ProfileScreen.routeName);
                    },
                    child: const Icon(
                      Icons.person_outlined,
                      size: 35,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: size.height * 0.05,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: size.width * 0.09,
                ),
                Text(
                  'Orders',
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
            OrderList()
          ],
        ),
      ),
    );
  }
}
