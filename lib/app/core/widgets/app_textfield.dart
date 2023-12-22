import 'package:firebasemark1/app/modules/profile/controllers/profile_controller.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:firebasemark1/app/theme/app_colors.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.hintText,
    this.controller,
  });
  final String? hintText;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: (text) {
        // Call the setData method in the ProfileController when text changes
        Get.find<ProfileController>().setData();
      },
      controller: controller,
      decoration: InputDecoration(
        errorStyle: context.textTheme.labelMedium?.copyWith(
          color: AppColors.black,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.blue.shade800,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(
              10,
            ),
          ),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.black,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(
              10,
            ),
          ),
        ),
        fillColor: AppColors.white,
        filled: false,
        isDense: true,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        hintText: hintText,
      ),
    );
  }
}
