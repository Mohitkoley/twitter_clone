enum NotificationType {
  like("like"),
  reply("reply"),
  follow('follow'),
  reTweet('retweet');

  final String type;
  const NotificationType(this.type);
}
