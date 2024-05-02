import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/apis/notification_api.dart';
import 'package:twitter_clone/core/enums/notification_type_enum.dart';
import 'package:twitter_clone/core/provider.dart';
import 'package:twitter_clone/model/notification_model.dart';

final notificationControllerProvider =
    StateNotifierProvider<NotificationController, bool>((ref) {
  final notificationAPI = ref.watch(notificationAPIProvider);

  return NotificationController(notificationAPI: notificationAPI);
});

final getLatestNotificationProvider = StreamProvider.autoDispose((ref) {
  final notificationAPI = ref.watch(notificationAPIProvider);
  return notificationAPI.getLatestNotification();
});

final getNotificationsProvider =
    FutureProvider.family<List<NotificationModel>, String>((ref, userId) async {
  final notificationController =
      ref.watch(notificationControllerProvider.notifier);
  return await notificationController.getNotifications(userId);
});

class NotificationController extends StateNotifier<bool> {
  final NotificationAPI _notificationAPI;

  NotificationController({required NotificationAPI notificationAPI})
      : _notificationAPI = notificationAPI,
        super(false);

  Future<void> createNotification({
    required String text,
    required String postId,
    required NotificationType notificationType,
    required String uid,
  }) async {
    final notification = NotificationModel(
        title: text,
        postId: postId,
        id: ID.unique(),
        uid: uid,
        notificationType: notificationType);
    final res = await _notificationAPI.createNotification(notification);
    res.fold((l) => null, (r) => null);
  }

  Future<List<NotificationModel>> getNotifications(String userId) async {
    final List notificationList =
        await _notificationAPI.getNotifications(userId);
    return notificationList
        .map((tweet) => NotificationModel.fromMap(tweet.data))
        .toList();
  }
}
