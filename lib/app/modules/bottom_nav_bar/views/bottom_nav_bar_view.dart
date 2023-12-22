import 'package:firebasemark1/app/modules/bottom_nav_bar/controllers/bottom_nav_bar_controller.dart';
import 'package:flutter_floating_bottom_bar/flutter_floating_bottom_bar.dart';
import 'package:firebasemark1/app/modules/profile/views/profile_view.dart';
import 'package:firebasemark1/app/modules/home/views/home_view.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:firebasemark1/app/theme/app_colors.dart';
import 'package:firebasemark1/app/theme/spacing.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class BottomNavView extends StatelessWidget {
  const BottomNavView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BottomNavController>(
      builder: (logic) {
        return WillPopScope(
          onWillPop: () async {
            if (logic.currentPage != 0) {
              logic.tabController.animateTo(0);
              return false;
            } else {
              return Future.value(true);
            }
          },
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: BottomBar(
              fit: StackFit.expand,
              borderRadius: BorderRadius.circular(500),
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOutExpo,
              showIcon: false,
              width: MediaQuery.of(context).size.width * 0.8,
              barColor: Colors.blue.shade900,
              start: 2,
              end: 0,
              offset: 12,
              barAlignment: Alignment.bottomCenter,
              iconHeight: 35,
              iconWidth: 35,
              reverse: false,
              hideOnScroll: true,
              scrollOpposite: false,
              onBottomBarHidden: () {},
              onBottomBarShown: () {},
              body: (context, controller) => TabBarView(
                controller: logic.tabController,
                dragStartBehavior: DragStartBehavior.down,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  const HomeView(),
                  ProfileView(),
                ],
              ),
              child: TabBar(
                dividerColor: AppColors.transparent,
                indicatorPadding: const EdgeInsets.fromLTRB(7, 0, 7, 0),
                controller: logic.tabController,
                indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(
                    color: () {
                      if (logic.currentPage == 0 || logic.currentPage == 1) {
                        return logic.colors[0];
                      } else {
                        return logic.unSelectedColor;
                      }
                    }(),
                    width: 4,
                  ),
                  insets: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                ),
                tabs: [
                  SizedBox(
                    height: 55,
                    width: 40,
                    child: Center(
                      child: Icon(
                        size: Insets.large,
                        Icons.home_rounded,
                        color: logic.currentPage == 0
                            ? logic.colors[0]
                            : logic.unSelectedColor,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 55,
                    width: 40,
                    child: Center(
                      child: Icon(
                        size: Insets.large,
                        Icons.person,
                        color: logic.currentPage == 1
                            ? logic.colors[0]
                            : logic.unSelectedColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
