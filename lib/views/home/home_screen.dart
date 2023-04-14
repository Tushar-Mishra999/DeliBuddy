import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delibuddy/views/home/shop.dart';
import 'package:delibuddy/constants.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import '../profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/homescreen';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> stores = [];
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    fetchstores();
  }

  void fetchstores() async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance
              .collection('stores')
              .doc('stores')
              .get();
      isLoading = false;
      setState(() {
        stores = List<Map<String, dynamic>>.from(snapshot.data()!['stores']);
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
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: color1,
                ),
              )
            : SafeArea(
                child: SingleChildScrollView(
                  child: Column(children: [
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, ProfileScreen.routeName);
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
                      height: size.height * 0.02,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: size.width * 0.05,
                        ),
                        Text(
                          'Search what you need',
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
                    Container(
                      width: size.width * 0.9,
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: stores.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Shop(
                            size: size,
                            name: stores[index]['name'],
                            status: stores[index]['status'],
                          );
                        },
                      ),
                    )
                  ]),
                ),
              ));
  }
}
