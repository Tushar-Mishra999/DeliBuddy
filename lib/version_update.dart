import 'package:delibuddy/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:url_launcher/url_launcher.dart';

class VersionUpdate extends StatelessWidget {
  static const routeName = '/version-update';
  const VersionUpdate({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: bgcolor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Please update your app",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  color: color2,
                ),
              ),
              SizedBox(
                height: size.height * 0.05,
              ),
              GestureDetector(
                  onTap: () async {
                    const url =
                        'https://drive.google.com/drive/folders/1ARm4oiY51BHHg7OFPjD4-NzbIj6-siy0';
                    await launchUrl(Uri.parse(url));
                  },
                  child: Container(
                    width: size.width * 0.7,
                    height: size.height * 0.05,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: color1,
                    ),
                    child: Center(
                      child: Text(
                        'UPDATE',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 20),
                      ),
                    ),
                  ))
            ],
          ),
        ));
  }
}
