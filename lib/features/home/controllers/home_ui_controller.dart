import 'package:flutter_riverpod/flutter_riverpod.dart';

final bottomBarProvider =
    StateNotifierProvider<BottomBarState, int>((ref) => BottomBarState());

class BottomBarState extends StateNotifier<int> {
  BottomBarState() : super(0);

  void changeIndex(int index) {
    state = index;
  }
}
