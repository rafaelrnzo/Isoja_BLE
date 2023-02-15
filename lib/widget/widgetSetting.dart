import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_isoja/global/color.dart';
import 'package:flutter_isoja/page/settingPage.dart';
import 'package:google_fonts/google_fonts.dart';

class buttonUploadd extends StatelessWidget {
  const buttonUploadd({
    Key? key,
    required this.width,
  }) : super(key: key);

  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width / 4,
      height: width / 5,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16), // <-- Radius
            ),
            primary: base,
          ),
          onPressed: (() {}),
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Icon(
                  Icons.upload_rounded,
                  size: 32,
                ),
                Text(
                  "Upload",
                  style: GoogleFonts.inter(
                      color: bg, fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ],
            ),
          )),
    );
  }
}

class buttonDelete extends StatelessWidget {
  const buttonDelete({
    Key? key,
    required this.width,
  }) : super(key: key);

  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width / 4,
      height: width / 5,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16), // <-- Radius
            ),
            primary: base,
          ),
          onPressed: (() {}),
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Icon(
                  Icons.delete_rounded,
                  size: 32,
                ),
                Text(
                  "Delete",
                  style: GoogleFonts.inter(
                      color: bg, fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ],
            ),
          )),
    );
  }
}
