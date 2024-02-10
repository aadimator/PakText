import 'package:flutter/material.dart';

class PakTextWidget extends StatelessWidget {
  final double fontSize;
  final String fontFamily;
  final TextEditingController controller;
  final TextAlign textAlign;

  const PakTextWidget(
      {super.key,
      required this.fontSize,
      required this.fontFamily,
      required this.controller,
      required this.textAlign});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: TextFormField(
            controller: controller,
            maxLines: null, // this allows for multiple lines
            cursorColor:
                Colors.white.withOpacity(0.7), // this changes the cursor color
            style: TextStyle(
                color: Colors.white,
                fontSize: fontSize,
                fontFamily: fontFamily),
            textAlign: textAlign,
            decoration: InputDecoration(
              hintText: 'ٹائپ کریں',
              hintStyle: TextStyle(
                  color: Colors.white
                      .withOpacity(0.7)), // this changes the hint text color
              border: InputBorder.none, // this removes the underline
            ),
          ),
        ),
      ),
    );
  }
}
