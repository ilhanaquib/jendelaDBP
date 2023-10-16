import 'package:flutter/material.dart';
import 'package:jendela_dbp/controllers/screenSize.dart';

import 'package:jendela_dbp/view/pages/savedBooks/likedBooks.dart';
import 'package:jendela_dbp/view/pages/savedBooks/likedBooksGrid.dart';
import 'package:jendela_dbp/view/pages/savedBooks/userBooks.dart';

class SavedBooksHome extends StatefulWidget {
  const SavedBooksHome({super.key});

  @override
  State<SavedBooksHome> createState() => _SavedBooksHomeState();
}

class _SavedBooksHomeState extends State<SavedBooksHome> {
  final controller = PageController();

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: controller,
      scrollDirection: Axis.horizontal,
      children: [
        UserBooks(
          controller: controller,
        ),
        if (ResponsiveLayout.isDesktop(context))
          LikedBooksGrid(
            controller: controller,
          )
        else if (ResponsiveLayout.isTablet(context))
          LikedBooksGrid(
            controller: controller,
          )
        else
          LikedBooks(
            controller: controller,
          )
      ],
    );
  }
}
