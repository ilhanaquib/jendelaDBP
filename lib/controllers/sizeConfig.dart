import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class SizeConfig {
  static double screenWidth = 0;
  static double screenHeight = 0;
  static double blockWidth = 0;
  static double blockHeight = 0;
  static double oriScreenWidth = 0;
  static double oriScreenHeight = 0;

  static double textMultiplier = 0;
  static double imageSizeMultiplier = 0;
  static double heightMultiplier = 0;
  static double widthMultiplier = 0;
  static bool isPortrait = true;
  static bool isMobilePortrait = false;
  static double bottomPadding = 0;

  static double leftPaddingBook = 10;

  void init(BoxConstraints constraints, Orientation orientation) {
    if (orientation == Orientation.portrait) {
      // print('now potrait');
      screenWidth = constraints.maxWidth;
      screenHeight = constraints.maxHeight;

      oriScreenWidth = constraints.maxWidth;
      oriScreenHeight = constraints.maxHeight;

      // print("Screen width" + screenWidth.toString());
      // print("Screen height" + screenHeight.toString());
      // print("oriScreenWidth" + oriScreenWidth.toString());
      // print("oriScreenHeight" + oriScreenHeight.toString());

      isPortrait = true;
      bottomPadding = 0;
      if (oriScreenHeight < 670) {
        screenHeight = constraints.maxHeight - 1;
      } else if (oriScreenHeight < 820) {
        screenHeight = constraints.maxHeight - 90;
      } else if (oriScreenHeight < 1000) {
        screenHeight = constraints.maxHeight - 160;
      } else {
        screenHeight = constraints.maxHeight + 150;
      }
      // if (screenWidth < 400) {
      //   screenWidth = constraints.maxWidth;
      //   screenHeight = constraints.maxHeight - 160;
      //   if (oriScreenWidth < 300) {
      //     screenHeight = constraints.maxHeight - 1;
      //   }
      //   oriScreenWidth = constraints.maxWidth;
      //   oriScreenHeight = constraints.maxHeight;
      // }
    } else {
      // print("now landscape");
      screenWidth = constraints.maxHeight - 160;
      screenHeight = constraints.maxWidth;
      bottomPadding = 15;
      isPortrait = false;
      isMobilePortrait = false;

      oriScreenWidth = constraints.maxHeight;
      oriScreenHeight = constraints.maxWidth;

      if (screenWidth < 400) {
        screenWidth = constraints.maxHeight;
        screenHeight = constraints.maxWidth - 160;

        oriScreenWidth = constraints.maxHeight;
        oriScreenHeight = constraints.maxWidth;
      }
    }

    blockWidth = screenWidth / 100;
    blockHeight = screenHeight / 100;

    textMultiplier = blockHeight;
    imageSizeMultiplier = blockWidth;
    heightMultiplier = blockHeight;
    widthMultiplier = blockWidth;
  }
}
