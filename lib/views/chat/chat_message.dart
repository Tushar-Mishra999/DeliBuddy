import 'package:delibuddy/constants.dart';
import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  final String message;
  final bool receiver;
  final Size size;
  ChatMessage(
      {required this.message, required this.receiver, required this.size});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          receiver == true ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          height: size.height * 0.06,
          padding: const EdgeInsets.all(15),
          margin: const EdgeInsets.only(bottom: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(13),
            color: receiver == true ? color1 : Colors.black,
          ),
          child: Center(
            child: Text(
              message,
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontFamily: 'GilroyLight',
              ),
            ),
          ),
        )
      ],
    );
  }
}
