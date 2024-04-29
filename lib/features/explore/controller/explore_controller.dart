import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/apis/user_api.dart';
import 'package:twitter_clone/model/user_model.dart';

final exploreControllerProvider =
    StateNotifierProvider<ExploreController, bool>(
  (ref) {
    final userAPI = ref.watch(userAPIProvider);
    return ExploreController(userAPI: userAPI);
  },
);

final searchUserProvider =
    FutureProvider.autoDispose.family<List<UserModel>, String>(
  (ref, name) async {
    final controller = ref.read(exploreControllerProvider.notifier);
    return controller.searchUser(name: name);
  },
);

class ExploreController extends StateNotifier<bool> {
  final UserAPI _userAPI;
  ExploreController({
    required UserAPI userAPI,
  })  : _userAPI = userAPI,
        super(false);

  Future<List<UserModel>> searchUser({required String name}) async {
    final users = await _userAPI.searchUserByName(name);
    return users.map((e) => UserModel.fromMap(e.data)).toList();
  }
}
