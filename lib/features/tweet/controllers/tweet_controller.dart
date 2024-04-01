import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/apis/tweet_api.dart';
import 'package:twitter_clone/core/enums.dart/tweet_type.dart';
import 'package:twitter_clone/core/extension.dart';
import 'package:twitter_clone/features/auth/controllers/auth_controller.dart';
import 'package:twitter_clone/model/tweet_model.dart';

class TweetController extends StateNotifier<bool> {
  final Ref _ref;
  final TweetApi _tweetApi;
  TweetController({required Ref ref, required TweetApi tweetApi})
      : _ref = ref,
        _tweetApi = tweetApi,
        super(false);
  final RegExp regExp = RegExp(
    r"(?:(?:https?|ftp):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+",
    caseSensitive: false,
    multiLine: false,
  );

  final hashTagRegExp = RegExp(r"\B#\w*[a-zA-Z]+\w*");

  void shareTweet(List<File> images, String description, BuildContext context) {
    state = true;
    if (images.isNotEmpty) {
      _shareimage(images, description, context);
    }

    if (description.isNotEmpty) {
      _shareTextTweet(description, context);
    } else {
      context.showSnack("Please add description");
    }
  }

  _shareimage(List<File> images, String description, BuildContext context) {}

  _shareTextTweet(String description, BuildContext context) {
    state = true;
    final hashTags = _getHashTagFromText(description);
    final link = _getLinkFromText(description);
    final user = _ref.read(currentUserDetailsProvider).value!;
    Tweet tweet = Tweet(
      text: description,
      hashTags: hashTags,
      link: link,
      imageLinks: [],
      uid: user.uid,
      tweetType: TweetType.text,
      tweetedAt: DateTime.now(),
      likes: const [],
      commentIds: const [],
      id: ID.unique(),
      reshareCount: 0,
    );
    _tweetApi.shareTweet(tweet);
    //Todo: create fields on appwrite
  }

  String _getLinkFromText(String text) {
    final match = regExp.firstMatch(text);
    return match?.group(0) ?? "";
  }

  List<String> _getHashTagFromText(String text) {
    final matches = hashTagRegExp.allMatches(text);
    return matches.map((e) => e.group(0)!).toList();
  }
}
