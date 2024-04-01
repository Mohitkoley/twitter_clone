// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

@immutable
class UserModel {
  final String email;
  final String name;
  final List<String> followers;
  final List<String> following;
  final String bio;
  final String profilePic;
  final String bannerPic;
  final bool isTwitterBlue;
  final String uid;
  const UserModel({
    required this.email,
    required this.name,
    required this.followers,
    required this.following,
    required this.bio,
    required this.profilePic,
    required this.bannerPic,
    required this.isTwitterBlue,
    required this.uid,
  });

  UserModel copyWith({
    String? email,
    String? name,
    List<String>? followers,
    List<String>? following,
    String? bio,
    String? profilePic,
    String? bannerPic,
    bool? isTwitterBlue,
    String? uid,
  }) {
    return UserModel(
      email: email ?? this.email,
      name: name ?? this.name,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      bio: bio ?? this.bio,
      profilePic: profilePic ?? this.profilePic,
      bannerPic: bannerPic ?? this.bannerPic,
      isTwitterBlue: isTwitterBlue ?? this.isTwitterBlue,
      uid: uid ?? this.uid,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'name': name,
      'followers': followers,
      'following': following,
      'bio': bio,
      'profilePic': profilePic,
      'bannerPic': bannerPic,
      'isTwitterBlue': isTwitterBlue,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      email: map['email'] as String,
      name: map['name'] as String,
      followers: List<String>.from((map['followers'])),
      following: List<String>.from((map['following'])),
      bio: map['bio'] as String,
      profilePic: map['profilePic'] as String,
      bannerPic: map['bannerPic'] as String,
      isTwitterBlue: map['isTwitterBlue'] as bool,
      uid: map['\$id'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(email: $email, name: $name, followers: $followers, following: $following, bio: $bio, profilePic: $profilePic, bannerPic: $bannerPic, isTwitterBlue: $isTwitterBlue, uid: $uid)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.email == email &&
        other.name == name &&
        listEquals(other.followers, followers) &&
        listEquals(other.following, following) &&
        other.bio == bio &&
        other.profilePic == profilePic &&
        other.bannerPic == bannerPic &&
        other.isTwitterBlue == isTwitterBlue &&
        other.uid == uid;
  }

  @override
  int get hashCode {
    return email.hashCode ^
        name.hashCode ^
        followers.hashCode ^
        following.hashCode ^
        bio.hashCode ^
        profilePic.hashCode ^
        bannerPic.hashCode ^
        isTwitterBlue.hashCode ^
        uid.hashCode;
  }
}
