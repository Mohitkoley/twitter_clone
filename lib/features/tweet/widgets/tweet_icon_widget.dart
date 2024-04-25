// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:twitter_clone/theme/theme.dart';

class TweetIconButton extends StatelessWidget {
  const TweetIconButton({
    Key? key,
    required this.pathName,
    required this.text,
    required this.onTap,
  }) : super(key: key);
  final String pathName;
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          SvgPicture.asset(
            pathName,
            width: 20,
            height: 20,
            colorFilter: ColorFilter.mode(Pallete.greyColor, BlendMode.srcIn),
          ),
          Container(
            margin: const EdgeInsets.all(6),
            child: Text(
              text,
              style: const TextStyle(
                color: Pallete.greyColor,
                fontSize: 16,
              ),
            ),
          )
        ],
      ),
    );
  }
}
