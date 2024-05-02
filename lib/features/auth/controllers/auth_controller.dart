// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/apis/auth_api.dart';
import 'package:twitter_clone/apis/user_api.dart';
import 'package:twitter_clone/core/core.dart';
import 'package:twitter_clone/features/auth/view/login_screen.dart';
import 'package:twitter_clone/features/auth/view/signup_screen.dart';
import 'package:twitter_clone/features/home/view/home_screen.dart';
import 'package:twitter_clone/model/user_model.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, bool>((ref) {
  final authAPI = ref.watch(authAPIProvider);
  final userAPI = ref.watch(userAPIProvider);
  return AuthController(authAPI: authAPI, userAPI: userAPI);
});

final currentUserAccountProvider = FutureProvider<User?>((ref) async {
  final authController = ref.watch(authControllerProvider.notifier);
  return await authController.getCurrentUser();
});

final userDetailsProvider = FutureProvider.family(
  (ref, String uId) {
    final AuthController authController =
        ref.watch(authControllerProvider.notifier);
    return authController.getUserData(uId);
  },
);

final currentUserDetailsProvider = FutureProvider((ref) {
  final userId = ref.watch(currentUserAccountProvider).value!.$id;
  log("userId: $userId");
  final userDetails = ref.watch(userDetailsProvider(userId));
  return userDetails.value;
});

class AuthController extends StateNotifier<bool> {
  AuthController({
    required this.authAPI,
    required this.userAPI,
  }) : super(false);
  final AuthAPI authAPI;
  final UserAPI userAPI;

  Future<User?> getCurrentUser() => authAPI.getCurrentUser();

  void signUp({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = true;
    final res = await authAPI.signUp(email: email, password: password);
    res.fold((l) => context.showSnack(l.message), (r) async {
      UserModel userModel = UserModel(
          email: email,
          name: email.nameFromEmail,
          followers: const [],
          following: const [],
          bio: '',
          profilePic: '',
          bannerPic: '',
          isTwitterBlue: false,
          uid: r.$id);
      final res2 = await userAPI.saveUserData(userModel);
      res2.fold((l) => context.showSnack(l.message.toString()), (r) {
        context.showSnack("Signed up successfully, please login.");
        Navigator.of(context).pushReplacement(
          LoginScreen.route,
        );
      });
    });
    state = false;
  }

  void login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = true;
    final res = await authAPI.login(email: email, password: password);
    res.fold((l) => context.showSnack(l.message), (r) {
      context.showSnack("Logged in successfully");
      Navigator.of(context).pushReplacement(
        HomeScreen.route,
      );
    });
    state = false;
  }

  Future<UserModel> getUserData(String userId) async {
    final document = await userAPI.getUserData(userId);
    return UserModel.fromMap(document.data);
  }

  void logout(BuildContext context) async {
    final res = await authAPI.logOut();
    res.fold((l) => null, (r) {
      Navigator.pop(context);
      Navigator.pushAndRemoveUntil(
          context, SignUpScreen.route, (route) => false);
    });
  }
}
