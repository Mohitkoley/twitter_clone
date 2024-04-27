import 'dart:io';
import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/apis/storage_api.dart';
import 'package:twitter_clone/apis/tweet_api.dart';
import 'package:twitter_clone/core/enums.dart/tweet_type.dart';
import 'package:twitter_clone/core/extension.dart';
import 'package:twitter_clone/features/auth/controllers/auth_controller.dart';
import 'package:twitter_clone/model/tweet_model.dart';
import 'package:twitter_clone/model/user_model.dart';

final tweetControllerProvider = StateNotifierProvider<TweetController, bool>(
  (ref) {
    final tweetApi = ref.watch(tweetAPIProvider);
    return TweetController(
        ref: ref,
        tweetApi: tweetApi,
        storageAPI: ref.watch(storageAPIprovivder));
  },
);

final getTweetsProvider = FutureProvider<List<Tweet>>((ref) async {
  final tweetController = ref.watch(tweetControllerProvider.notifier);
  return await tweetController.getTweets();
});

final getTweetByIdProvider =
    FutureProvider.family<Tweet, String>((ref, id) async {
  final tweetController = ref.watch(tweetControllerProvider.notifier);
  return await tweetController.getTweetById(id);
});

final getRepliesToTweetProvider =
    FutureProvider.autoDispose.family<List<Tweet>, Tweet>((ref, tweet) async {
  final tweetController = ref.watch(tweetControllerProvider.notifier);
  return await tweetController.getRepliesToTweet(tweet);
});

final getLatestTweetProvider = StreamProvider.autoDispose((ref) {
  final tweetAPI = ref.watch(tweetAPIProvider);
  return tweetAPI.getLatestTweet();
});

class TweetController extends StateNotifier<bool> {
  final Ref _ref;
  final TweetApi _tweetApi;
  final StorageAPI _storage;
  TweetController(
      {required Ref ref,
      required TweetApi tweetApi,
      required StorageAPI storageAPI})
      : _ref = ref,
        _tweetApi = tweetApi,
        _storage = storageAPI,
        super(false);
  final RegExp regExp = RegExp(
    r"(?:(?:https?|ftp):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+",
    caseSensitive: false,
    multiLine: false,
  );

  final hashTagRegExp = RegExp(r"\B#\w*[a-zA-Z]+\w*");

  void shareTweet(List<File> images, String description, String repliedTo,
      String repliedToUserId, BuildContext context) {
    state = true;
    if (images.isNotEmpty) {
      _shareimage(images, description, repliedTo, repliedToUserId, context);
    }

    if (description.isNotEmpty) {
      _shareTextTweet(description, repliedTo, repliedToUserId, context);
    } else {
      context.showSnack("Please add description");
    }
  }

  _shareimage(List<File> images, String description, String repliedTo,
      String repliedToUserId, BuildContext context) async {
    final imageLinks = await _storage.uploadImage(images);
    state = true;
    final hashTags = _getHashTagFromText(description);
    final link = _getLinkFromText(description);
    final user = _ref.read(currentUserDetailsProvider).value!;
    Tweet tweet = Tweet(
      text: description,
      hashTags: hashTags,
      link: link,
      imageLinks: imageLinks,
      uid: user.uid,
      tweetType: TweetType.image,
      tweetedAt: DateTime.now(),
      likes: const [],
      commentIds: const [],
      id: ID.unique(),
      reshareCount: 0,
      reTweetedBy: "",
      repliedTo: repliedTo,
      repliedToUserId: repliedToUserId,
    );
    state = false;
    final res = await _tweetApi.shareTweet(tweet);
    res.fold((l) => context.showSnack(l.message), (r) {
      context.showSnack("Tweet Shared");
    });
  }

  _shareTextTweet(String description, String repliedTo, String repliedToUserId,
      BuildContext context) async {
    state = true;
    final hashTags = _getHashTagFromText(description);
    final link = _getLinkFromText(description);
    final user = _ref.read(currentUserDetailsProvider).value!;

    Tweet tweet = Tweet(
        text: description,
        hashTags: hashTags,
        link: link,
        imageLinks: const [],
        uid: user.uid,
        tweetType: TweetType.text,
        tweetedAt: DateTime.now(),
        likes: const [],
        commentIds: const [],
        id: ID.unique(),
        reshareCount: 0,
        reTweetedBy: '',
        repliedTo: repliedTo,
        repliedToUserId: repliedToUserId);
    state = false;
    final res = await _tweetApi.shareTweet(tweet);
    res.fold((l) => context.showSnack(l.message), (r) {
      context.showSnack("Tweet Shared");
    });
  }

  void likeTweet(Tweet tweet, UserModel userModel) async {
    state = true;
    final updatedTweet = tweet.copyWith(
        likes: tweet.likes.contains(userModel.uid)
            ? tweet.likes.where((element) => element != userModel.uid).toList()
            : [...tweet.likes, userModel.uid]);
    await _tweetApi.likeTweet(updatedTweet);

    state = false;
  }

  void reshareTweet(
      Tweet tweet, UserModel currentUser, BuildContext context) async {
    state = true;
    final updatedTweet = tweet.copyWith(
        likes: [],
        commentIds: [],
        reshareCount: tweet.reshareCount + 1,
        reTweetedBy: currentUser.uid);

    final response = await Future.wait([
      _tweetApi.updateReshareCount(updatedTweet),
      _tweetApi.likeTweet(updatedTweet)
    ]);

    final res = response[1];
    res.fold((l) => context.showSnack(l.message), (r) async {
      final tweetUser = tweet.copyWith(
        id: ID.unique(),
        reshareCount: 0,
        tweetedAt: DateTime.now(),
      );
      final res2 = await _tweetApi.shareTweet(tweetUser);
      res2.fold((l) => context.showSnack(l.message), (r) {
        context.showSnack("Retweeted!");
      });
    });
    state = false;
  }

  Future<List<Tweet>> getTweets() async {
    final tweetList = await _tweetApi.getTweets();
    return tweetList.map((tweet) => Tweet.fromMap(tweet.data)).toList();
  }

  Future<Tweet> getTweetById(String id) async {
    final tweet = await _tweetApi.getTweetById(id);
    return Tweet.fromMap(tweet.data);
  }

  Future<List<Tweet>> getRepliesToTweet(Tweet tweet) async {
    final tweetList = await _tweetApi.getRepliesToTweet(tweet);
    return tweetList.map((tweet) => Tweet.fromMap(tweet.data)).toList();
  }

  String _getLinkFromText(String text) {
    final match = regExp.firstMatch(text);
    return match?.group(0) ?? "";
  }

  List<String> _getHashTagFromText(String text) {
    final matches = hashTagRegExp.allMatches(text);
    if (matches.isEmpty) {
      return [];
    }
    return matches.map((e) => e.group(0)!).toList();
  }
}
