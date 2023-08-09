import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';

class NoDescriptionCard extends StatelessWidget {
  Widget build(BuildContext context) {
    // return Center(child: Text('Maaf, pautan tidak dijumpai.'));
    return EmptyWidget(
      hideBackgroundAnimation: true,
      image: null,
      packageImage: PackageImage.Image_4,
      title: 'No Info On This Book',
      subTitle: 'Sorry, We Don\'t Have Information On This Book.',
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