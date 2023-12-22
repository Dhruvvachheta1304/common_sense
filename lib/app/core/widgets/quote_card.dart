import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:glass_kit/glass_kit.dart';
import 'package:firebasemark1/app/theme/app_colors.dart';
import 'package:firebasemark1/app/modules/home/model/quote_model.dart';
import 'package:firebasemark1/app/modules/home/controllers/home_controller.dart';

// This Widget used in both Home and Bookmark screen for showing quotes in Customize card.

class QuoteCard extends StatefulWidget {
  const QuoteCard({
    super.key,
    required this.quoteModel,
    required this.color,
    this.onPressed,
    this.onShare,
    this.onLike,
    this.shouldShowBookMarkIcon = true,
    this.shouldShowShareIcon = true,
    this.shouldLikeIcon = true,
  });
  final QuoteModel quoteModel;
  final Color color;
  final bool shouldShowBookMarkIcon;
  final bool shouldShowShareIcon;
  final bool shouldLikeIcon;
  final VoidCallback? onPressed;
  final VoidCallback? onShare;
  final VoidCallback? onLike;

  @override
  State<QuoteCard> createState() => _QuoteCardState();
}

class _QuoteCardState extends State<QuoteCard> {
  var randomColor = Colors.primaries[Random().nextInt(Colors.primaries.length)];
  bool isActive = false;

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
      height: 600,
      width: 400,
      gradient: LinearGradient(
        colors: [
          Colors.blue.withOpacity(0.40),
          Colors.pinkAccent.withOpacity(0.20),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderGradient: LinearGradient(
        colors: [
          Colors.white.withOpacity(0.60),
          Colors.white.withOpacity(0.10),
          Colors.black.withOpacity(0.05),
          Colors.black.withOpacity(0.60),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        stops: const [0.0, 0.39, 0.40, 1.0],
      ),
      blur: 20,
      borderRadius: BorderRadius.circular(24.0),
      borderWidth: 1.0,
      elevation: 3.0,
      isFrostedGlass: true,
      shadowColor: Colors.purple.withOpacity(0.20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (widget.shouldShowShareIcon)
                IconButton(
                  tooltip: 'Share',
                  iconSize: 30,
                  onPressed: widget.onShare,
                  icon: const Icon(
                    Icons.share,
                    color: AppColors.white,
                  ),
                ),
            ],
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              alignment: Alignment.center,
              width: double.infinity,
              child: Text(
                '"${widget.quoteModel.quote}"',
                softWrap: true,
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          if (widget.shouldShowBookMarkIcon && widget.shouldLikeIcon)
            Row(
              children: [
                IconButton(
                  tooltip: 'Like',
                  iconSize: 32,
                  onPressed: widget.onLike,
                  icon: Get.find<HomeController>()
                          .likedQuotes
                          .contains(widget.quoteModel.id)
                      ? Icon(
                          CupertinoIcons.heart_fill,
                          color: Colors.red.shade600,
                        )
                      : const Icon(
                          CupertinoIcons.heart,
                          color: AppColors.white,
                        ),
                ),

                // Show the like count beside the heart icon
                FutureBuilder<int>(
                  future: Get.find<HomeController>()
                      .fetchLikeCount(widget.quoteModel.id),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || snapshot.data == 0) {
                      return const SizedBox.shrink();
                    }
                    final likeCount = snapshot.data ?? 0;
                    return Text(
                      '$likeCount',
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 16,
                      ),
                    );
                  },
                ),
                const Spacer(),
                IconButton(
                  tooltip: 'Bookmark',
                  iconSize: 32,
                  onPressed: widget.onPressed,
                  icon: !Get.find<HomeController>()
                          .quoteList
                          .contains(widget.quoteModel.id)
                      ? const Icon(
                          Icons.bookmark_outline_outlined,
                          color: AppColors.white,
                        )
                      : const Icon(
                          Icons.bookmark,
                          color: AppColors.white,
                        ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
