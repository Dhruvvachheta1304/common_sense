import 'dart:async';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:firebasemark1/app/routes/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashController extends GetxController {
  final String isLoggedInKey = 'isLoggedIn';

  @override
  void onInit() {
    log('init called of splash');
    checkLoginStatus();
    super.onInit();
  }

  void checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool(isLoggedInKey) ?? false;
    await Future.delayed(2.seconds);
    if (isLoggedIn) {
      Get.offAllNamed(Routes.BOTTOM_NAVIGATION_BAR);
    } else {
      Get.offAllNamed(Routes.LOGIN);
    }
  }
}
