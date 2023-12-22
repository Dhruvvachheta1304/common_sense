import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomNavController extends GetxController
    with GetSingleTickerProviderStateMixin {
  int currentPage = 0;
  late TabController tabController;
  late Color unSelectedColor = colors[currentPage].computeLuminance() < 0.5
      ? Colors.white
      : Colors.white;
  final List<Color> colors = [
    Colors.white,
    Colors.red,
  ];

  void changePage(int newPage) {
    currentPage = newPage;
    update();
  }

  @override
  void onInit() {
    tabController = TabController(length: 2, vsync: this);
    tabController.animation!.addListener(
      () {
        final value = tabController.animation!.value.round();
        if (value != currentPage) {
          changePage(value);
        }
      },
    );
    super.onInit();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }
}
