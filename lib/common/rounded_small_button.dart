import 'package:flutter/material.dart';
import 'package:twitter_clone/theme/theme.dart';

class RoundedSmallButton extends StatelessWidget {
  RoundedSmallButton(
      {super.key,
      required this.label,
      required this.onPressed,
      this.backgroundColor = Pallete.whiteColor,
      this.textColor = Pallete.backgroundColor});
  final String label;
  final VoidCallback onPressed;
  Color backgroundColor;
  Color textColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Chip(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: textColor, width: 1)),
        label: Text(label, style: TextStyle(color: textColor, fontSize: 16)),
        backgroundColor: backgroundColor,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
    );
  }
}
