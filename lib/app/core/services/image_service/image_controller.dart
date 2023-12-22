import 'dart:io';
import 'dart:async';
import 'dart:developer';
import 'package:firebasemark1/app/core/services/image_service/image_repository.dart';
import 'package:firebasemark1/app/modules/profile/controllers/profile_controller.dart';
import 'package:firebasemark1/app/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;

class ImageController extends GetxController {
  // Variable to store the selected photo
  File? photo;

  final ImagePicker? picker = ImagePicker();

  final ImageRepository _imageRepository = ImageRepository();

  // Loading indicator variable
  var isLoading = false.obs;

  @override
  onInit() {
    super.onInit();
    ever(isLoading, (_) => update());
  }

  // Selects an image from the gallery and uploads it
  Future<void> imgFromGallery() async {
    try {
      isLoading.value = true; // Set loading to true
      final pickedFile = await picker?.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        photo = File(pickedFile.path);
        await uploadFile();
        update();
      } else {
        log('No image selected.');
      }
    } finally {
      isLoading.value = false; // Set loading to false after completion
    }
  }

  // Takes a photo using the camera and uploads it
  Future<void> imgFromCamera() async {
    try {
      isLoading.value = true; // Set loading to true
      final pickedFile = await picker?.pickImage(source: ImageSource.camera);

      if (pickedFile != null) {
        photo = File(pickedFile.path);
        await uploadFile();
        update();
      } else {
        log('No image selected.');
      }
    } finally {
      isLoading.value = false; // Set loading to false after completion
    }
  }

  // Deletes the profile picture from Firebase Storage
  Future<void> deleteProfilePic() async {
    await _imageRepository.deleteProfilePic();
    update();
  }

  // Uploads the selected photo to Firebase Storage
  Future<void> uploadFile() async {
    if (photo == null) return;

    isLoading.value = true; // Set loading to true during upload

    String imgUrl = await _imageRepository.uploadFile(photo!);

    if (imgUrl.isNotEmpty) {
      // Update the profile data in the ProfileController
      await Get.find<ProfileController>().getAllData();
    } else {
      log('Error uploading image.');
    }
  }

  // Displays a bottom sheet with options to select an image source
  Future<void> showImagePicker(context) async {
    showModalBottomSheet(
      backgroundColor: Colors.blue.shade900,
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(
                  Icons.photo_library,
                  color: AppColors.white,
                ),
                title: const Text('Gallery'),
                titleTextStyle:
                    const TextStyle(color: AppColors.white, fontSize: 16),
                onTap: () {
                  imgFromGallery();
                  Get.back();
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.photo_camera,
                  color: AppColors.white,
                ),
                title: const Text('Camera'),
                titleTextStyle:
                    const TextStyle(color: AppColors.white, fontSize: 16),
                onTap: () {
                  imgFromCamera();
                  Get.back();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
