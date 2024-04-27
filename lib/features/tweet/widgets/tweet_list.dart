import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/common/error_screen.dart';
import 'package:twitter_clone/common/loading_screen.dart';
import 'package:twitter_clone/constants/appwrite_constant.dart';
import 'package:twitter_clone/features/tweet/controllers/tweet_controller.dart';
import 'package:twitter_clone/features/tweet/widgets/tweet_card.dart';
import 'package:twitter_clone/model/tweet_model.dart';

class TweetList extends ConsumerWidget {
  const TweetList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(getTweetsProvider).when(
        data: (tweets) {
          return ref.watch(getLatestTweetProvider).when(
              data: (data) {
                if (data.events.contains(
                    'databases.*.collections.${AppwriteConstant.tweetCollection}.documents.*.create')) {
                  tweets.insert(0, Tweet.fromMap(data.payload));
                } else if (data.events.contains(
                    'databases.*.collections.${AppwriteConstant.tweetCollection}.documents.*.update')) {
                  debugPrint(data.events[0]);
                  final startingPoint =
                      data.events[0].lastIndexOf('documents.');
                  final endPoint = data.events[0].lastIndexOf('.update');
                  final tweetId =
                      data.events[0].substring(startingPoint + 10, endPoint);
                  Tweet tweet =
                      tweets.firstWhere((element) => element.id == tweetId);
                  int index = tweets.indexOf(tweet);
                  tweets.removeWhere((element) => element.id == tweetId);
                  tweet = Tweet.fromMap(data.payload);
                  tweets.insert(index, tweet);
                  // tweets[index] = tweet.copyWith(
                  //     reshareCount: data.payload['reshareCount']);
                }

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
              loading: () => ListView.builder(
                  itemCount: tweets.length,
                  itemBuilder: (context, index) {
                    Tweet tweet = tweets[index];
                    return TweetCard(tweet: tweet);
                  }));
        },
        error: (error, stackTrace) => ErrorScreen(
              message: error.toString(),
            ),
        loading: () => const Loader());
  }
}
