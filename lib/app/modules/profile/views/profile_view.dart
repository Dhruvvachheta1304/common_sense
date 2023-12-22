import 'package:firebasemark1/app/core/services/image_service/image_controller.dart';
import 'package:firebasemark1/app/modules/profile/controllers/profile_controller.dart';
import 'package:firebasemark1/app/core/services/auth_services/auth_controller.dart';
import 'package:firebasemark1/app/core/widgets/app_button.dart';
import 'package:firebasemark1/app/core/widgets/app_textfield.dart';
import 'package:firebasemark1/app/routes/app_routes.dart';
import 'package:firebasemark1/app/theme/app_text_style.dart';
import 'package:firebasemark1/app/theme/app_colors.dart';
import 'package:firebasemark1/app/theme/spacing.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileView extends GetView<ProfileController> {
  final logic = Get.find<AuthController>();

  ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            centerTitle: true,
            title: const Text('Profile'),
            titleTextStyle: TextStyle(
              color: Colors.blue.shade800,
              fontSize: Insets.large,
              fontWeight: AppFontWeight.semiBold,
              letterSpacing: 2,
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: Insets.large),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  VSpace.xxlarge(),
                  Container(
                    padding: const EdgeInsets.all(1.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.black,
                        width: 1.0,
                      ),
                    ),
                    child: GetBuilder<ProfileController>(
                      builder: (profileController) {
                        return GetBuilder<ImageController>(
                          init: ImageController(),
                          builder: (imageController) {
                            return Obx(() {
                              return Stack(
                                alignment: Alignment.center,
                                children: [
                                  CircleAvatar(
                                    minRadius: 75,
                                    maxRadius: 75,
                                    backgroundColor: AppColors.white,
                                    child: imageController.isLoading.isTrue
                                        ? const CircularProgressIndicator() // Show circular indicator while loading
                                        : (profileController.profilePic != null
                                            ? CircleAvatar(
                                                minRadius: 75,
                                                maxRadius: 75,
                                                backgroundColor:
                                                    AppColors.white,
                                                backgroundImage: NetworkImage(
                                                    profileController
                                                            .profilePic ??
                                                        ''),
                                              )
                                            : Icon(
                                                Icons.camera_alt,
                                                size: 30,
                                                color: Colors.grey[800],
                                              )),
                                  ),
                                  Positioned(
                                    bottom: Insets.xxsmall,
                                    right: 95,
                                    child: IconButton(
                                      onPressed: () {
                                        imageController
                                            .showImagePicker(context);
                                      },
                                      icon: ClipOval(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              Insets.xxxlarge,
                                            ),
                                            color: AppColors.white,
                                            border: Border.all(),
                                          ),
                                          padding: const EdgeInsets.all(
                                            Insets.xxsmall,
                                          ),
                                          child: const Icon(
                                            Icons.add_a_photo_outlined,
                                            size: Insets.large,
                                            color: AppColors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              );
                            });
                          },
                        );
                      },
                    ),
                  ),
                  VSpace.xlarge(),
                  AppTextField(
                    controller: controller.nameController,
                    hintText: 'Name',
                  ),
                  VSpace.xlarge(),
                  AppTextField(
                    controller: controller.emailController,
                    hintText: 'E-mail',
                  ),
                  VSpace.xxlarge(),
                  AppButton(
                    onTap: () {
                      Get.toNamed(Routes.BOOKMARK);
                    },
                    title: 'Bookmarks',
                    icon: Icons.bookmark_border,
                    tileColor: Colors.blue.shade800,
                  ),
                  VSpace.medium(),
                  AppButton(
                    onTap: () {
                      logic.logoutGoogle();
                    },
                    title: 'LogOut',
                    icon: Icons.logout,
                    tileColor: Colors.red.shade700,
                  ),
                  VSpace.xxlarge(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
