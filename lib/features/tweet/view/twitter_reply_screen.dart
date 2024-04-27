import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/common/error_screen.dart';
import 'package:twitter_clone/common/loading_screen.dart';
import 'package:twitter_clone/constants/appwrite_constant.dart';
import 'package:twitter_clone/features/tweet/controllers/tweet_controller.dart';
import 'package:twitter_clone/features/tweet/widgets/tweet_card.dart';
import 'package:twitter_clone/model/tweet_model.dart';
import 'package:twitter_clone/theme/pallete.dart';

class TwitterReplyScreen extends ConsumerWidget {
  const TwitterReplyScreen({super.key, required this.tweet});
  final Tweet tweet;
  static Route route(Tweet tweet) => MaterialPageRoute<void>(
      builder: (_) => TwitterReplyScreen(
            tweet: tweet,
          ));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TweetCard(tweet: tweet),
            ref.watch(getRepliesToTweetProvider(tweet)).when(
                data: (tweets) {
                  return ref.watch(getLatestTweetProvider).when(
                      data: (data) {
                        final latestTweetData = Tweet.fromMap(data.payload);
                        bool isTweetAlreadyPresent = false;

                        for (final tweetModel in tweets) {
                          if (tweetModel.id == latestTweetData.id) {
                            isTweetAlreadyPresent = true;
                            break;
                          }
                        }

                        if (!isTweetAlreadyPresent &&
                            latestTweetData.repliedTo == tweet.id) {
                          if (data.events.contains(
                              'databases.*.collections.${AppwriteConstant.tweetCollection}.documents.*.create')) {
                            tweets.insert(0, Tweet.fromMap(data.payload));
                          } else if (data.events.contains(
                              'databases.*.collections.${AppwriteConstant.tweetCollection}.documents.*.update')) {
                            debugPrint(data.events[0]);
                            final startingPoint =
                                data.events[0].lastIndexOf('documents.');
                            final endPoint =
                                data.events[0].lastIndexOf('.update');
                            final tweetId = data.events[0]
                                .substring(startingPoint + 10, endPoint);
                            Tweet tweet = tweets
                                .firstWhere((element) => element.id == tweetId);
                            int index = tweets.indexOf(tweet);
                            tweets.removeWhere(
                                (element) => element.id == tweetId);
                            tweet = Tweet.fromMap(data.payload);
                            tweets.insert(index, tweet);
                            // tweets[index] = tweet.copyWith(
                            //     reshareCount: data.payload['reshareCount']);
                          }

                          return Expanded(
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: tweets.length,
                                  itemBuilder: (context, index) {
                                    Tweet tweet = tweets[index];
                                    return TweetCard(tweet: tweet);
                                  }));
                        }
                        return Expanded(
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: tweets.length,
                                itemBuilder: (context, index) {
                                  Tweet tweet = tweets[index];
                                  return TweetCard(tweet: tweet);
                                }));
                      },
                      error: (error, stackTrace) => Error(
                            message: error.toString(),
                          ),
                      loading: () => Expanded(
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: tweets.length,
                              itemBuilder: (context, index) {
                                Tweet tweet = tweets[index];
                                return TweetCard(tweet: tweet);
                              })));
                },
                error: (error, stackTrace) => Error(
                      message: error.toString(),
                    ),
                loading: () => const Loader()),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Pallete.backgroundColor,
        child: TextField(
          onSubmitted: (value) {
            ref.read(tweetControllerProvider.notifier).shareTweet(
              [],
              value,
              tweet.id,
              tweet.uid,
              context,
            );
          },
          decoration: InputDecoration(
            hintText: 'Tweet your reply',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
      ),
    );
  }
}
