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
      'bookmarks': this.bookmarks,
      'cfi': this.cfi,
      'textSize': this.textSize,
      'theme': this.theme
    });
  }
}
