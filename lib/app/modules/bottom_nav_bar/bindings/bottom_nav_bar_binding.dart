import 'package:firebasemark1/app/modules/bottom_nav_bar/controllers/bottom_nav_bar_controller.dart';
import 'package:firebasemark1/app/modules/profile/controllers/profile_controller.dart';
import 'package:firebasemark1/app/modules/home/controllers/home_controller.dart';
import 'package:get/get.dart';

class BottomNavBinding extends Bindings {
  @override
  void dependencies() {
    Get
      ..lazyPut<BottomNavController>(BottomNavController.new)
      ..put(HomeController())
      ..put(ProfileController());
  }
}
