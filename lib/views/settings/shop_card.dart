import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delibuddy/views/order/order_place.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants.dart';

class ShopCard extends StatefulWidget {
  ShopCard(
      {Key? key, required this.size, required this.name, required this.status})
      : super(key: key);

  final Size size;
  final String name;
  bool status;

  @override
  State<ShopCard> createState() => _ShopCardState();
}

class _ShopCardState extends State<ShopCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15),
      padding: const EdgeInsets.only(left: 12, right: 12),
      width: widget.size.width * 0.8,
      height: widget.size.height * 0.08,
      decoration:
          BoxDecoration(color: color2, borderRadius: BorderRadius.circular(10)),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.name,
              style: GoogleFonts.sourceSansPro(
                  fontSize: 20, color: bgcolor, fontWeight: FontWeight.w800),
            ),
            Switch.adaptive(
                activeColor: Colors.green,
                inactiveTrackColor: Colors.red,
                value: widget.status,
                onChanged: (val) async {
                  final collectionRef =
                      FirebaseFirestore.instance.collection('stores');
                  final documentSnapshot =
                      await collectionRef.doc('stores').get();
                  final storesArray = List<Map<String, dynamic>>.from(
                      documentSnapshot.data()!['stores']);

                  final index = storesArray
                      .indexWhere((store) => store['name'] == widget.name);
                  if (index >= 0) {
                    widget.status = !storesArray[index]['status'];
                    final updatedStore = {
                      'name': widget.name,
                      'status': !storesArray[index]['status'],
                    };
                    storesArray[index] = updatedStore;
                    await collectionRef
                        .doc('stores')
                        .update({'stores': storesArray});
                    setState(() {});
                  }
                }),
          ],
        ),
      ),
    );
  }
}
