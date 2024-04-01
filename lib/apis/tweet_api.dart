import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:twitter_clone/constants/appwrite_constant.dart';
import 'package:twitter_clone/core/failure.dart';
import 'package:twitter_clone/core/provider.dart';
import 'package:twitter_clone/core/type_defs.dart';
import 'package:twitter_clone/model/tweet_model.dart';

final tweetAPIProvider = Provider<TweetApi>((ref) {
  final databases = ref.watch(appwriteDatabasesProvider);
  return TweetApi(db: databases);
});

abstract class ITweetAPI {
  FutureEither<Document> shareTweet(Tweet tweet);
}

class TweetApi implements ITweetAPI {
  final Databases _db;
  TweetApi({required Databases db}) : _db = db;

  @override
  FutureEither<Document> shareTweet(Tweet tweet) async {
    try {
      final document = await _db.createDocument(
          databaseId: AppwriteConstant.databaseId,
          collectionId: AppwriteConstant.tweetCollection,
          documentId: tweet.id,
          data: tweet.toMap());
      return right(document);
    } on AppwriteException catch (e, stk) {
      return left(Failure(e.message ?? "some UnExpected Error occured", stk));
    } catch (e, stk) {
      return left(Failure(e.toString(), stk));
    }
  }
}
