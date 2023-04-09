import 'package:delibuddy/constants.dart';
import 'package:delibuddy/views/chat/chat_message.dart';
import 'package:delibuddy/views/chat/typing_field.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class ChatScreen extends StatelessWidget {
  final String name;
  ChatScreen({required this.name});
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: bgcolor,
      appBar: AppBar(
        backgroundColor: bgcolor,
        title: Container(
          padding: const EdgeInsets.only(top: 10),
          height: size.height * 0.05,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: size.width * 0.02,
              ),
              Text(
                name,
                style: const TextStyle(
                  color: color1,
                  fontSize: 20,
                  fontFamily: 'GilroyLight',
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(10),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ChatMessage(
                        message: ' Hello namaste aunty',
                        receiver: false,
                        size: size,
                      ),
                      ChatMessage(
                        message: 'Chalo kaam ki baat par aate hain',
                        receiver: true,
                        size: size,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            TypingField(size: size)
          ],
        ),
      ),
    );
  }
}
