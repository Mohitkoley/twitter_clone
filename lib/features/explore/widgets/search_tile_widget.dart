import 'package:flutter/material.dart';
import 'package:twitter_clone/features/user_profile/view/user_profile_view.dart';
import 'package:twitter_clone/model/user_model.dart';

class SearchTile extends StatelessWidget {
  const SearchTile({super.key, required this.user});
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        onTap: () {
          Navigator.push(context, UserProfileView.route(user));
        },
        leading: CircleAvatar(
          backgroundImage: NetworkImage(user.bannerPic),
          radius: 30,
        ),
        subtitle: Column(
          children: [
            Text("@${user.name}",
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            Text(user.bio,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey)),
          ],
        ));
  }
}
