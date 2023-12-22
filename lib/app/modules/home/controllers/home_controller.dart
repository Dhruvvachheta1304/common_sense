import 'dart:math';
import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:get/get.dart';
import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:firebasemark1/app/modules/home/model/quote_model.dart';
import 'package:firebasemark1/app/modules/home/repository/home_repository.dart';

class HomeController extends GetxController {
  static const String quoteListKey = 'dummyList';

  // This list will contain its data from authentication.
  List<String> quoteList = [];

  // List to store liked quote IDs for the current user
  List<String> likedQuotes = [];

  // List to store data from API or Firebase
  List<QuoteModel> quotes = [];

  final HomeRepository _repository = const HomeRepository();

  final AppinioSwiperController controller = AppinioSwiperController();
  var color = Colors.primaries[Random().nextInt(Colors.primaries.length)];

  @override
  void onInit() {
    super.onInit();
    fetchQuoteData();
    fetchBookmarks();
    fetchLikedQuotes();
  }

  // Fetches liked quote IDs from Firebase
  Future<void> fetchLikedQuotes() async {
    try {
      List<String> likedQuoteIds = await _repository.fetchLikedQuotes();

      likedQuotes = likedQuoteIds;
      update();
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch liked quotes');
    }
  }

  // Fetches likes count
  Future<int> fetchLikeCount(String quoteId) async {
    try {
      return await _repository.fetchLikeCount(quoteId);
    } catch (e) {
      return 0;
    }
  }

  var _firstPress = true;

  // Toggle like/dislike for a quote
  Future<void> toggleLikeDislike(String id) async {
    if (_firstPress) {
      try {
        _firstPress = false;
        await _repository.toggleLikeDislike(id, likedQuotes);
        update();
      } catch (e) {
        Get.snackbar('Error', 'Failed to toggle like/dislike');
      } finally {
        _firstPress = true;
      }
    }
  }

  // Upsert quote ID to quoteList based on bookmark status
  Future<void> upsertToQuoteList(String id) async {
    final isBookmarked = quoteList.contains(id);

    if (!isBookmarked) {
      await addToBookmarks(id);
      dev.log('Added "$id" to quoteList.');
      dev.log('Updated quoteList: $quoteList');
    } else {
      await removeFromBookmarks(id);
      dev.log('Removed "$id" from quoteList.');
      dev.log('Updated quoteList: $quoteList');
    }
    update();
  }

  // fetch Quote Data from Firebase thru repository
  Future<void> fetchQuoteData() async {
    try {
      quotes = await _repository.getData();
      dev.log('$quotes');
      update();
    } catch (e) {
      Get.snackbar('Error', 'cant get data in quote list');
    }
  }

  // Adds a quote ID to bookmarks and updates Firebase
  Future<void> addToBookmarks(String quoteId) async {
    await _repository.addToBookmarks(quoteId, quoteList);
    update();
  }

  // Removes a quote ID from bookmarks and updates Firebase
  Future<void> removeFromBookmarks(String quoteId) async {
    await _repository.removeFromBookmarks(quoteId, quoteList);
    update();
  }

  // fetch Bookmarks from firebase/ API
  Future<void> fetchBookmarks() async {
    try {
      quoteList = await _repository.fetchBookmarks();
      update();
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch bookmarks');
    }
  }

  showSnackBar(String title, String message, Color backgroundColor) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: backgroundColor,
      colorText: Colors.white,
    );
  }

}
