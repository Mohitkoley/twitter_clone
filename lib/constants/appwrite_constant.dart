import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppwriteConstant {
  DotEnv dotenv = DotEnv();
  static String endpoint = '';
  static String projectId = '';
  static String databaseId = '';
  static String userCollection = '';
  static String tweetCollection = '';
  static String imagesBucket = '';
  static String notificationCollections = '';

  static String imageUrl(String imageId) {
    return "$endpoint/storage/buckets/$imagesBucket/files/$imageId/view?project=$projectId&mode=admin";
  }

  Future getConfigs() async {
    await dotenv.load(fileName: ".env");
    endpoint = dotenv.env["endpoint"]!;
    projectId = dotenv.env["projectId"]!;
    databaseId = dotenv.env["databaseId"]!;
    userCollection = dotenv.env["userCollection"]!;
    tweetCollection = dotenv.env["tweetCollection"]!;
    imagesBucket = dotenv.env["imagesBucket"]!;
    notificationCollections = dotenv.env["notificationCollections"]!;
  }
}
