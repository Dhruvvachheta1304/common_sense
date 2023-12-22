import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebasemark1/app/theme/app_colors.dart';
import 'package:firebasemark1/app/theme/spacing.dart';

/// This widget is used for Application Button anywhere in application.
/// Which contains common icon, label, onTap and tileColor.

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.title,
    required this.icon,
    this.size,
    this.onTap,
    this.tileColor,
  });
  final String title;
  final IconData icon;
  final double? size;
  final Color? tileColor;
  final GestureTapCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: Insets.xxlarge,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: Insets.small),
        decoration: BoxDecoration(
          color: tileColor,
          borderRadius: BorderRadius.circular(
            10,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: context.textTheme.titleLarge
                  ?.copyWith(color: AppColors.white),
            ),
            Icon(
              icon,
              size: size ?? 28,
              color: AppColors.white,
            ),
          ],
        ),
      ),
    );
  }
}
