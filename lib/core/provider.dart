import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/constants/appwrite_constant.dart';

final appwriteAccountClientProvider = Provider<Client>((ref) {
  Client client = Client();
  return client
      .setEndpoint(AppwriteConstant.endpoint)
      .setProject(AppwriteConstant.projectId)
      .setSelfSigned(status: true);
});

final appwriteDatabasesProvider = Provider<Databases>((ref) {
  final client = ref.watch(appwriteAccountClientProvider);
  return Databases(client);
});

final appwriteAccountProvider = Provider<Account>((ref) {
  final client = ref.watch(appwriteAccountClientProvider);
  return Account(client);
});
