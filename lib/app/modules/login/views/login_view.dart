import 'package:firebasemark1/app/core/services/auth_services/auth_controller.dart';
import 'package:firebasemark1/app/theme/app_text_style.dart';
import 'package:firebasemark1/app/theme/spacing.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginView extends GetView<AuthController> {
  const LoginView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Login'),
        titleTextStyle: TextStyle(
          color: Colors.blue.shade800,
          fontSize: Insets.large,
          fontWeight: AppFontWeight.semiBold,
          letterSpacing: 2,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/google-logo.gif',
              width: 300,
              height: 150,
            ),
            ElevatedButton(
              onPressed: () {
                controller.loginWithGoogle();
              },
              child: const Text(
                'Sign in with Google',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
