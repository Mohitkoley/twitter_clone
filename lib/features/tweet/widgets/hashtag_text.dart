import 'package:flutter/material.dart';

class HashTagText extends StatelessWidget {
  const HashTagText({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    List<TextSpan> textspans = [];

    text.split(' ').forEach((element) {
      if (element.startsWith('#')) {
        textspans.add(TextSpan(
            text: '$element ',
            style: const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 18)));
      } else if (element.startsWith('www.') || element.startsWith('https://')) {
        textspans.add(TextSpan(
            text: '$element ',
            style: const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 18)));
      } else {
        textspans.add(
            TextSpan(text: '$element ', style: const TextStyle(fontSize: 18)));
      }
    });

    return RichText(
      text: TextSpan(children: textspans),
    );
  }
}
