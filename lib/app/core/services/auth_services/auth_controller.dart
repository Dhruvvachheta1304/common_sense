import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasemark1/app/routes/app_routes.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Here is functions of user login and logOut using Google and session management of user.
// Also store user's data in local storage until logOut from the app.

class AuthController extends GetxController {
  AuthController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final String isLoggedInKey = 'isLoggedIn';

  Future<void> checkLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool(isLoggedInKey) ?? false;

    if (isLoggedIn) {
      Get.offAllNamed(Routes.BOTTOM_NAVIGATION_BAR);
    }
  }

  Future<void> loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      final GoogleSignInAuthentication? googleSignInAuthentication =
          await googleSignInAccount?.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication?.accessToken,
        idToken: googleSignInAuthentication?.idToken,
      );

      await _auth.signInWithCredential(credential);
      await saveLoggedInStatus(true);
      Get.snackbar(
        'Logged In',
        '${FirebaseAuth.instance.currentUser?.displayName}',
      );

      log('YOUR CURRENT USER IS: ${FirebaseAuth.instance.currentUser?.displayName}');

      await Get.offAllNamed(Routes.BOTTOM_NAVIGATION_BAR);
    } catch (e) {
      Get.snackbar('Error', 'User Authentication Error');
    }
  }

  Future<void> logoutGoogle() async {
    await googleSignIn.signOut();
    await _auth.signOut();
    saveLoggedInStatus(false);
    Get.offAllNamed(Routes.LOGIN);
  }

  Future<void> saveLoggedInStatus(bool isLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(isLoggedInKey, isLoggedIn);
  }
}
