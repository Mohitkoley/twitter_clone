import 'package:flutter/material.dart';
import 'package:twitter_clone/core/enums.dart/tweet_type.dart';

extension ContextExt on BuildContext {
  double get height => MediaQuery.sizeOf(this).height;
  double get width => MediaQuery.sizeOf(this).width;

  void showSnack(String msg) {
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(content: Text(msg)));
  }
}

extension StringExt on String {
  String get nameFromEmail => split('@').first;
}

extension NumExt on num {
  SizedBox get hBox => SizedBox(height: toDouble());
  SizedBox get wBox => SizedBox(width: toDouble());
  SizedBox get hwBox => SizedBox(width: toDouble(), height: toDouble());
}

extension TweetTypeX on String {
  TweetType toEnum() {
    switch (this) {
      case 'text':
        return TweetType.text;
      case 'image':
        return TweetType.image;
      default:
        return TweetType.text;
    }
  }
}
