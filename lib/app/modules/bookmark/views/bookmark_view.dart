import 'package:get/get.dart';
import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:firebasemark1/app/theme/spacing.dart';
import 'package:firebasemark1/app/theme/app_text_style.dart';
import 'package:firebasemark1/app/core/widgets/quote_card.dart';
import 'package:firebasemark1/app/modules/bookmark/controllers/bookmark_controller.dart';

class BookmarkView extends StatelessWidget {
  const BookmarkView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Bookmarks'),
        titleTextStyle: TextStyle(
          color: Colors.blue.shade800,
          fontSize: Insets.large,
          fontWeight: AppFontWeight.semiBold,
          letterSpacing: 2,
        ),
      ),
      body: Center(
        child: GetBuilder<BookmarkController>(
          builder: (logic) {
            if (logic.isLoading.value) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return logic.bookmarkQuotesList.isEmpty
                  ? Center(
                      child: Text(
                        'No bookmarked quotes.',
                        style: TextStyle(
                          color: Colors.blue.shade900,
                          fontSize: Insets.medium,
                          fontWeight: AppFontWeight.light,
                          letterSpacing: 2,
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(
                        left: 18,
                        right: 18,
                        top: 0,
                        bottom: 80,
                      ),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.60,
                        child: AppinioSwiper(
                          backgroundCardCount: 1,
                          allowUnlimitedUnSwipe: true,
                          controller: logic.controller,
                          onEnd: _onEnd,
                          loop: true,
                          cardBuilder: (BuildContext context, int index) {
                            return QuoteCard(
                              quoteModel: logic.bookmarkQuotesList[index]!,
                              color: logic.color,
                              key: UniqueKey(),
                              shouldShowBookMarkIcon: false,
                              shouldLikeIcon: false,
                              onShare: () async {
                                await logic.shareScreenshot(
                                    QuoteCard(
                                      quoteModel:
                                          logic.bookmarkQuotesList[index]!,
                                      color: logic.color,
                                      shouldShowShareIcon: false,
                                      shouldShowBookMarkIcon: false,
                                      shouldLikeIcon: false,
                                    ),
                                    index);
                              },
                            );
                          },
                          cardCount: logic.bookmarkQuotesList.length,
                        ),
                      ),
                    );
            }
          },
        ),
      ),
    );
  }

  void _onEnd() {
    dev.log("end reached!");
  }
}
