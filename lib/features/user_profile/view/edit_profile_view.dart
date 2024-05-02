import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_rename/package_rename.dart';
import 'package:twitter_clone/common/loading_screen.dart';
import 'package:twitter_clone/core/extension.dart';
import 'package:twitter_clone/features/auth/controllers/auth_controller.dart';
import 'package:twitter_clone/common/controllers/image_picker_controller.dart';
import 'package:twitter_clone/features/user_profile/controllers/user_profile_controller.dart';
import 'package:twitter_clone/theme/pallete.dart';

class EditProfileView extends ConsumerStatefulWidget {
  const EditProfileView({super.key});

  static Route get route =>
      MaterialPageRoute(builder: (context) => const EditProfileView());

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditProfileViewState();
}

class _EditProfileViewState extends ConsumerState<EditProfileView> {
  late TextEditingController nameController;
  late TextEditingController bioController;
  File? bannerFile;
  File? profileFile;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameController.dispose();
    bioController.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController = TextEditingController(
        text: ref.read(currentUserDetailsProvider).value?.name ?? "");
    bioController = TextEditingController(
        text: ref.read(currentUserDetailsProvider).value?.bio ?? "");
  }

  void selectBannerImage() async {
    final banner = await ref.read(imagePickerProvider.notifier).pickImage();
    if (banner != null) {
      bannerFile = banner;
      setState(() {});
    }
  }

  void selectProfileImage() async {
    final profile = await ref.read(imagePickerProvider.notifier).pickImage();
    if (profile != null) {
      profileFile = profile;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserDetailsProvider).value;
    bool isLoading = ref.watch(userProfileControllerProvider);
    return Scaffold(
        appBar: AppBar(
          title: const Text("Edit Profile"),
          actions: [
            TextButton(
                onPressed: () {
                  ref
                      .read(userProfileControllerProvider.notifier)
                      .updateUserProfile(
                          userModel: user!.copyWith(
                            bio: bioController.text,
                            name: nameController.text,
                          ),
                          context: context,
                          bannerImage: bannerFile,
                          profileImage: profileFile);
                },
                child: const Text("Save"))
          ],
        ),
        body: user == null || isLoading
            ? const Loader()
            : Column(
                children: [
                  SizedBox(
                    height: 200,
                    child: Stack(
                      children: [
                        GestureDetector(
                          onTap: selectBannerImage,
                          child: Container(
                              height: 150,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10)),
                              child: bannerFile != null
                                  ? Image.file(
                                      bannerFile!,
                                      fit: BoxFit.fitWidth,
                                    )
                                  : user.bannerPic.isEmpty
                                      ? Container(
                                          color: Pallete.blueColor,
                                        )
                                      : Image.network(user.profilePic,
                                          fit: BoxFit.fitWidth)),
                        ),
                        GestureDetector(
                            onTap: selectProfileImage,
                            child: Positioned(
                                bottom: 20,
                                left: 20,
                                child: profileFile != null
                                    ? CircleAvatar(
                                        radius: 40,
                                        backgroundImage:
                                            FileImage(profileFile!),
                                      )
                                    : CircleAvatar(
                                        radius: 40,
                                        backgroundImage:
                                            NetworkImage(user.profilePic),
                                      )))
                      ],
                    ),
                  ),
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                        hintText: "Name", contentPadding: EdgeInsets.all(10)),
                  ),
                  20.hBox,
                  TextField(
                    controller: bioController,
                    decoration: const InputDecoration(
                        hintText: "Bio", contentPadding: EdgeInsets.all(10)),
                    maxLines: 4,
                  ),
                ],
              ));
  }
}
