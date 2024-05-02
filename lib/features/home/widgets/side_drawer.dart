import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:twitter_clone/common/loading_screen.dart';
import 'package:twitter_clone/constants/assets_constants.dart';
import 'package:twitter_clone/core/core.dart';
import 'package:twitter_clone/features/auth/controllers/auth_controller.dart';
import 'package:twitter_clone/features/user_profile/controllers/user_profile_controller.dart';
import 'package:twitter_clone/features/user_profile/view/user_profile_view.dart';
import 'package:twitter_clone/theme/pallete.dart';

class SideDrawer extends ConsumerWidget {
  const SideDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserDetailsProvider).value;
    if (user == null) {
      return const Loader();
    }
    return SafeArea(
      child: Drawer(
        backgroundColor: Pallete.backgroundColor,
        child: Column(
          children: [
            50.hBox,
            ListTile(
              leading: const Icon(
                Icons.person,
                size: 30,
              ),
              title: const Text(
                "My Profile",
                style: TextStyle(
                  fontSize: 22,
                ),
              ),
              onTap: () {
                Navigator.push(context, UserProfileView.route(user));
              },
            ),
            ListTile(
              leading: SvgPicture.asset(AssetsConstants.verifiedIcon),
              title: const Text(
                "Twitter Blue",
                style: TextStyle(
                  fontSize: 22,
                ),
              ),
              onTap: () {
                ref
                    .read(userProfileControllerProvider.notifier)
                    .updateUserProfile(
                        userModel: user.copyWith(isTwitterBlue: true),
                        context: context,
                        bannerImage: null,
                        profileImage: null);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.logout,
                size: 30,
              ),
              title: const Text(
                "Logout",
                style: TextStyle(
                  fontSize: 22,
                ),
              ),
              onTap: () {
                ref.read(authControllerProvider.notifier).logout(context);
              },
            )
          ],
        ),
      ),
    );
  }
}
