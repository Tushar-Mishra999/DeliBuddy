import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:delibuddy/constants.dart';
import 'package:flutter/material.dart';

class TypingField extends StatefulWidget {
  const TypingField(
      {Key? key,
      required this.size,
      required this.textController,
      required this.func})
      : super(key: key);

  final Size size;
  final TextEditingController textController;
  final Function func;

  @override
  State<TypingField> createState() => _TypingFieldState();
}

class _TypingFieldState extends State<TypingField> {
  String? _imageUrl;
  Future<File?> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    return pickedFile != null ? File(pickedFile.path) : null;
  }

  Future<String?> uploadImage(File file) async {
    final fileName = file.path.split('/').last;
    final reference = FirebaseStorage.instance.ref().child(fileName);
    final uploadTask = reference.putFile(file);
    final snapshot = await uploadTask.whenComplete(() {});
    final downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
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
            width: widget.size.width * 0.75,
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
          GestureDetector(
            onTap: () async {
              final file = await pickImage();
              if (file != null) {
                final url = await uploadImage(file);
                if (url != null) {
                  setState(() {
                    _imageUrl = url;
                    widget.textController.text = _imageUrl!;
                    widget.func(isImage: true);
                  });
                }
              }
            },
            child:
                Icon(Icons.attach_file, color: color1, size: size.width * 0.06),
          ),
        ],
      ),
    );
  }
}
