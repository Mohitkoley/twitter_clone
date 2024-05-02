// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/common/error_screen.dart';
import 'package:twitter_clone/common/loading_screen.dart';
import 'package:twitter_clone/features/tweet/controllers/tweet_controller.dart';
import 'package:twitter_clone/features/tweet/widgets/tweet_card.dart';
import 'package:twitter_clone/model/tweet_model.dart';

class HashTagView extends ConsumerWidget {
  const HashTagView({
    super.key,
    required this.hashTag,
  });
  final String hashTag;

  static Route route(String hashTag) => MaterialPageRoute<void>(
      builder: (context) => HashTagView(
            hashTag: hashTag,
          ));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text(hashTag),
        ),
        body: ref.watch(getTweetsByHashTagProvider(hashTag)).when(
              data: (tweets) {
                if (tweets.isEmpty) {
                  return const Center(
                    child: Text(
                      "No Tweets",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  );
                } else {
                  return ListView.builder(
                      itemCount: tweets.length,
                      itemBuilder: (context, index) {
                        Tweet tweet = tweets[index];
                        return TweetCard(tweet: tweet);
                      });
                }
              },
              error: (error, stackTrace) => ErrorScreen(
                message: error.toString(),
              ),
              loading: () => const Loader(),
            ));
  }
}
