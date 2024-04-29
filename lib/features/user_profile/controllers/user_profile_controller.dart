import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/apis/storage_api.dart';
import 'package:twitter_clone/apis/tweet_api.dart';
import 'package:twitter_clone/apis/user_api.dart';
import 'package:twitter_clone/core/extension.dart';
import 'package:twitter_clone/model/tweet_model.dart';
import 'package:twitter_clone/model/user_model.dart';

final userProfileControllerProvider =
    StateNotifierProvider<UserProfileController, bool>(
  (ref) {
    final tweetAPI = ref.watch(tweetAPIProvider);
    final storageAPI = ref.watch(storageAPIprovivder);
    final userAPI = ref.watch(userAPIProvider);
    return UserProfileController(
        tweetAPI: tweetAPI, storageAPI: storageAPI, userAPI: userAPI);
  },
);

final getUsersTweetsProvider =
    FutureProvider.autoDispose.family<List<Tweet>, String>(
  (ref, uid) async {
    final controller = ref.read(userProfileControllerProvider.notifier);
    return controller.getUsersTweet(uid: uid);
  },
);

class UserProfileController extends StateNotifier<bool> {
  final TweetApi _tweetAPI;
  final StorageAPI _storageAPI;
  final UserAPI _userAPI;
  UserProfileController(
      {required TweetApi tweetAPI,
      required StorageAPI storageAPI,
      required UserAPI userAPI})
      : _tweetAPI = tweetAPI,
        _userAPI = userAPI,
        _storageAPI = storageAPI,
        super(false);

  Future<List<Tweet>> getUsersTweet({required String uid}) async {
    final tweet = await _tweetAPI.getUserTweets(uid);
    return tweet.map((e) => Tweet.fromMap(e.data)).toList();
  }

  Future<void> updateUserProfile({
    required UserModel userModel,
    required BuildContext context,
    required File? bannerImage,
    required File? profileImage,
  }) async {
    state = true;
    if (bannerImage != null) {
      final bannerUrl = await _storageAPI.uploadImage([bannerImage]);
      userModel = userModel.copyWith(
        bannerPic: bannerUrl[0],
      );
    }
    if (profileImage != null) {
      final profileUrl = await _storageAPI.uploadImage([profileImage]);
      userModel = userModel.copyWith(
        profilePic: profileUrl[0],
      );
    }
    final res = await _userAPI.updateUserData(userModel);
    state = false;
    res.fold(
        (l) => context.showSnack(l.message), (r) => Navigator.pop(context));
  }
}
