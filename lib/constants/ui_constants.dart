import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:twitter_clone/constants/assets_constants.dart';
import 'package:twitter_clone/features/explore/view/explore_view.dart';
import 'package:twitter_clone/features/notifications/view/notification_view.dart';
import 'package:twitter_clone/features/tweet/widgets/tweet_list.dart';
import 'package:twitter_clone/theme/theme.dart';

class UIConstants {
  static AppBar appBar = AppBar(
    title: SvgPicture.asset(
      AssetsConstants.twitterLogo,
      colorFilter: const ColorFilter.mode(Pallete.blueColor, BlendMode.srcIn),
      width: 40,
      height: 40,
    ),
    centerTitle: true,
  );

  static const List<Widget> bottomTabBarScreens = [
    TweetList(),
    ExploreViewScreen(),
    NotificationViewScreen(),
  ];

  static List<BottomNavigationBarItem> bottomTabBarItems(int index) {
    return [
      BottomNavigationBarItem(
        icon: SvgPicture.asset(
            index == 0
                ? AssetsConstants.homeFilledIcon
                : AssetsConstants.homeOutlinedIcon,
            colorFilter:
                const ColorFilter.mode(Pallete.whiteColor, BlendMode.srcIn)),
      ),
      BottomNavigationBarItem(
        icon: SvgPicture.asset(AssetsConstants.searchIcon,
            colorFilter:
                const ColorFilter.mode(Pallete.whiteColor, BlendMode.srcIn)),
      ),
      BottomNavigationBarItem(
        icon: SvgPicture.asset(
            index == 2
                ? AssetsConstants.notifFilledIcon
                : AssetsConstants.notifOutlinedIcon,
            colorFilter:
                const ColorFilter.mode(Pallete.whiteColor, BlendMode.srcIn)),
      ),
    ];
  }
}
