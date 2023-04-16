import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delibuddy/constants.dart';
import 'package:delibuddy/notifications.dart';
import 'package:delibuddy/views/order_request/request_card.dart';
import 'package:flutter/material.dart';
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
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    // FirebaseFirestore.instance
    //     .collection('orders')
    //     .doc('orders')
    //     .get()
    //     .then((docSnapshot) {
    //   if (!docSnapshot.exists) {
    //     FirebaseFirestore.instance
    //         .collection('orders')
    //         .doc('orders')
    //         .set({'orders': []});
    //   }
    // });

    orderStream = FirebaseFirestore.instance
        .collection('orders')
        .doc('orders')
        .snapshots();

    _timer = Timer.periodic(const Duration(seconds: 30), (timer) {
      deleteOldOrders();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel(); // Stop the timer when the widget is disposed
  }

  Future<void> deleteOldOrders() async {
    try {
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
          if (currentTime - orderTime < 120000 ||
              order['status'] != 'pending') {
            updatedOrders.add(order);
          }
        });
        await ordersRef.update({'orders': updatedOrders});
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg: 'Something went wrong, please try again',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: color2,
          textColor: Colors.white);
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
          //latest order
          Map<String, dynamic> latestOrder =
              orderList.isNotEmpty ? orderList.last : {};
          // Call the showNotification method if a new order is added
          if (latestOrder.isNotEmpty && latestOrder['status'] == 'pending') {
            NotificationApi.showNotification(
              id: Random().nextInt(1000),
              title: latestOrder['shop'],
              body: latestOrder['description'],
              payload: "New Order",
            );
          }
          return orderList.isEmpty
              ? Center(
                  child: Text(
                    'No Orders',
                    style: GoogleFonts.sourceSansPro(
                        fontSize: 25,
                        color: Colors.black,
                        fontWeight: FontWeight.w700),
                  ),
                )
              : Container(
                  width: size.width * 0.9,
                  child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
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
                              isReferral: details['isReferral'],
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
        child: SingleChildScrollView(
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
                      onTap: () async {
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
      ),
    );
  }
}
