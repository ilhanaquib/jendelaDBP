import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jendela_dbp/controllers/screen_size.dart';
import 'package:jendela_dbp/stateManagement/cubits/liked_status_cubit.dart';

import 'package:jendela_dbp/view/pages/savedBooks/liked_books.dart';
import 'package:jendela_dbp/view/pages/savedBooks/liked_books_grid.dart';
import 'package:jendela_dbp/view/pages/savedBooks/user_books.dart';

class SavedBooksHome extends StatefulWidget {
  const SavedBooksHome({super.key});

  @override
  State<SavedBooksHome> createState() => _SavedBooksHomeState();
}

class _SavedBooksHomeState extends State<SavedBooksHome> {
  final controller = PageController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LikedStatusCubit(),
      child: PageView(
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
      ),
    );
  }
}
