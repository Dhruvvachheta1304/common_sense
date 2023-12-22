import 'package:get/get.dart';
import 'package:firebasemark1/app/modules/bookmark/controllers/bookmark_controller.dart';

class BookmarkBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BookmarkController>(BookmarkController.new);
  }
}
