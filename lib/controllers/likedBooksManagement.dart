import 'package:hive_flutter/hive_flutter.dart';

class LikedStatusManager {
  static Box<bool>? likedStatusBox;

  static Future<void> initLikedStatusBox() async {
    likedStatusBox = await Hive.openBox<bool>('liked_status');
  }

  static void updateLikedStatus(int bookId, bool isLiked) async {
    await likedStatusBox!.put(bookId, isLiked);
  }

  static bool isBookLiked(int bookId) {
    return likedStatusBox!.get(bookId, defaultValue: false) ?? false;
  }
}
