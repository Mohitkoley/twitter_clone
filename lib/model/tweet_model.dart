import 'package:flutter/foundation.dart';

import 'package:twitter_clone/core/enums/tweet_type.dart';
import 'package:twitter_clone/core/extension.dart';

@immutable
class Tweet {
  final String text;
  final List<String> hashTags;
  final String link;
  final List<String> imageLinks;
  final String uid;
  final TweetType tweetType;
  final DateTime tweetedAt;
  final List<String> likes;
  final List<String> commentIds;
  final String id;
  final int reshareCount;
  final String reTweetedBy;
  final String repliedTo;
  final String repliedToUserId;
  const Tweet({
    required this.text,
    required this.hashTags,
    required this.link,
    required this.imageLinks,
    required this.uid,
    required this.tweetType,
    required this.tweetedAt,
    required this.likes,
    required this.commentIds,
    required this.id,
    required this.reshareCount,
    required this.reTweetedBy,
    required this.repliedTo,
    required this.repliedToUserId,
  });

  Tweet copyWith({
    String? text,
    List<String>? hashTags,
    String? link,
    List<String>? imageLinks,
    String? uid,
    TweetType? tweetType,
    DateTime? tweetedAt,
    List<String>? likes,
    List<String>? commentIds,
    String? id,
    int? reshareCount,
    String? reTweetedBy,
    String? repliedTo,
    String? repliedToUserId,
  }) {
    return Tweet(
      text: text ?? this.text,
      hashTags: hashTags ?? this.hashTags,
      link: link ?? this.link,
      imageLinks: imageLinks ?? this.imageLinks,
      uid: uid ?? this.uid,
      tweetType: tweetType ?? this.tweetType,
      tweetedAt: tweetedAt ?? this.tweetedAt,
      likes: likes ?? this.likes,
      commentIds: commentIds ?? this.commentIds,
      id: id ?? this.id,
      reshareCount: reshareCount ?? this.reshareCount,
      reTweetedBy: reTweetedBy ?? this.reTweetedBy,
      repliedTo: repliedTo ?? this.repliedTo,
      repliedToUserId: repliedToUserId ?? this.repliedToUserId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'text': text,
      'hashTags': hashTags,
      'link': link,
      'imageLinks': imageLinks,
      'uid': uid,
      'tweetType': tweetType.type,
      'tweetedAt': tweetedAt.millisecondsSinceEpoch,
      'likes': likes,
      'commentIds': commentIds,
      'reshareCount': reshareCount,
      'reTweetedBy': reTweetedBy,
      'repliedTo': repliedTo,
      'repliedToUserId': repliedToUserId,
    };
  }

  Map<String, dynamic> reshareMap() {
    return <String, dynamic>{'reshareCount': reshareCount};
  }

  Map<String, dynamic> likeMap() {
    return <String, dynamic>{'likes': likes};
  }

  factory Tweet.fromMap(Map<String, dynamic> map) {
    return Tweet(
      text: map['text'] as String,
      hashTags: List<String>.from(
        (map['hashTags']),
      ),
      link: map['link'] as String,
      imageLinks: List<String>.from(map['imageLinks']),
      uid: map['uid'] as String,
      tweetType: (map['tweetType'] as String).toTweetEnum(),
      tweetedAt: DateTime.fromMillisecondsSinceEpoch(map['tweetedAt'] as int),
      likes: List<String>.from(map['likes']),
      commentIds: List<String>.from(map['commentIds']),
      id: map['\$id'] as String,
      reshareCount: map['reshareCount'] as int,
      reTweetedBy: map['reTweetedBy'] as String,
      repliedTo: map['repliedTo'] ?? "",
      repliedToUserId: map['repliedToUserId'] ?? "",
    );
  }

  @override
  String toString() {
    return 'Tweet(text: $text, hashTags: $hashTags, link: $link, imageLinks: $imageLinks, uid: $uid, tweetType: $tweetType, tweetedAt: $tweetedAt, likes: $likes, commentIds: $commentIds, id: $id, retweetId: $reshareCount, reTweetedBy: $reTweetedBy , repliedTo: $repliedTo, repliedToUserId: $repliedToUserId)';
  }

  @override
  bool operator ==(covariant Tweet other) {
    if (identical(this, other)) return true;

    return other.text == text &&
        listEquals(other.hashTags, hashTags) &&
        other.link == link &&
        listEquals(other.imageLinks, imageLinks) &&
        other.uid == uid &&
        other.tweetType == tweetType &&
        other.tweetedAt == tweetedAt &&
        listEquals(other.likes, likes) &&
        listEquals(other.commentIds, commentIds) &&
        other.id == id &&
        other.reshareCount == reshareCount &&
        other.reTweetedBy == reTweetedBy &&
        other.repliedTo == repliedTo &&
        other.repliedToUserId == repliedToUserId;
  }

  @override
  int get hashCode {
    return text.hashCode ^
        hashTags.hashCode ^
        link.hashCode ^
        imageLinks.hashCode ^
        uid.hashCode ^
        tweetType.hashCode ^
        tweetedAt.hashCode ^
        likes.hashCode ^
        commentIds.hashCode ^
        id.hashCode ^
        reshareCount.hashCode ^
        reTweetedBy.hashCode ^
        repliedTo.hashCode ^
        repliedToUserId.hashCode;
  }
}
