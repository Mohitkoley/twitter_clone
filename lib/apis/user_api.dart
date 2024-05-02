import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:twitter_clone/constants/appwrite_constant.dart';
import 'package:twitter_clone/core/core.dart';
import 'package:twitter_clone/core/provider.dart';
import 'package:twitter_clone/model/user_model.dart';

abstract class IUserAPI {
  FutureEitherVoid saveUserData(UserModel userModel);
  Future<Document> getUserData(String userId);
  Future<List<Document>> searchUserByName(String name);
  FutureEitherVoid updateUserData(UserModel userModel);
  Stream<RealtimeMessage> getLatestUserProfileData();
  FutureEitherVoid followUser(UserModel userModel);
  FutureEitherVoid addToFollowing(UserModel userModel);
}

final userAPIProvider = Provider<UserAPI>((ref) {
  final databases = ref.watch(appwriteDatabasesProvider);
  final realtime = ref.watch(appwriteRealtimeProvider);
  return UserAPI(databases: databases, realtime: realtime);
});

class UserAPI implements IUserAPI {
  final Databases _db;
  final Realtime _realtime;
  UserAPI({required Databases databases, required Realtime realtime})
      : _db = databases,
        _realtime = realtime;

  @override
  FutureEitherVoid saveUserData(UserModel userModel) async {
    try {
      _db.createDocument(
          databaseId: AppwriteConstant.databaseId,
          collectionId: AppwriteConstant.userCollection,
          documentId: userModel.uid,
          data: userModel.toMap());
      return right(null);
    } on AppwriteException catch (e, stk) {
      return left(Failure(e.message ?? "some UnExpected Error occured", stk));
    } catch (e, stk) {
      return left(Failure(e.toString(), stk));
    }
  }

  @override
  Future<Document> getUserData(String userId) async {
    return await _db.getDocument(
        databaseId: AppwriteConstant.databaseId,
        collectionId: AppwriteConstant.userCollection,
        documentId: userId);
  }

  @override
  Future<List<Document>> searchUserByName(String name) async {
    final documents = await _db.listDocuments(
        databaseId: AppwriteConstant.databaseId,
        collectionId: AppwriteConstant.userCollection,
        queries: [
          //Query.search('name', name),
        ]);
    return documents.documents;
  }

  @override
  FutureEitherVoid updateUserData(UserModel userModel) async {
    try {
      _db.updateDocument(
          databaseId: AppwriteConstant.databaseId,
          collectionId: AppwriteConstant.userCollection,
          documentId: userModel.uid,
          data: userModel.toMap());
      return right(null);
    } on AppwriteException catch (e, stk) {
      return left(Failure(e.message ?? "some UnExpected Error occured", stk));
    } catch (e, stk) {
      return left(Failure(e.toString(), stk));
    }
  }

  @override
  Stream<RealtimeMessage> getLatestUserProfileData() {
    return _realtime.subscribe([
      'databases.${AppwriteConstant.databaseId}.collections.${AppwriteConstant.userCollection}.documents'
    ]).stream;
  }

  @override
  FutureEitherVoid followUser(UserModel userModel) async {
    try {
      await _db.updateDocument(
          databaseId: AppwriteConstant.databaseId,
          collectionId: AppwriteConstant.userCollection,
          documentId: userModel.uid,
          data: {
            'followers': userModel.followers,
          });
      return right(null);
    } on AppwriteException catch (e, stk) {
      return left(Failure(e.message ?? "some UnExpected Error occured", stk));
    } catch (e, stk) {
      return left(Failure(e.toString(), stk));
    }
  }

  @override
  FutureEitherVoid addToFollowing(UserModel userModel) async {
    try {
      await _db.updateDocument(
          databaseId: AppwriteConstant.databaseId,
          collectionId: AppwriteConstant.userCollection,
          documentId: userModel.uid,
          data: {
            'following': userModel.following,
          });
      return right(null);
    } on AppwriteException catch (e, stk) {
      return left(Failure(e.message ?? "some UnExpected Error occured", stk));
    } catch (e, stk) {
      return left(Failure(e.toString(), stk));
    }
  }
}
