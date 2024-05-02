import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/common/error_screen.dart';
import 'package:twitter_clone/common/loading_screen.dart';
import 'package:twitter_clone/constants/appwrite_constant.dart';
import 'package:twitter_clone/features/auth/controllers/auth_controller.dart';
import 'package:twitter_clone/features/notifications/controllers/notification_controller.dart';
import 'package:twitter_clone/features/notifications/widgets/notification_tile.dart';
import 'package:twitter_clone/model/notification_model.dart';

class NotificationViewScreen extends ConsumerWidget {
  const NotificationViewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: currentUser == null
          ? const Loader()
          : ref.watch(getNotificationsProvider(currentUser.uid)).when(
              data: (notifications) {
                return ref.watch(getLatestNotificationProvider).when(
                    data: (data) {
                      if (data.events.contains(
                          'databases.*.collections.${AppwriteConstant.notificationCollections}.documents.*.create')) {
                        final latestNotificationData =
                            NotificationModel.fromMap(data.payload);
                        if (latestNotificationData.uid == currentUser.uid) {
                          notifications.insert(
                              0, NotificationModel.fromMap(data.payload));
                        }
                      }

                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: notifications.length,
                          itemBuilder: (context, index) {
                            NotificationModel notification =
                                notifications[index];
                            return NotificationTile(
                              notification: notification,
                            );
                          });
                    },
                    error: (error, stackTrace) => ErrorText(
                          message: error.toString(),
                        ),
                    loading: () => ListView.builder(
                        shrinkWrap: true,
                        itemCount: notifications.length,
                        itemBuilder: (context, index) {
                          NotificationModel notification = notifications[index];
                          return NotificationTile(
                            notification: notification,
                          );
                        }));
              },
              error: (error, stackTrace) => ErrorText(
                    message: error.toString(),
                  ),
              loading: () => const Loader()),
    );
  }
}
