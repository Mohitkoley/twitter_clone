import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:twitter_clone/constants/appwrite_constant.dart';
import 'package:twitter_clone/core/core.dart';
import 'package:twitter_clone/core/provider.dart';
import 'package:twitter_clone/model/notification_model.dart';

abstract class INotificationAPI {
  FutureEitherVoid createNotification(NotificationModel notification);
  Future<List<Document>> getNotifications(String userId);
  Stream<RealtimeMessage> getLatestNotification();
}

final notificationAPIProvider = Provider<NotificationAPI>((ref) {
  final databases = ref.watch(appwriteDatabasesProvider);
  final realtime = ref.watch(appwriteRealtimeProvider);
  return NotificationAPI(db: databases, realtime: realtime);
});

class NotificationAPI implements INotificationAPI {
  final Databases _db;
  final Realtime _realtime;
  NotificationAPI({required Databases db, required Realtime realtime})
      : _db = db,
        _realtime = realtime;

  @override
  FutureEitherVoid createNotification(NotificationModel notification) async {
    try {
      _db.createDocument(
        databaseId: AppwriteConstant.databaseId,
        collectionId: AppwriteConstant.notificationCollections,
        documentId: notification.id,
        data: notification.toMap(),
      );
      return right(null);
    } on AppwriteException catch (e, stk) {
      return left(Failure(e.message ?? "some UnExpected Error occured", stk));
    } catch (e, stk) {
      return left(Failure(e.toString(), stk));
    }
  }

  @override
  Future<List<Document>> getNotifications(String userId) async {
    final documentList = await _db.listDocuments(
        databaseId: AppwriteConstant.databaseId,
        collectionId: AppwriteConstant.notificationCollections,
        queries: [
          // Query.equal('uid', userId),
        ]);
    return documentList.documents;
  }

  @override
  Stream<RealtimeMessage> getLatestNotification() {
    return _realtime.subscribe([
      'databases.${AppwriteConstant.databaseId}.collections.${AppwriteConstant.notificationCollections}.documents'
    ]).stream;
  }
}
