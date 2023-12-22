import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfileRepository {
  final FirebaseStorage storage = FirebaseStorage.instance;

  Future<String?> getProfilePictureUrl() async {
    try {
      Reference ref =
          storage.ref().child(FirebaseAuth.instance.currentUser!.uid);
      ListResult result = await ref.listAll();

      // Retrieve and update profile picture URL
      for (Reference item in result.items) {
        String imgUrl = await item.getDownloadURL();
        return imgUrl;
      }
    } catch (e) {
      log('Error occurred: $e');
    }
    return null;
  }
}
