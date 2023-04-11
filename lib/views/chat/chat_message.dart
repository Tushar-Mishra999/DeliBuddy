import 'package:delibuddy/constants.dart';
import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  final String message;
  final bool receiver;
  ChatMessage({required this.message, required this.receiver});
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Align(
      alignment: receiver ? Alignment.centerLeft : Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: size.width * 0.8),
        child: Container(
          padding:
              const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
          margin: const EdgeInsets.only(bottom: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(13),
            color: receiver != true ? color1 : Colors.black,
          ),
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
    );
  }
}
