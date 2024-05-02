// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:twitter_clone/constants/constants.dart';
import 'package:twitter_clone/core/enums/notification_type_enum.dart';
import 'package:twitter_clone/model/notification_model.dart';
import 'package:twitter_clone/theme/pallete.dart';

class NotificationTile extends StatelessWidget {
  const NotificationTile({
    super.key,
    required this.notification,
  });
  final NotificationModel notification;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: switch (notification.notificationType) {
        NotificationType.like => SvgPicture.asset(
            AssetsConstants.likeFilledIcon,
            height: 20,
            colorFilter: const ColorFilter.mode(
              Pallete.redColor,
              BlendMode.srcIn,
            ),
          ),
        NotificationType.reply => null,
        NotificationType.follow => Icon(Icons.person, color: Pallete.blueColor),
        NotificationType.reTweet => SvgPicture.asset(
            AssetsConstants.retweetIcon,
            height: 20,
            colorFilter: const ColorFilter.mode(
              Pallete.whiteColor,
              BlendMode.srcIn,
            ),
          ),
      },
      title: Text(notification.title),
    );
  }
}
