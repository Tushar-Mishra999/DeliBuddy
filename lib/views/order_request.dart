import 'package:delibuddy/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderRequest extends StatefulWidget {
  const OrderRequest({super.key});

  @override
  State<OrderRequest> createState() => _OrderRequestState();
}

class _OrderRequestState extends State<OrderRequest> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: bgcolor,
      body: Container(
        width: size.width * 1,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/logo.png'),
            fit: BoxFit.contain,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RequestCard(size: size),
            RequestCard(size: size),
            RequestCard(size: size),
            RequestCard(size: size),
          ],
        ),
      ),
    );
  }
}

class RequestCard extends StatelessWidget {
  const RequestCard({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.5),
          borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.all(10),
      height: size.height * 0.2,
      width: size.width * 0.8,
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 12, right: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Sixplex',
                style: GoogleFonts.sourceSansPro(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.w500),
              ),
              Text(
                "\$10",
                style: GoogleFonts.sourceSansPro(
                    color: color1, fontSize: 24, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            "Abcd edfgh ijklmnop lmnopqrst uvwxyz, xyz butter on your bread",
            style: GoogleFonts.sourceSansPro(
                color: Colors.black, fontSize: 15, fontWeight: FontWeight.w500),
          ),
        ),
        const Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 5),
              decoration: BoxDecoration(
                  border: Border.all(color: color1, width: 3),
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(10)),
              height: size.height * 0.06,
              width: size.width * 0.38,
              child: Center(
                child: Text(
                  'Accept',
                  style: GoogleFonts.sourceSansPro(color: color1, fontSize: 20),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 5),
              decoration: BoxDecoration(
                  color: color1, borderRadius: BorderRadius.circular(10)),
              height: size.height * 0.06,
              width: size.width * 0.38,
              child: Center(
                child: Text(
                  'Accept',
                  style: GoogleFonts.sourceSansPro(
                      color: Colors.black, fontSize: 20),
                ),
              ),
            )
          ],
        )
      ]),
    );
  }
}
