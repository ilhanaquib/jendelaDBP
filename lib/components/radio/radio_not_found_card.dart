import 'package:flutter/material.dart';

import 'package:empty_widget/empty_widget.dart';

class RadioNotFoundCard extends StatelessWidget {
  const RadioNotFoundCard({super.key});

  @override
  Widget build(BuildContext context) {
    return EmptyWidget(
      hideBackgroundAnimation: true,
      image: null,
      packageImage: PackageImage.Image_4,
      title: 'Tiada Radio DBP',
      subTitle: 'Maaf, tiada Radio DBP dijumpai',
      titleTextStyle: const TextStyle(
        fontSize: 22,
        color: Color(0xff9da9c7),
        fontWeight: FontWeight.w500,
      ),
      subtitleTextStyle: const TextStyle(
        fontSize: 14,
        color: Color(0xffabb8d6),
      ),
    );
  }
}
