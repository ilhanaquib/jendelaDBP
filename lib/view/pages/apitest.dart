import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class apentah extends StatelessWidget {
  const apentah({super.key, required this.bookImage});

  final String bookImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [CachedNetworkImage(imageUrl: bookImage)],
      ),
    );
  }
}
