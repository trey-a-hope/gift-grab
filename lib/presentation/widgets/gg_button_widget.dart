import 'package:flutter/material.dart';
import 'package:gift_grab/data/constants/globals.dart';

class GGButtonWidget extends StatelessWidget {
  final void Function()? onPressed;
  final String title;

  const GGButtonWidget({this.onPressed, required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Globals.isTablet ? 400 : 250,
      height: Globals.isTablet ? 100 : 50,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(
          title,
          style: TextStyle(
            fontSize: Globals.isTablet ? 50 : 25,
          ),
        ),
      ),
    );
  }
}
