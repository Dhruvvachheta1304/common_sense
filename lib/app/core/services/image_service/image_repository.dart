import 'dart:developer';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as p;

class ImageRepository {
  Future<void> deleteProfilePic() async {
    try {
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref =
          storage.ref().child(FirebaseAuth.instance.currentUser!.uid);

      ListResult result = await ref.listAll();

      // Delete each item in the storage reference
      for (Reference item in result.items) {
        await item.delete().catchError((error) {
          log('Item could not be deleted: $error');
        });
      }
    } catch (e) {
      log('Error occurred: $e');
    }
  }

  Future<String> uploadFile(File photo) async {
    try {
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage
          .ref()
          .child(FirebaseAuth.instance.currentUser!.uid)
          .child("/image${p.extension(photo.path)}");

      // Delete existing profile picture
      await deleteProfilePic();

      // Upload the new profile picture
      UploadTask uploadTask = ref.putFile(photo);
      await uploadTask
          .whenComplete(() => log('Image uploaded to Firebase Storage'));

      // Get the download URL of the uploaded image
      String imgUrl = await ref.getDownloadURL();
      log('Download URL: $imgUrl');

      return imgUrl;
    } catch (e) {
      log('Error occurred: $e');
      return '';
    }
  }
}
