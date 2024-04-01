import 'package:flutter/material.dart';

extension ContextExt on BuildContext {
  double get width => MediaQuery.sizeOf(this).width;
  double get height => MediaQuery.sizeOf(this).height;

  showSnack(String msg) {
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(
      content: Text(msg),
    ));
  }
}
