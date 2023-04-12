import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delibuddy/constants.dart';
import 'package:delibuddy/views/chat/chat_message.dart';
import 'package:delibuddy/views/chat/typing_field.dart';
import 'package:delibuddy/views/detail/order_detail.dart';
import 'package:delibuddy/views/order_request/order_request.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../home/home_screen.dart';

class ChatScreen extends StatefulWidget {
  static const routeName = '/chat-screen';
  const ChatScreen({super.key});
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool isLoading = true;
  String otp = '';
  String chatRoomId = '';
  String type = '';
  String description = '';
  String receiverName = '';
  bool isReferral = false;
  Stream<DocumentSnapshot>? chatStream;
  TextEditingController messageController = TextEditingController();
  @override
  void initState() {
    super.initState();
    retrieveData();
  }

  void retrieveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? name = prefs.getString('name');
    type = prefs.getString('type')!;
    final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await FirebaseFirestore.instance
            .collection('orders')
            .doc('orders')
            .get();

    Map<String, dynamic> mp = {};
    List<dynamic> orders = documentSnapshot.data()!['orders'];
    for (var order in orders) {
      if (order['name'] == name || order['deliveryName'] == name) {
        mp = order;
        break;
      }
    }

    receiverName = type == 'delivery' ? mp['name'] : mp['deliveryName'];
    isReferral = mp['isReferral'];
    chatRoomId = mp['email'] +
        ',' +
        mp['name'] +
        ":" +
        mp['deliveryEmail'] +
        ',' +
        mp['deliveryName'];
    otp = mp['otp'].toString();
    description = mp['description'];

    chatStream = FirebaseFirestore.instance
        .collection('chats')
        .doc(chatRoomId)
        .snapshots();
    prefs.setBool('isChat', true);
    isLoading = false;
    setState(() {});
  }

  void sendMessage({bool isImage = false}) async {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "message": messageController.text,
        "sender": type == 'client' ? 'client' : 'delivery',
        "time": DateTime.now().millisecondsSinceEpoch,
        "isImage": isImage
      };

      FirebaseFirestore.instance.collection('chats').doc(chatRoomId).update({
        'chats': FieldValue.arrayUnion([messageMap]),
      });

      setState(() {
        messageController.text = "";
      });
    }
  }

  Widget ChatMessageList() {
    final size = MediaQuery.of(context).size;
    return StreamBuilder(
      stream: chatStream,
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          List<dynamic> chatList = snapshot.data!['chats'];
          chatList = List.from(chatList.reversed);
          bool isCancel = snapshot.data!['cancel'];
          if (isCancel) {
            Fluttertoast.showToast(
                msg: "Order has been cancelled",
                backgroundColor: color2,
                textColor: Colors.white);
            
            if (type == 'delivery') {
              WidgetsBinding.instance.addPostFrameCallback((_) async{
                await Future.delayed(const Duration(seconds: 1));
                Navigator.pushNamedAndRemoveUntil(
                    context, OrderRequest.routeName, (route) => false);
              });
            } else {
              WidgetsBinding.instance.addPostFrameCallback((_)async{
                await Future.delayed(const Duration(seconds: 1));
                Navigator.pushNamedAndRemoveUntil(
                    context, HomeScreen.routeName, (route) => false);
              });
            }
          }
          return Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              reverse: true,
              itemCount: chatList.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> chatMessage = chatList[index];
                return chatMessage['isImage']
                    ? Row(
                        mainAxisAlignment: chatMessage['sender'] == type
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 15, bottom: 15),
                            width: size.width * 0.7,
                            height: size.width * 0.7,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                    image: NetworkImage(chatMessage['message']),
                                    fit: BoxFit.fill)),
                          ),
                        ],
                      )
                    : ChatMessage(
                        message: chatMessage['message'],
                        receiver: chatMessage['sender'] == type ? false : true,
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
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: bgcolor,
        appBar: AppBar(
          backgroundColor: bgcolor,
          automaticallyImplyLeading: false,
          title: Container(
            padding: const EdgeInsets.only(top: 10),
            height: size.height * 0.05,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: size.width * 0.01,
                ),
                Text(
                  receiverName,
                  style: const TextStyle(
                    color: color1,
                    fontSize: 20,
                    fontFamily: 'GilroyLight',
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(
                  width: size.width * 0.05,
                ),
                isReferral && type == 'delivery'
                    ? const Icon(
                        Icons.star,
                        color: color1,
                      )
                    : Container(),
                const Spacer(),
                GestureDetector(
                  onTap: () async {
                    DocumentReference docRef = await FirebaseFirestore.instance
                        .collection('chats')
                        .doc(chatRoomId);
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.setBool('isChat', false);
                    DocumentReference ordersDoc = FirebaseFirestore.instance
                        .collection('orders')
                        .doc('orders');

                    ordersDoc.get().then((docSnapshot) async {
                      List<dynamic> orderList = docSnapshot.get('orders');
                      for (int i = 0; i < orderList.length; i++) {
                        Map<dynamic, dynamic> orderMap = orderList[i];
                        if (orderMap['name'] == receiverName ||
                            orderMap['deliveryName' == receiverName]) {
                          orderList.remove(orderMap);
                          ordersDoc.update({'orders': orderList});
                        }
                      }
                    });
                    await docRef.update({'cancel': true});
                  },
                  child: type == 'delivery'
                      ? const Icon(
                          Icons.cancel_outlined,
                          color: color1,
                        )
                      : Container(),
                ),
                SizedBox(
                  width: size.width * 0.05,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, OrderDetail.routeName,
                        arguments: {
                          'otp': otp,
                          'description': description,
                          'type': type
                        });
                  },
                  child: type == 'client'
                      ? const Text(
                          'PAY',
                          style: TextStyle(
                            color: color2,
                            fontSize: 20,
                            fontFamily: 'GilroyLight',
                            fontWeight: FontWeight.w800,
                          ),
                        )
                      : Icon(
                          Icons.info_outlined,
                          color: color1,
                        ),
                )
              ],
            ),
          ),
        ),
        body: SafeArea(
          child: isLoading
              ? Center(
                  child: CircularProgressIndicator(
                  color: color1,
                ))
              : Column(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            ChatMessageList(),
                            SizedBox(
                              height: size.height * 0.01,
                            ),
                          ],
                        ),
                      ),
                    ),
                    TypingField(
                      size: size,
                      func: sendMessage,
                      textController: messageController,
                    )
                  ],
                ),
        ),
      ),
    );
  }
}
