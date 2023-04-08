import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delibuddy/components/search_bar.dart';
import 'package:delibuddy/views/home/shop.dart';
import 'package:delibuddy/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/homescreen';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> stores = [];

  @override
  void initState() {
    super.initState();
    fetchstores();
  }

  void fetchstores() async {
    final DocumentSnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance
            .collection('stores')
            .doc('stores')
            .get();

    setState(() {
      stores = List<String>.from(snapshot.data()!['stores']);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: bgcolor,
        body: SafeArea(
          child: Center(
              child: Container(
            width: size.width * 0.9,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: stores.length,
              itemBuilder: (BuildContext context, int index) {
                return Shop(
                  size: size,
                  name: stores[index],
                );
              },
            ),
          )),
        ));
  }
}
