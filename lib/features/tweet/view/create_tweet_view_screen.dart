import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:twitter_clone/common/common.dart';
import 'package:twitter_clone/constants/assets_constants.dart';
import 'package:twitter_clone/core/extension.dart';
import 'package:twitter_clone/features/auth/controllers/auth_controller.dart';
import 'package:twitter_clone/features/tweet/controllers/image_picker_controller.dart';
import 'package:twitter_clone/theme/pallete.dart';

class CreateTweetViewScreen extends ConsumerStatefulWidget {
  const CreateTweetViewScreen({super.key});
  static Route get route =>
      MaterialPageRoute<void>(builder: (_) => const CreateTweetViewScreen());
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateTweetViewScreenState();
}

class _CreateTweetViewScreenState extends ConsumerState<CreateTweetViewScreen> {
  TextEditingController descriptionController = TextEditingController();
  List<File> images = [];

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    descriptionController.dispose();
  }

  void pickImages() async {
    List<File> images =
        await ref.read(imagePickerProvider.notifier).pickMultipleImage();
    if (images.isNotEmpty) {
      setState(() {
        this.images = images;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.close,
            color: Pallete.whiteColor,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          RoundedSmallButton(
            label: "Tweet",
            onPressed: () {},
            backgroundColor: Pallete.blueColor,
            textColor: Pallete.whiteColor,
          )
        ],
      ),
      body: SafeArea(
          child: currentUser == null
              ? const Loader()
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          10.wBox,
                          CircleAvatar(
                            backgroundImage: NetworkImage(
                              currentUser.profilePic,
                            ),
                          ),
                          10.wBox,
                          Expanded(
                              child: TextField(
                            controller: descriptionController,
                            decoration: InputDecoration(
                              hintText: "What's happening?",
                              border: InputBorder.none,
                            ),
                            style: TextStyle(
                              color: Pallete.whiteColor,
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: null,
                          ))
                        ],
                      )
                      //Todo: add craousal for images
                    ],
                  ),
                )),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          border: const Border(
              top: BorderSide(color: Pallete.greyColor, width: 0.3)),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0).copyWith(
                left: 15,
                right: 15,
              ),
              child: GestureDetector(
                onTap: pickImages,
                child: SvgPicture.asset(AssetsConstants.galleryIcon),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0).copyWith(
                left: 15,
                right: 15,
              ),
              child: SvgPicture.asset(AssetsConstants.gifIcon),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0).copyWith(
                left: 15,
                right: 15,
              ),
              child: SvgPicture.asset(AssetsConstants.emojiIcon),
            ),
          ],
        ),
      ),
    );
  }
}
