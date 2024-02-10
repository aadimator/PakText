import 'package:flutter/material.dart';

class CustomButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final VoidCallback onLongPress;
  final IconData icon;
  final String tooltip;

  const CustomButtonWidget(
      {super.key,
      required this.onPressed,
      this.onLongPress = emptyFunction,
      required this.icon,
      required this.tooltip});

  static void emptyFunction() {}

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onLongPress,
      child: IconButton(
        icon: Icon(
          icon,
          color: Colors.white.withOpacity(0.7),
        ), // replace with your desired icon
        onPressed: onPressed,
        // tooltip: tooltip, // this is the hint or alt text
        splashRadius:
            24.0, // this reduces the splash radius to remove the border
      ),
    );
  }
}
