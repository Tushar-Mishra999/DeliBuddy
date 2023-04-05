import 'package:delibuddy/constants.dart';
import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  final String message;
  final bool receiver;
  ChatMessage({required this.message, required this.receiver});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          receiver == true ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.only(bottom: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topRight: receiver == true
                    ? const Radius.circular(0)
                    : const Radius.circular(10),
                topLeft: receiver == true
                    ? const Radius.circular(10)
                    : const Radius.circular(0),
                bottomLeft: const Radius.circular(10),
                bottomRight: const Radius.circular(10)),
            color: receiver == true ? color1 : Colors.black,
          ),
          child: Text(
            message,
            style: TextStyle(
              color: receiver == true ? Colors.white : color1,
              fontSize: 15,
              fontFamily: 'GilroyLight',
              fontWeight: FontWeight.w800,
            ),
          ),
        )
      ],
    );
  }
}
