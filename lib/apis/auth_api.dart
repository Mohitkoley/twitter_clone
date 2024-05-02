import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:twitter_clone/core/core.dart';
import 'package:twitter_clone/core/provider.dart';

final authAPIProvider = Provider<AuthAPI>((ref) {
  final account = ref.watch(appwriteAccountProvider);
  return AuthAPI(account: account);
});

abstract class IAuthAPI {
  FutureEither<User> signUp({
    required String email,
    required String password,
  });

  FutureEither<Session> login({
    required String email,
    required String password,
  });

  Future<User?> getCurrentUser();

  FutureEitherVoid logOut();
}

class AuthAPI implements IAuthAPI {
  final Account _account;
  AuthAPI({required Account account}) : _account = account;

  @override
  Future<User?> getCurrentUser() async {
    try {
      User user = await _account.get();
      return user;
    } on AppwriteException {
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  FutureEither<User> signUp(
      {required String email, required String password}) async {
    try {
      User user = await _account.create(
          userId: ID.unique(), email: email, password: password);
      return right(user);
    } on AppwriteException catch (e, stackTrace) {
      return left(
          Failure(e.message ?? "some UnExpected Error occured", stackTrace));
    } catch (e, stackTrace) {
      return left(Failure(e.toString(), stackTrace));
    }
  }

  @override
  FutureEither<Session> login(
      {required String email, required String password}) async {
    try {
      Session user = await _account.createEmailPasswordSession(
          email: email, password: password);
      return right(user);
    } on AppwriteException catch (e, stackTrace) {
      return left(
          Failure(e.message ?? "some UnExpected Error occured", stackTrace));
    } catch (e, stackTrace) {
      return left(Failure(e.toString(), stackTrace));
    }
  }

  @override
  FutureEitherVoid logOut() async {
    try {
      await _account.deleteSession(sessionId: 'current');
      return right(null);
    } on AppwriteException catch (e, stackTrace) {
      return left(
          Failure(e.message ?? "some UnExpected Error occured", stackTrace));
    } catch (e, stackTrace) {
      return left(Failure(e.toString(), stackTrace));
    }
  }
}
