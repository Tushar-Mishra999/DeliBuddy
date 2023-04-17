import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delibuddy/constants.dart';
import 'package:delibuddy/notifications.dart';
import 'package:delibuddy/views/order_request/request_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import '../profile/profile_screen.dart';

class OrderRequest extends StatefulWidget {
  static const routeName = '/order-request';
  const OrderRequest({super.key});

  @override
  State<OrderRequest> createState() => _OrderRequestState();
}

class _OrderRequestState extends State<OrderRequest>
    with WidgetsBindingObserver {
  TextEditingController messageController = new TextEditingController();
  Stream<QuerySnapshot>? orderStream;
  bool isNotification = false;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    orderStream = FirebaseFirestore.instance
    .collection('orders')
    .where('status', isEqualTo: 'pending')
    .snapshots();
    helloWorld();
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      deleteOldOrders();
      checkNotifications();
    });
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    _timer.cancel();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      isNotification = false;
    }
  }

  void helloWorld() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  checkNotifications() async {
    if (isNotification) {
      return;
    }
    final ordersRef = FirebaseFirestore.instance.collection('orders');
    final querySnapshot = await ordersRef.get();
    final orders = List<Map<String, dynamic>>.from(
        querySnapshot.docs.map((doc) => doc.data()));

    for (var order in orders) {
      if (order['status'] == 'pending') {
        isNotification = true;
        break;
      }
    }

    if (isNotification) {
      NotificationApi.showNotification(
        id: 1,
        title: "Hey Buddy",
        body: "You got a new order",
        payload: "New Order",
      );
    }
  }

  Future<void> deleteOldOrders() async {
    try {
      final currentTime = DateTime.now().millisecondsSinceEpoch;
      final CollectionReference ordersCollection =
          FirebaseFirestore.instance.collection('orders');
      final QuerySnapshot<dynamic> pendingOrdersSnapshot =
          await ordersCollection.where('status', isEqualTo: 'pending').get();

      final int currentTimestamp = Timestamp.now().seconds;

      for (final QueryDocumentSnapshot<dynamic> orderDoc
          in pendingOrdersSnapshot.docs) {
        final Timestamp timestamp = orderDoc.data()['timestamp'];
        final int orderTimestamp = timestamp.seconds;

        if (currentTimestamp > orderTimestamp + 120) {
          await ordersCollection.doc(orderDoc.id).update({'status': 'notfound'});
        }
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
          List<DocumentSnapshot> orderList = snapshot.data!.docs;;
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
                      Map<String, dynamic> details =
                        orderList[index].data() as Map<String, dynamic>;;
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
    isNotification = true;
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
