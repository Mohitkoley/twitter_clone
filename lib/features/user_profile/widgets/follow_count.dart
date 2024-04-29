import 'package:flutter/cupertino.dart';
import 'package:twitter_clone/theme/pallete.dart';

class FollowCount extends StatelessWidget {
  const FollowCount({super.key, required this.count, required this.text});
  final int count;
  final String text;

  @override
  Widget build(BuildContext context) {
    const double fontSize = 18;
    return Row(
      children: [
        Text('$count',
            style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Pallete.greyColor)),
        const SizedBox(width: 5),
        Text(text,
            style:
                const TextStyle(fontSize: fontSize, color: Pallete.greyColor)),
      ],
    );
  }
}
