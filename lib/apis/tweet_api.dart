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
  final realtime = ref.watch(appwriteRealtimeProvider);
  return TweetApi(db: databases, realtime: realtime);
});

abstract class ITweetAPI {
  FutureEither<Document> shareTweet(Tweet tweet);
  Future<List<Document>> getTweets();
  Stream<RealtimeMessage> getLatestTweet();
  FutureEither<Document> likeTweet(Tweet tweet);
  FutureEither<Document> updateReshareCount(Tweet tweet);
  Future<List<Document>> getRepliesToTweet(Tweet tweet);
  Future<Document> getTweetById(String id);
  Future<List<Document>> getUserTweets(String uid);
  Future<List<Document>> getTweetsByHashTag(String hash);
}

class TweetApi implements ITweetAPI {
  final Databases _db;
  final Realtime _realtime;
  TweetApi({required Databases db, required Realtime realtime})
      : _db = db,
        _realtime = realtime;

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

  @override
  Future<List<Document>> getTweets() async {
    final documentList = await _db.listDocuments(
        databaseId: AppwriteConstant.databaseId,
        collectionId: AppwriteConstant.tweetCollection,
        queries: [
          // Query.orderDesc('tweetedAt'),
        ]);
    return documentList.documents;
  }

  @override
  Stream<RealtimeMessage> getLatestTweet() {
    return _realtime.subscribe([
      'databases.${AppwriteConstant.databaseId}.collections.${AppwriteConstant.tweetCollection}.documents'
    ]).stream;
  }

  @override
  FutureEither<Document> likeTweet(Tweet tweet) async {
    try {
      final document = await _db.updateDocument(
        databaseId: AppwriteConstant.databaseId,
        collectionId: AppwriteConstant.tweetCollection,
        documentId: tweet.id,
        data: tweet.likeMap(),
      );
      return right(document);
    } on AppwriteException catch (e, stk) {
      return left(Failure(e.message ?? "some UnExpected Error occured", stk));
    } catch (e, stk) {
      return left(Failure(e.toString(), stk));
    }
  }

  @override
  FutureEither<Document> updateReshareCount(Tweet tweet) async {
    try {
      final document = await _db.updateDocument(
          databaseId: AppwriteConstant.databaseId,
          collectionId: AppwriteConstant.tweetCollection,
          documentId: tweet.id,
          data: tweet.reshareMap());
      return right(document);
    } on AppwriteException catch (e, stk) {
      return left(Failure(e.message ?? "some UnExpected Error occured", stk));
    } catch (e, stk) {
      return left(Failure(e.toString(), stk));
    }
  }

  @override
  Future<List<Document>> getRepliesToTweet(Tweet tweet) async {
    try {
      final document = await _db.listDocuments(
          databaseId: AppwriteConstant.databaseId,
          collectionId: AppwriteConstant.tweetCollection,
          queries: [Query.equal('repliedTo', tweet.id)]);
      return document.documents;
    } on AppwriteException catch (e, stk) {
      throw Failure(e.message ?? "some UnExpected Error occured", stk);
    } catch (e, stk) {
      throw Failure(e.toString(), stk);
    }
  }

  @override
  Future<Document> getTweetById(String id) {
    return _db.getDocument(
        databaseId: AppwriteConstant.databaseId,
        collectionId: AppwriteConstant.tweetCollection,
        documentId: id);
  }

  @override
  Future<List<Document>> getUserTweets(String uid) async {
    final documents = await _db.listDocuments(
        databaseId: AppwriteConstant.databaseId,
        collectionId: AppwriteConstant.tweetCollection,
        queries: [Query.equal('uid', uid)]);
    return documents.documents;
  }

  @override
  Future<List<Document>> getTweetsByHashTag(String hash) async {
    final documents = await _db.listDocuments(
        databaseId: AppwriteConstant.databaseId,
        collectionId: AppwriteConstant.tweetCollection,
        queries: [
          Query.search('hashTags', hash),
        ]);
    return documents.documents;
  }
}
