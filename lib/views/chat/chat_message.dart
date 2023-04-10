import 'package:delibuddy/constants.dart';
import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  final String message;
  final bool receiver;
  ChatMessage({required this.message, required this.receiver});
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment:
          receiver ? MainAxisAlignment.start : MainAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.only(left: 20, right: 20),
          margin: const EdgeInsets.only(bottom: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(13),
            color: receiver != true ? color1 : Colors.black,
          ),
          child: Center(
            child: Text(
              message,
              maxLines: 5,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontFamily: 'GilroyLight',
              ),
            ),
          ),
        ),
      ],
    );
  }
}
