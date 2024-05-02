class AppwriteConstant {
  static const String endpoint = 'http://127.0.0.1:8080/v1';
  static const String projectId = '65de1d6f4e9108353385';
  static const String databaseId = '65de26edd12df0816f0a';
  static const String userCollection = '65df8b05d8fc420453c3';
  static const String tweetCollection = "6609b25bbaa0bc7e444f";
  static const String imagesBucket = '6612e82bdbea48e99f0d';
  static const String notificationCollections = "66334b25bbd2dd547bdd";

  static String imageUrl(String imageId) {
    return "$endpoint/storage/buckets/$imagesBucket/files/$imageId/view?project=$projectId&mode=admin";
  }
}
