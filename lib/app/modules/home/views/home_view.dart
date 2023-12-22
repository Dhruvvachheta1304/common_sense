import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasemark1/app/modules/bookmark/controllers/bookmark_controller.dart';
import 'package:firebasemark1/app/theme/app_text_style.dart';
import 'package:firebasemark1/app/theme/spacing.dart';
import 'package:get/get.dart';
import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:firebasemark1/app/core/widgets/quote_card.dart';
import 'package:firebasemark1/app/modules/home/controllers/home_controller.dart';

class HomeView extends StatelessWidget {
  const HomeView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
          left: 18,
          right: 18,
          top: 0,
          bottom: 80,
        ),
        child: Column(
          children: [
            VSpace.xxlarge(),
            Row(
              children: [
                Stack(
                  children: [
                    Opacity(
                      opacity: 0.12,
                      child: Text(
                        'Good Morning',
                        style: TextStyle(
                          letterSpacing: 1,
                          color: Colors.blue.shade800,
                          fontSize: 50,
                          fontWeight: AppFontWeight.bold,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 1,
                      bottom: -1,
                      child: Opacity(
                        opacity: 0.8,
                        child: Text(
                          '${FirebaseAuth.instance.currentUser?.displayName}',
                          style: TextStyle(
                            color: Colors.blue.shade800,
                            fontSize: 30,
                            fontWeight: AppFontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
            Row(
              children: [
                Text(
                  'Are you out of your senses? Grab some from here.😉',
                  style: TextStyle(
                    color: Colors.blue.shade800,
                    fontSize: 16,
                    fontWeight: AppFontWeight.medium,
                  ),
                ),
              ],
            ),
            VSpace.xxxlarge(),
            GetBuilder<HomeController>(
              builder: (logic) {
                if (logic.quotes.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.60,
                    child: AppinioSwiper(
                      backgroundCardCount: 1,
                      allowUnlimitedUnSwipe: true,
                      controller: logic.controller,
                      onEnd: _onEnd,
                      loop: true,
                      cardCount: logic.quotes.length,
                      cardBuilder: (BuildContext context, int index) {
                        return GetBuilder<BookmarkController>(
                          init: BookmarkController(),
                          builder: (bookmarkController) {
                            return GestureDetector(
                              onDoubleTap: () async {
                                await logic
                                    .toggleLikeDislike(logic.quotes[index].id);
                              },
                              child: QuoteCard(
                                quoteModel: logic.quotes[index],
                                color: logic.color,
                                key: UniqueKey(),
                                shouldShowBookMarkIcon: true,
                                shouldLikeIcon: true,
                                onPressed: () async {
                                  final HomeController controller =
                                      Get.find<HomeController>();
                                  await controller.upsertToQuoteList(
                                      logic.quotes[index].id);
                                },
                                onLike: () async {
                                  await logic.toggleLikeDislike(
                                      logic.quotes[index].id);
                                },
                                onShare: () async {
                                  await bookmarkController.shareScreenshot(
                                      GetBuilder<BookmarkController>(
                                    builder: (bookmarkController) {
                                      return QuoteCard(
                                        quoteModel: logic.quotes[index],
                                        color: logic.color,
                                        shouldShowShareIcon: false,
                                        shouldShowBookMarkIcon: false,
                                        shouldLikeIcon: false,
                                      );
                                    },
                                  ), index);
                                },
                              ),
                            );
                          },
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _unSwipe(bool unSwiped) {
    if (unSwiped) {
      dev.log("SUCCESS: card was unSwiped");
    } else {
      dev.log("FAIL: no card left to unSwipe");
    }
  }

  void _onEnd() {
    dev.log("end reached!");
  }
}
