import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BookmarkRepository {
  Future<List<String>> fetchBookmarkedQuoteIds() async {
    final userBookmarksRef = FirebaseFirestore.instance
        .collection('bookmarks')
        .where("userId",
            isEqualTo: '${FirebaseAuth.instance.currentUser?.uid}');

    try {
      QuerySnapshot querySnapshot = await userBookmarksRef.get();
      List<String> bookmarkedQuoteIds = querySnapshot.docs.map((doc) {
        final String quoteId = (doc.data() as Map<String, dynamic>)['quoteId'];
        return quoteId;
      }).toList();

      return bookmarkedQuoteIds;
    } catch (e) {
      log('Error fetching bookmarked quotes: $e');
      return [];
    }
  }
}
