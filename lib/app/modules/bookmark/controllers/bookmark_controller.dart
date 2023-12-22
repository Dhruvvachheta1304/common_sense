import 'dart:developer' as dev;
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:firebasemark1/app/modules/bookmark/repository/bookmark_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:firebasemark1/app/modules/home/model/quote_model.dart';
import 'package:firebasemark1/app/modules/home/repository/home_repository.dart';

class BookmarkController extends GetxController {
  static const String bookmarkListKey = 'dummyList';

  // Repository instance
  final HomeRepository _repository = const HomeRepository();

  final BookmarkRepository _bookmarkRepository = BookmarkRepository();

  // Swiper controller instance
  final AppinioSwiperController controller = AppinioSwiperController();

  var color = Colors.primaries[Random().nextInt(Colors.primaries.length)];

  //  This list will contains its data from Firebase or API.
  List<QuoteModel> quotesList = [];

  //  This list will contains its data from Firebase or API.
  List<String> bookmarkedQuoteIdsList = [];

  // This list will contains its data from authentication.
  List<QuoteModel?> bookmarkQuotesList = [];

  // Observable variable to track loading state
  var isLoading = true.obs; // Set the initial value to true

  // Screenshot controller for capturing widget screenshots
  ScreenshotController screenshotController = ScreenshotController();

  @override
  Future<void> onInit() async {
    await fetchQuoteData();
    await fetchBookmarks();
    super.onInit();
  }

  /// Fetches quote data from the repository.
  Future<void> fetchQuoteData() async {
    try {
      isLoading.value = true;
      quotesList = await _repository.getData();
      dev.log('${quotesList.length}');
      update();
    } catch (e) {
      Get.snackbar('Error', 'cant get data in Bookmarks list');
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetches bookmarked quotes from Firebase.
  Future<void> fetchBookmarks() async {
    try {
      isLoading.value = true;

      bookmarkedQuoteIdsList =
          await _bookmarkRepository.fetchBookmarkedQuoteIds();
      dev.log("Book Mark list  ${bookmarkedQuoteIdsList.length}");

      update();
      getList();
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch bookmarks');
    } finally {
      isLoading.value = false;
    }
  }

  /// Populates [bookmarkQuotesList] based on bookmarked IDs.
  void getList() {
    bookmarkQuotesList = quotesList
        .map((e) {
          dev.log("Login Mapping  : ${bookmarkedQuoteIdsList.contains(e.id)}");
          return bookmarkedQuoteIdsList.contains(e.id) ? e : null;
        })
        .toSet()
        .toList();
    bookmarkQuotesList.removeWhere((element) => element == null);
    update();
    dev.log("Ui List : ${bookmarkQuotesList.length}");
  }

  // This function is used for sharing the screenshot through this app to everywhere.
  Future<void> shareScreenshot(Widget widget, int index) async {
    Uint8List? captureImage = await screenshotController.captureFromWidget(
      widget,
    );

    final tempDir = await getTemporaryDirectory();
    final file = await File('${tempDir.path}/screenshots.jpg')
        .writeAsBytes(captureImage);

    final xFile = XFile(file.path);

    await Share.shareXFiles([xFile]);
  }
}
