import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'bottomnavigation.dart';

class BookingConfirmation extends StatefulWidget {
  final String bookingId;
  final String event;
  final String eventDesc;
  BookingConfirmation(
      {super.key,
      required this.bookingId,
      required this.event,
      required this.eventDesc});

  @override
  State<BookingConfirmation> createState() => _BookingConfirmationState();
}

class _BookingConfirmationState extends State<BookingConfirmation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/icon/confirmOrder.gif'),
              Center(
                  child: Text(
                widget.event,
                style: GoogleFonts.sourceSans3(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  letterSpacing: 1,
                  fontSize: 25,
                ),
              )),
              Padding(
                padding: const EdgeInsets.only(left: 100, right: 100),
                child: Divider(),
              ),
              Center(
                  child: Text(
                "${widget.eventDesc}: ${widget.bookingId}",
                style: GoogleFonts.sourceSans3(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  letterSpacing: 1,
                  fontSize: 15,
                ),
              )),
              SizedBox(
                height: 100,
              ),
              InkWell(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Bottomnavigation()),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 50, right: 50, top: 10, bottom: 10),
                    child: Text(
                      "Done",
                      style: GoogleFonts.sourceSans3(
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        letterSpacing: 1,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
