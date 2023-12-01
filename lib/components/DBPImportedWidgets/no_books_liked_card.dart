import 'package:flutter/material.dart';

import 'package:empty_widget/empty_widget.dart';

class NoBooksLikedCard extends StatelessWidget {
  const NoBooksLikedCard({super.key});

  @override
  Widget build(BuildContext context) {
    // return Center(child: Text('Maaf, pautan tidak dijumpai.'));
    return EmptyWidget(
      hideBackgroundAnimation: true,
      image: null,
      packageImage: PackageImage.Image_1,
      title: 'Anda tiada buku kegemaran',
      subTitle: 'Tekan butang hati di buku kegemaran anda untuk tambah buku di halaman ini',
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
