import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasemark1/app/modules/home/model/quote_model.dart';

class HomeRepository {
  const HomeRepository();

  // fetch Quote Data from Firebase
  Future<List<QuoteModel>> getData() async {
    final CollectionReference collectionRef =
        FirebaseFirestore.instance.collection('quotes');
    try {
      QuerySnapshot querySnapshot = await collectionRef.get();
      final List<QuoteModel> allData = querySnapshot.docs.map((doc) {
        final String id = doc.id;
        final String quote = (doc.data() as Map<String, dynamic>)['Quote'];

        return QuoteModel(
          id: id,
          quote: quote,
        );
      }).toList();

      return allData;
    } catch (e) {
      log('Error fetching data: $e');
      return []; // or handle the error as needed
    }
  }

  // Fetches liked quote IDs from Firebase
  Future<List<String>> fetchLikedQuotes() async {
    try {
      String? userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId != null) {
        final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('quotes')
            .where('likedBy', arrayContains: userId)
            .get();

        final List<String> likedQuoteIds = querySnapshot.docs.map((doc) {
          final String id = doc.id;
          return id;
        }).toList();

        return likedQuoteIds;
      } else {
        return [];
      }
    } catch (e) {
      log('Error: $e');
      return [];
    }
  }

  // Fetches likes count
  Future<int> fetchLikeCount(String quoteId) async {
    try {
      final DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
          .collection('quotes')
          .doc(quoteId)
          .get();

      final likeCount =
          (docSnapshot.data() as Map<String, dynamic>)['likes'] ?? 0;
      return likeCount;
    } catch (e) {
      return 0;
    }
  }

  // Toggle like/dislike for a quote
  Future<void> toggleLikeDislike(String id, List<String> likedQuotes) async {
    try {
      final isLiked = likedQuotes.contains(id);
      String? userId = FirebaseAuth.instance.currentUser?.uid;

      final CollectionReference quotesCollection =
          FirebaseFirestore.instance.collection('quotes');

      if (isLiked) {
        // If already liked, remove the user ID from the likedBy array in Firebase
        await quotesCollection.doc(id).update({
          'likedBy': FieldValue.arrayRemove([userId]),
          'likes': FieldValue.increment(-1), // Decrement likes
        });

        // Remove the quote ID from the likedQuotes list
        likedQuotes.remove(id);
      } else {
        // If not liked, add the user ID to the likedBy array in Firebase
        await quotesCollection.doc(id).update({
          'likedBy': FieldValue.arrayUnion([userId]),
          'likes': FieldValue.increment(1), // Increment likes
        });

        // Add the quote ID to the likedQuotes list
        likedQuotes.add(id);
      }

      // Ensure likes don't go below 0
      final DocumentSnapshot docSnapshot = await quotesCollection.doc(id).get();
      final likeCount =
          (docSnapshot.data() as Map<String, dynamic>)['likes'] ?? 0;
      if (likeCount < 0) {
        await quotesCollection.doc(id).update({'likes': 0});
      }
    } catch (e) {
      throw ('Failed to toggle like/dislike');
    }
  }

  // Adds a quote ID to bookmarks and updates Firebase
  Future<void> addToBookmarks(String quoteId, List<String> quoteList) async {
    if (!quoteList.contains(quoteId)) {
      quoteList.add(quoteId);

      await FirebaseFirestore.instance.collection('bookmarks').doc().set({
        'quoteId': quoteId,
        'userId': FirebaseAuth.instance.currentUser?.uid,
      });
    }
  }

  // Removes a quote ID from bookmarks and updates Firebase
  Future<void> removeFromBookmarks(
      String quoteId, List<String> quoteList) async {
    if (quoteList.contains(quoteId)) {
      quoteList.remove(quoteId);

      final userBookmarksRef = FirebaseFirestore.instance
          .collection("bookmarks")
          .where("quoteId", isEqualTo: quoteId);

      try {
        final QuerySnapshot querySnapshot = await userBookmarksRef.get();
        final DocumentSnapshot documentSnapshot = querySnapshot.docs.first;

        await documentSnapshot.reference.delete();
      } catch (e) {
        log('Error: $e');
      }
    }
  }

  // fetch Bookmarks from firebase/ API
  Future<List<String>> fetchBookmarks() async {
    final String? userId = FirebaseAuth.instance.currentUser?.uid;
    final List<String> bookmarkedQuoteIds = [];

    if (userId != null) {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('bookmarks')
          .where("userId", isEqualTo: userId)
          .get();

      bookmarkedQuoteIds.addAll(querySnapshot.docs.map((doc) {
        final String quoteId = (doc.data() as Map<String, dynamic>)['quoteId'];
        return quoteId;
      }));
    }

    return bookmarkedQuoteIds;
  }
}
