import 'dart:io';
import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/constants/appwrite_constant.dart';
import 'package:twitter_clone/core/provider.dart';

final storageAPIprovivder =
    Provider((ref) => StorageAPI(storage: ref.read(appwriteStorageProvider)));

class StorageAPI {
  final Storage _storage;
  StorageAPI({required Storage storage}) : _storage = storage;

  Future<List<String>> uploadImage(List<File> files) async {
    List<String> imageLinks = [];
    for (final file in files) {
      final uploadImage = await _storage.createFile(
          bucketId: AppwriteConstant.imagesBucket,
          fileId: ID.unique(),
          file: InputFile.fromPath(path: file.path));

      imageLinks.add(AppwriteConstant.imageUrl(uploadImage.$id));
    }
    return imageLinks;
  }
}
