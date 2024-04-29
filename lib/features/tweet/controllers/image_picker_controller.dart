import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

final imagePickerProvider =
    StateNotifierProvider<ImagePickerNotifier, List<File>>((ref) {
  return ImagePickerNotifier();
});

class ImagePickerNotifier extends StateNotifier<List<File>> {
  ImagePickerNotifier() : super([]); // Start with an empty list

  Future<List<File>> pickMultipleImage() async {
    final List<XFile> images = await ImagePicker().pickMultiImage();

    if (images.isNotEmpty) {
      state = images.map((image) => File(image.path)).toList();
    }

    return state;
  }

  Future<File?> pickImage() async {
    final XFile? image =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image != null) {
      return File(image.path);
    }
    return null;
  }

  void removeImage(File image) {
    state = state.where((element) => element != image).toList();
  }
}
