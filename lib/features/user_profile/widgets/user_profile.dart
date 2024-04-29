import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/common/error_screen.dart';
import 'package:twitter_clone/common/loading_screen.dart';
import 'package:twitter_clone/constants/appwrite_constant.dart';
import 'package:twitter_clone/core/extension.dart';
import 'package:twitter_clone/features/auth/controllers/auth_controller.dart';
import 'package:twitter_clone/features/tweet/controllers/tweet_controller.dart';
import 'package:twitter_clone/features/tweet/widgets/tweet_card.dart';
import 'package:twitter_clone/features/user_profile/controllers/user_profile_controller.dart';
import 'package:twitter_clone/features/user_profile/view/edit_profile_view.dart';
import 'package:twitter_clone/features/user_profile/widgets/follow_count.dart';
import 'package:twitter_clone/model/tweet_model.dart';
import 'package:twitter_clone/model/user_model.dart';
import 'package:twitter_clone/theme/pallete.dart';

class UserProfile extends ConsumerWidget {
  const UserProfile({super.key, required this.user});
  final UserModel user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;

    return currentUser == null
        ? const Loader()
        : NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  expandedHeight: 150,
                  floating: true,
                  snap: true,
                  flexibleSpace: Stack(
                    children: [
                      Positioned.fill(
                          child: user.bannerPic.isEmpty
                              ? const ColoredBox(color: Pallete.blueColor)
                              : Image.network(user.bannerPic,
                                  fit: BoxFit.fitWidth)),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Positioned(
                          bottom: 0,
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(
                              user.profilePic,
                            ),
                            radius: 20,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.bottomRight,
                        margin: const EdgeInsets.all(20),
                        child: OutlinedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Pallete.blueColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25),
                            ),
                            onPressed: () {
                              currentUser.uid == user.uid
                                  ? Navigator.push(
                                      context, EditProfileView.route)
                                  : null;
                            },
                            child: Text(
                                currentUser.uid == user.uid
                                    ? 'Edit Profile'
                                    : 'Follow',
                                style: TextStyle(
                                  color: Pallete.whiteColor,
                                ))),
                      )
                    ],
                  ),
                ),
                SliverPadding(
                    padding: const EdgeInsets.all(8),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        Text(user.name,
                            style: const TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold)),
                        Text("@${user.name}",
                            style: const TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold)),
                        Text("@${user.bio}",
                            style: const TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            FollowCount(
                                count: user.following.length - 1,
                                text: "Following"),
                            15.wBox,
                            FollowCount(
                                count: user.followers.length - 1,
                                text: "Followers"),
                          ],
                        ),
                        5.hBox,
                        const Divider(
                          color: Pallete.whiteColor,
                        )
                      ]),
                    )),
              ];
            },
            body: ref.watch(getUsersTweetsProvider(user.uid)).when(
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
                          final endPoint =
                              data.events[0].lastIndexOf('.update');
                          final tweetId = data.events[0]
                              .substring(startingPoint + 10, endPoint);
                          Tweet tweet = tweets
                              .firstWhere((element) => element.id == tweetId);
                          int index = tweets.indexOf(tweet);
                          tweets
                              .removeWhere((element) => element.id == tweetId);
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
                loading: () => const Loader(),
                error: (error, _) => ErrorText(
                      message: error.toString(),
                    )));
  }
}
