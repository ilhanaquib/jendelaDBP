import 'dart:convert';

class EpubSetting {
  String cfi;
  double textSize;
  String theme;
  List bookmarks;

  EpubSetting(
      {required this.bookmarks,
      required this.cfi,
      required this.textSize,
      required this.theme});

  String toJson() {
    return json.encode({
      'bookmarks': bookmarks,
      'cfi': cfi,
      'textSize': textSize,
      'theme': theme
    });
  }
}
