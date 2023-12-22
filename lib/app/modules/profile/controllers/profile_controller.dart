import 'dart:developer';
import 'package:firebasemark1/app/modules/profile/repository/profile_repository.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasemark1/app/core/services/auth_services/user_simple_preferences.dart';

class ProfileController extends GetxController {
  final ProfileRepository _repository = ProfileRepository();

  @override
  void onInit() {
    super.onInit();

    // Fetches and sets data during controller initialization
    getAllData();

    // Initializes text controllers with user data
    nameController.text = (UserPreferences.getUsername() ??
        FirebaseAuth.instance.currentUser?.displayName)!;
    emailController.text = (UserPreferences.getUserEmail() ??
        FirebaseAuth.instance.currentUser?.email)!;
  }

  // Variable to store profile picture URL
  String? profilePic;

  bool isLoading = true; // Set the initial value to true

  // Fetches all data, including profile picture, from Firebase Storage
  Future<void> getAllData() async {
    try {
      isLoading = true; // Set loading state to true when fetching data

      profilePic = await _repository.getProfilePictureUrl();
      log('Download profilePic URL: $profilePic');
      update();
    } catch (e) {
      log('Error occurred: $e');
    } finally {
      isLoading = false; // Set loading state to false when fetching is done
      update();
    }
  }

  // Text controllers for name and email
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  // Updates user data in SharedPreferences
  Future<void> setData() async {
    await UserPreferences.setUsername(nameController.text);
    await UserPreferences.setUserEmail(emailController.text);
  }
}
