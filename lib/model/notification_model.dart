// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:twitter_clone/core/core.dart';
import 'package:twitter_clone/core/enums/notification_type_enum.dart';

class NotificationModel {
  final String title;
  final String postId;
  final String id;
  final String uid;
  final NotificationType notificationType;

  NotificationModel({
    required this.title,
    required this.postId,
    required this.id,
    required this.uid,
    required this.notificationType,
  });

  NotificationModel copyWith({
    String? title,
    String? postId,
    String? id,
    String? uid,
    String? time,
    NotificationType? notificationType,
  }) {
    return NotificationModel(
      title: title ?? this.title,
      postId: postId ?? this.postId,
      id: id ?? this.id,
      uid: uid ?? this.uid,
      notificationType: notificationType ?? this.notificationType,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'postId': postId,
      'id': id,
      'uid': uid,
      'type': notificationType.type,
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      title: map['title'] ?? "",
      postId: map['postId'] ?? "",
      id: map['\$id'] ?? "",
      uid: map['uid'] ?? "",
      notificationType: map['type'].toString().toNotificationEnum(),
    );
  }

  String toJson() => json.encode(toMap());

  factory NotificationModel.fromJson(String source) =>
      NotificationModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Notification(title: $title, postId: $postId, id: $id, uid: $uid, type: $notificationType)';
  }

  @override
  bool operator ==(covariant NotificationModel other) {
    if (identical(this, other)) return true;

    return other.title == title &&
        other.postId == postId &&
        other.id == id &&
        other.uid == uid &&
        other.notificationType == notificationType;
  }

  @override
  int get hashCode {
    return title.hashCode ^
        postId.hashCode ^
        id.hashCode ^
        uid.hashCode ^
        notificationType.hashCode;
  }
}
