import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:delibuddy/constants.dart';
import 'package:flutter/material.dart';

class TypingField extends StatefulWidget {
  TypingField(
      {Key? key,
      required this.size,
      required this.textController,
      required this.func,
      required this.isLoading})
      : super(key: key);

  final Size size;
  bool isLoading;
  final TextEditingController textController;
  final Function func;

  @override
  State<TypingField> createState() => _TypingFieldState();
}

class _TypingFieldState extends State<TypingField> {
  String? _imageUrl;
  Future<File?> pickImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      return pickedFile != null ? File(pickedFile.path) : null;
    } catch (e) {
      Fluttertoast.showToast(
          msg: 'Something went wrong, please try again',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: color2,
          textColor: Colors.white);
    }
  }

  Future<String?> uploadImage(File file) async {
    try {
      final fileName = file.path.split('/').last;
      final reference = FirebaseStorage.instance.ref().child(fileName);
      final uploadTask = reference.putFile(file);
      final snapshot = await uploadTask.whenComplete(() {});
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
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
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      width: widget.size.width * 0.9,
      height: widget.size.height * 0.08,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Container(
            width: size.width * 0.6,
            child: TextField(
              controller: widget.textController,
              onSubmitted: (value) {
                widget.func();
              },
              style: TextStyle(
                color: Colors.grey.shade800,
                fontSize: 15,
                fontFamily: 'GilroyLight',
                fontWeight: FontWeight.bold,
              ),
              decoration: const InputDecoration(
                  hintText: "Type a message",
                  border: InputBorder.none,
                  hintStyle:
                      TextStyle(color: Color.fromARGB(255, 176, 176, 176))),
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () async {
              widget.func();
            },
            child: Icon(Icons.send_rounded,
                color: color1, size: size.width * 0.06),
          ),
          SizedBox(width: size.width * 0.05),
          GestureDetector(
            onTap: () async {
              widget.isLoading = true;
              setState(() {});
              final file = await pickImage();
              if (file != null) {
                final url = await uploadImage(file);
                if (url != null) {
                  _imageUrl = url;
                  widget.textController.text = _imageUrl!;
                  widget.func(isImage: true);
                }
              }
              widget.isLoading = false;
              setState(() {});
            },
            child:
                Icon(Icons.attach_file, color: color1, size: size.width * 0.06),
          ),
          SizedBox(width: size.width * 0.02),
        ],
      ),
    );
  }
}
