import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/constants/constants.dart';
import 'package:twitter_clone/features/home/controllers/home_ui_controller.dart';
import 'package:twitter_clone/features/home/widgets/side_drawer.dart';
import 'package:twitter_clone/features/tweet/view/create_tweet_view_screen.dart';
import 'package:twitter_clone/routes/transition/custom_transition.dart';
import 'package:twitter_clone/theme/pallete.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});
  static Route get route =>
      MaterialPageRoute<void>(builder: (_) => const HomeScreen());

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final appBar = UIConstants.appBar;

  void onCreateTween() {
    Navigator.of(context).push(CustomTransition(
      child: const CreateTweetViewScreen(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final bottomBarIndex = ref.watch(bottomBarProvider);
    return Scaffold(
      appBar: bottomBarIndex == 0 ? appBar : null,
      body: IndexedStack(
        index: bottomBarIndex,
        children: UIConstants.bottomTabBarScreens,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onCreateTween,
        shape: const CircleBorder(),
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 28,
        ),
      ),
      drawerScrimColor: Colors.transparent,
      drawer: SideDrawer(),
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: Pallete.backgroundColor,
        currentIndex: bottomBarIndex,
        onTap: ref.read(bottomBarProvider.notifier).changeIndex,
        items: UIConstants.bottomTabBarItems(bottomBarIndex),
      ),
    );
  }
}
