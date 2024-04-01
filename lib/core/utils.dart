import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Utils {
  Utils._();

  Future<List<File>> pickImages() async {
    List<File> images = [];
    try {
      final result = await ImagePicker().pickMultiImage(
        imageQuality: 50,
        maxWidth: 800,
      );
      if (result.isNotEmpty) {
        for (var image in result) {
          final file = File(image.path);
          images.add(file);
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return images;
  }
}
