import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/common/error_screen.dart';
import 'package:twitter_clone/constants/appwrite_constant.dart';
import 'package:twitter_clone/features/user_profile/controllers/user_profile_controller.dart';
import 'package:twitter_clone/features/user_profile/widgets/user_profile.dart';
import 'package:twitter_clone/model/user_model.dart';

class UserProfileView extends ConsumerWidget {
  const UserProfileView({super.key, required this.user});
  final UserModel user;

  static Route route(UserModel user) => MaterialPageRoute<void>(
      builder: (_) => UserProfileView(
            user: user,
          ));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    UserModel userCopy = user;
    return Scaffold(
        body: ref.watch(getLatestUserProfileDataProvider).when(
            data: (data) {
              if (data.events.contains(
                  'databases.*.collections.${AppwriteConstant.userCollection}.documents.${userCopy.uid}.update')) {
                userCopy = UserModel.fromMap(data.payload);
              }
              return UserProfile(user: userCopy);
            },
            error: (err, stk) => ErrorText(message: err.toString()),
            loading: () => UserProfile(user: userCopy)));
  }
}
