import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/apis/tweet_api.dart';
import 'package:twitter_clone/model/tweet_model.dart';

final userProfileControllerProvider =
    StateNotifierProvider<UserProfileController, bool>(
  (ref) {
    final tweetAPI = ref.watch(tweetAPIProvider);
    return UserProfileController(tweetAPI: tweetAPI);
  },
);

final getUsersTweetsProvider =
    FutureProvider.autoDispose.family<List<Tweet>, String>(
  (ref, uid) async {
    final controller = ref.read(userProfileControllerProvider.notifier);
    return controller.getUsersTweet(uid: uid);
  },
);

class UserProfileController extends StateNotifier<bool> {
  final TweetApi _tweetAPI;
  UserProfileController({
    required TweetApi tweetAPI,
  })  : _tweetAPI = tweetAPI,
        super(false);

  Future<List<Tweet>> getUsersTweet({required String uid}) async {
    final tweet = await _tweetAPI.getUserTweets(uid);
    return tweet.map((e) => Tweet.fromMap(e.data)).toList();
  }
}
