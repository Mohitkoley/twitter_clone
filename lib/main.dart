import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/common/common.dart';
import 'package:twitter_clone/constants/appwrite_constant.dart';
import 'package:twitter_clone/features/auth/controllers/auth_controller.dart';
import 'package:twitter_clone/features/auth/view/signup_screen.dart';
import 'package:twitter_clone/features/home/view/home_screen.dart';
import 'package:twitter_clone/theme/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppwriteConstant().getConfigs();
  // For self signed certificates, only use for development
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
        title: 'Twitter Clone',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: ref.watch(currentUserAccountProvider).when(
            data: (user) {
              if (user != null) {
                return const HomeScreen();
              } else {
                return const SignUpScreen();
              }
            },
            error: (error, stackTrace) =>
                ErrorScreen(message: error.toString()),
            loading: () => const LoadingScreen()));
  }
}
