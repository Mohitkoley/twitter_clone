import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:like_button/like_button.dart';
import 'package:twitter_clone/common/error_screen.dart';
import 'package:twitter_clone/common/loading_screen.dart';
import 'package:twitter_clone/constants/assets_constants.dart';
import 'package:twitter_clone/core/enums/tweet_type.dart';
import 'package:twitter_clone/core/extension.dart';
import 'package:twitter_clone/features/auth/controllers/auth_controller.dart';
import 'package:twitter_clone/features/tweet/controllers/tweet_controller.dart';
import 'package:twitter_clone/features/tweet/view/twitter_reply_screen.dart';
import 'package:twitter_clone/features/tweet/widgets/carousel_image.dart';
import 'package:twitter_clone/features/tweet/widgets/hashtag_text.dart';
import 'package:twitter_clone/features/tweet/widgets/tweet_icon_widget.dart';
import 'package:twitter_clone/features/user_profile/view/user_profile_view.dart';
import 'package:twitter_clone/model/tweet_model.dart';
import 'package:twitter_clone/theme/pallete.dart';
import 'package:timeago/timeago.dart' as timeago;

class TweetCard extends ConsumerWidget {
  final Tweet tweet;
  const TweetCard({super.key, required this.tweet});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;

    return currentUser == null
        ? const SizedBox()
        : ref.watch(userDetailsProvider(tweet.uid)).when(
            data: (user) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(context, TwitterReplyScreen.route(tweet));
                },
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(10),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context, UserProfileView.route(user));
                            },
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(user.profilePic),
                              radius: 35,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (tweet.reTweetedBy.isNotEmpty)
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                      AssetsConstants.retweetIcon,
                                      width: 20,
                                      height: 20,
                                      colorFilter: const ColorFilter.mode(
                                        Pallete.greyColor,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                    2.wBox,
                                    Text("${tweet.reTweetedBy} retweeted",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17,
                                            color: Pallete.greyColor)),
                                  ],
                                ),
                              Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                        right:
                                            currentUser.isTwitterBlue ? 1 : 5),
                                    child: Text(
                                      user.name,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                  ),
                                  if (currentUser.isTwitterBlue)
                                    Padding(
                                        padding:
                                            const EdgeInsets.only(right: 5),
                                        child: SvgPicture.asset(
                                            AssetsConstants.verifiedIcon,
                                            width: 20,
                                            height: 20,
                                            colorFilter: const ColorFilter.mode(
                                                Pallete.blueColor,
                                                BlendMode.srcIn))),
                                  Text(
                                      '@${user.name} . ${timeago.format(tweet.tweetedAt, locale: 'en_short')}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17,
                                          color: Pallete.greyColor)),
                                ],
                              ),
                              if (tweet.repliedTo.isNotEmpty)
                                ref
                                    .watch(
                                        getTweetByIdProvider(tweet.repliedTo))
                                    .when(
                                        data: (tweet) {
                                          final user = ref
                                              .watch(userDetailsProvider(
                                                  tweet.uid))
                                              .value;
                                          return RichText(
                                              text: TextSpan(
                                                  text: 'Replying to ',
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      color: Pallete.greyColor),
                                                  children: [
                                                TextSpan(
                                                  text: ' @${user?.name} to ',
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      color: Pallete.blueColor),
                                                )
                                              ]));
                                        },
                                        error: (err, stk) {
                                          return ErrorText(
                                            message: err.toString(),
                                          );
                                        },
                                        loading: () => SizedBox()),
                              HashTagText(text: tweet.text),
                              if (tweet.tweetType == TweetType.image)
                                CarouselImage(images: tweet.imageLinks),
                              if (tweet.link.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                AnyLinkPreview(
                                  displayDirection:
                                      UIDirection.uiDirectionHorizontal,
                                  link: 'https://${tweet.link}',
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.only(top: 10, right: 20),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        TweetIconButton(
                                            pathName:
                                                AssetsConstants.commentIcon,
                                            text: (tweet.commentIds.length +
                                                    tweet.reshareCount +
                                                    tweet.likes.length)
                                                .toString(),
                                            onTap: () {}),
                                        TweetIconButton(
                                            pathName: AssetsConstants.viewsIcon,
                                            text: (tweet.commentIds.length)
                                                .toString(),
                                            onTap: () {}),
                                        TweetIconButton(
                                            pathName:
                                                AssetsConstants.retweetIcon,
                                            text:
                                                (tweet.reshareCount).toString(),
                                            onTap: () {
                                              ref
                                                  .read(tweetControllerProvider
                                                      .notifier)
                                                  .reshareTweet(tweet,
                                                      currentUser, context);
                                            }),
                                        LikeButton(
                                          size: 25,
                                          isLiked: tweet.likes
                                              .contains(currentUser.uid),
                                          onTap: (isLiked) async {
                                            ref
                                                .read(tweetControllerProvider
                                                    .notifier)
                                                .likeTweet(tweet, currentUser);
                                            return !isLiked;
                                          },
                                          countBuilder:
                                              (likeCount, isLiked, text) {
                                            return Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5),
                                                child: Text(
                                                    likeCount.toString(),
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        color: Pallete
                                                            .greyColor)));
                                          },
                                          likeBuilder: (isLiked) {
                                            return isLiked
                                                ? SvgPicture.asset(
                                                    AssetsConstants
                                                        .likeFilledIcon,
                                                    colorFilter:
                                                        const ColorFilter.mode(
                                                      Pallete.redColor,
                                                      BlendMode.srcIn,
                                                    ))
                                                : SvgPicture.asset(
                                                    AssetsConstants
                                                        .likeOutlinedIcon,
                                                    colorFilter:
                                                        const ColorFilter.mode(
                                                      Pallete.greyColor,
                                                      BlendMode.srcIn,
                                                    ));
                                          },
                                          likeCount: tweet.likes.length,
                                        ),
                                        IconButton(
                                          onPressed: () {},
                                          icon: const Icon(
                                            Icons.share_outlined,
                                            size: 25,
                                          ),
                                          color: Pallete.greyColor,
                                        )
                                      ]),
                                ),
                                const SizedBox(
                                  height: 1,
                                )
                              ],
                            ],
                          ),
                        )
                      ],
                    ),
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: Pallete.greyColor,
                    )
                  ],
                ),
              );
            },
            error: (error, stackTrace) {
              return ErrorScreen(message: error.toString());
            },
            loading: () => const Loader());
  }
}
