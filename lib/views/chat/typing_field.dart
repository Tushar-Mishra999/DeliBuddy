import 'package:delibuddy/constants.dart';
import 'package:flutter/material.dart';

class TypingField extends StatelessWidget {
  const TypingField({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      width: size.width * 0.9,
      height: size.height * 0.06,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Container(
            width: size.width * 0.75,
            child: TextField(
              style: TextStyle(
                color: Colors.grey.shade800,
                fontSize: 15,
                fontFamily: 'GilroyLight',
                fontWeight: FontWeight.bold,
              ),
              onSubmitted: (val) {},
              decoration: const InputDecoration(
                  hintText: "Type a message",
                  border: InputBorder.none,
                  hintStyle: const TextStyle(
                      color: Color.fromARGB(255, 176, 176, 176))),
            ),
          ),
          Icon(
            Icons.attach_file,
            color: color1,
          ),
        ],
      ),
    );
  }
}
