import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/common/common.dart';
import 'package:twitter_clone/common/rounded_small_button.dart';
import 'package:twitter_clone/constants/constants.dart';
import 'package:twitter_clone/features/auth/controllers/auth_controller.dart';
import 'package:twitter_clone/features/auth/view/signup_screen.dart';
import 'package:twitter_clone/features/auth/widgets/widgets.dart';
import 'package:twitter_clone/theme/theme.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});
  static Route get route =>
      MaterialPageRoute<void>(builder: (_) => const LoginScreen());

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final AppBar appBar = UIConstants.appBar;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void login() {
    if (_formKey.currentState!.validate()) {
      ref.read(authControllerProvider.notifier).login(
          email: emailController.text,
          password: passwordController.text,
          context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isLoading = ref.watch(authControllerProvider);
    return Scaffold(
      appBar: appBar,
      body: isLoading
          ? const Loader()
          : Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        AuthField(
                            controller: emailController,
                            hintText: "Email address"),
                        const SizedBox(height: 25),
                        AuthField(
                            controller: passwordController,
                            hintText: "Password"),
                        const SizedBox(height: 40),
                        Align(
                          alignment: Alignment.topRight,
                          child: RoundedSmallButton(
                              label: "Done", onPressed: login),
                        ),
                        const SizedBox(height: 40),
                        RichText(
                            text: TextSpan(
                                text: "Don't have an account? ",
                                style: const TextStyle(
                                    color: Pallete.whiteColor, fontSize: 16),
                                children: [
                              TextSpan(
                                  text: "Sign Up",
                                  style: const TextStyle(
                                      color: Pallete.blueColor, fontSize: 16),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.pop(context);
                                    }),
                            ]))
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
