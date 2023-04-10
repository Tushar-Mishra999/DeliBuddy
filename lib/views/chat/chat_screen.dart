import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delibuddy/constants.dart';
import 'package:delibuddy/views/chat/chat_message.dart';
import 'package:delibuddy/views/chat/typing_field.dart';
import 'package:delibuddy/views/detail/order_detail.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

class ChatScreen extends StatefulWidget {
  static const routeName = '/chat-screen';
  final String name;
  final String chatRoomId;
  final String type;
  final String otp;
  final String description;
  ChatScreen(
      {required this.otp,
      required this.name,
      required this.chatRoomId,
      required this.type, required this.description});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Stream<DocumentSnapshot>? chatStream;
  TextEditingController messageController = TextEditingController();
  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.chatRoomId)
        .get()
        .then((docSnapshot) {
      if (!docSnapshot.exists) {
        FirebaseFirestore.instance
            .collection('chats')
            .doc(widget.chatRoomId)
            .set({'chat': []});
      }
    });

    chatStream = FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.chatRoomId)
        .snapshots();
  }

  void sendMessage() async {
    print(widget.type);
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "message": messageController.text,
        "sender": widget.type == 'client' ? 'client' : 'delivery',
        "time": DateTime.now().millisecondsSinceEpoch
      };

      FirebaseFirestore.instance
          .collection('chats')
          .doc(widget.chatRoomId)
          .update({
        'chat': FieldValue.arrayUnion([messageMap]),
      });

      setState(() {
        messageController.text = "";
      });
    }
  }

  Widget ChatMessageList() {
    return StreamBuilder(
      stream: chatStream,
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          List<dynamic> chatList = snapshot.data!['chat'];
          chatList = List.from(chatList.reversed);

          return Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              reverse: true,
              itemCount: chatList.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> chatMessage = chatList[index];
                return ChatMessage(
                  message: chatMessage['message'],
                  receiver: chatMessage['sender'] == widget.type ? false : true,
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
                widget.name,
                style: const TextStyle(
                  color: color1,
                  fontSize: 20,
                  fontFamily: 'GilroyLight',
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, OrderDetail.routeName,
                      arguments: {
                        'otp': widget.otp,
                        'description': widget.description,
                        'type': widget.type
                      });
                },
                child: Icon(
                  Icons.help_outline,
                  color: color1,
                ),
              )
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
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
    );
  }
}
