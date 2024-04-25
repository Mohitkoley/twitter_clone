import 'package:flutter/material.dart';

class AuthField extends StatelessWidget {
  const AuthField(
      {super.key,
      required this.controller,
      required this.hintText,
      this.onFieldSubmitted});
  final TextEditingController controller;
  final String hintText;
  final void Function(String)? onFieldSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      textInputAction: TextInputAction.search,
      onFieldSubmitted: onFieldSubmitted,
      decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(
              color: Colors.blue,
              width: 3,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(
              color: Colors.grey,
              width: 1,
            ),
          ),
          hintText: hintText,
          hintStyle: const TextStyle(fontSize: 18)),
    );
  }
}
