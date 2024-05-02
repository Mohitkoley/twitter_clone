import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:twitter_clone/common/common.dart';
import 'package:twitter_clone/constants/assets_constants.dart';
import 'package:twitter_clone/core/extension.dart';
import 'package:twitter_clone/features/auth/controllers/auth_controller.dart';
import 'package:twitter_clone/common/controllers/image_picker_controller.dart';
import 'package:twitter_clone/features/tweet/controllers/tweet_controller.dart';
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

  void shareTweet() {
    final description = descriptionController.text;
    ref.read(tweetControllerProvider.notifier).shareTweet(
        images: images,
        description: description,
        repliedTo: "",
        repliedToUserId: "",
        context: context);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;
    final isLoading = ref.watch(tweetControllerProvider);

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
            onPressed: shareTweet,
            backgroundColor: Pallete.blueColor,
            textColor: Pallete.whiteColor,
          )
        ],
      ),
      body: SafeArea(
          child: isLoading || currentUser == null
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
                      ),
                      //Todo: add craousal for images
                      if (images.isNotEmpty)
                        FlutterCarousel(
                          items: images
                              .map((file) => Container(
                                    width: context.width,
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 5,
                                    ),
                                    child: Image.file(file),
                                  ))
                              .toList(),
                          options: CarouselOptions(
                            height: 400,
                            enableInfiniteScroll: false,
                          ),
                        )
                    ],
                  ),
                )),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(bottom: 10),
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Pallete.greyColor, width: 0.3)),
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
