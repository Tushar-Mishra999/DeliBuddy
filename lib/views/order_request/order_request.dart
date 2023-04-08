import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delibuddy/constants.dart';
import 'package:delibuddy/views/order_request/request_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderRequest extends StatefulWidget {
  const OrderRequest({super.key});

  @override
  State<OrderRequest> createState() => _OrderRequestState();
}

class _OrderRequestState extends State<OrderRequest> {
  TextEditingController messageController = new TextEditingController();
  Stream<DocumentSnapshot>? chatStream;

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

    chatStream = FirebaseFirestore.instance
        .collection('orders')
        .doc('orders')
        .snapshots();
  }

  Widget ChatMessageList() {
    //final user = Provider.of<UserProvider>(context, listen: false).user;
    //print(user.type);
    final size = MediaQuery.of(context).size;
    return StreamBuilder(
      stream: chatStream,
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          List<dynamic> orderList = snapshot.data!['orders'];
          // orderList = List.from(orderList.reversed);
          return Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: orderList.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> details = orderList[0];
                return RequestCard(
                  size: size,
                  name: details['clientName'],
                  description: details['message'],
                  price: details['price'].toString(),
                );
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
      body: Container(
        width: size.width * 1,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/logo.png'),
            fit: BoxFit.contain,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ChatMessageList()
            // RequestCard(size: size),
            // RequestCard(size: size),
            // RequestCard(size: size),
            // RequestCard(size: size),
          ],
        ),
      ),
    );
  }
}

