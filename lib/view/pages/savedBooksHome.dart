import 'package:flutter/material.dart';
import 'package:jendela_dbp/view/pages/likedBooks.dart';
import 'package:jendela_dbp/view/pages/userBooks.dart';

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
        LikedBooks(
          controller: controller,
        ),
      ],
    );
  }
}
