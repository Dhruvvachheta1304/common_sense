import 'app_routes.dart';
import 'package:get/get.dart';
import 'package:firebasemark1/app/modules/bookmark/bindings/bookmark_binding.dart';
import 'package:firebasemark1/app/modules/bookmark/views/bookmark_view.dart';
import 'package:firebasemark1/app/modules/bottom_nav_bar/bindings/bottom_nav_bar_binding.dart';
import 'package:firebasemark1/app/modules/bottom_nav_bar/views/bottom_nav_bar_view.dart';
import 'package:firebasemark1/app/modules/home/bindings/home_binding.dart';
import 'package:firebasemark1/app/modules/home/views/home_view.dart';
import 'package:firebasemark1/app/modules/login/bindings/login_binding.dart';
import 'package:firebasemark1/app/modules/login/views/login_view.dart';
import 'package:firebasemark1/app/modules/profile/bindings/profile_binding.dart';
import 'package:firebasemark1/app/modules/profile/views/profile_view.dart';
import 'package:firebasemark1/app/modules/splash/bindings/splash_binding.dart';
import 'package:firebasemark1/app/modules/splash/views/splash_view.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: Routes.HOME,
      page: () => const HomeView(),
      binding: HomeBindings(),
    ),
    GetPage(
      name: Routes.PROFILE,
      page: () => ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: Routes.BOOKMARK,
      page: () => const BookmarkView(),
      binding: BookmarkBinding(),
    ),
    GetPage(
      name: Routes.BOTTOM_NAVIGATION_BAR,
      page: () => const BottomNavView(),
      binding: BottomNavBinding(),
    ),
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: Routes.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
  ];
}
