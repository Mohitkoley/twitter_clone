import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/common/error_screen.dart';
import 'package:twitter_clone/common/loading_screen.dart';
import 'package:twitter_clone/features/explore/controller/explore_controller.dart';
import 'package:twitter_clone/features/explore/widgets/search_tile_widget.dart';
import 'package:twitter_clone/theme/pallete.dart';

class ExploreViewScreen extends ConsumerStatefulWidget {
  const ExploreViewScreen({super.key});
  static Route get route =>
      MaterialPageRoute<void>(builder: (_) => const ExploreViewScreen());

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ExPloreViewState();
}

class _ExPloreViewState extends ConsumerState<ExploreViewScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool isSearch = false;

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appBarTextFieldBorder = OutlineInputBorder(
      borderSide: const BorderSide(color: Pallete.searchBarColor),
      borderRadius: BorderRadius.circular(50),
    );

    return Scaffold(
        appBar: AppBar(
          title: SizedBox(
            height: 50,
            child: TextField(
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  setState(() {
                    isSearch = true;
                  });
                }
              },
              controller: _searchController,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(10).copyWith(left: 20),
                hintText: 'Search Twitter',
                fillColor: Pallete.searchBarColor,
                filled: true,
                enabledBorder: appBarTextFieldBorder,
                focusedBorder: appBarTextFieldBorder,
              ),
            ),
          ),
        ),
        body: ref.watch(searchUserProvider(_searchController.text)).when(
            data: (userList) {
              return isSearch
                  ? ListView.builder(
                      itemCount: userList.length,
                      itemBuilder: (context, index) {
                        return SearchTile(
                          user: userList[index],
                        );
                      },
                    )
                  : const SizedBox();
            },
            error: (error, stk) => ErrorText(
                  message: error.toString(),
                ),
            loading: () => const Loader()));
  }
}
