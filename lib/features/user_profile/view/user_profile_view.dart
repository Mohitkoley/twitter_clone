import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    return Scaffold();
  }
}
