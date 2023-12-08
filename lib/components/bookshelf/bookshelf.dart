import 'package:flutter/material.dart';

import 'package:hive/hive.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import 'package:jendela_dbp/components/bookshelf/books_inside_shelf.dart';
import 'package:jendela_dbp/view/pages/all_books.dart';
import 'carousel_title.dart';
import 'package:jendela_dbp/hive/models/hive_book_model.dart';

Widget bookShelf(
  context,
  categoryTitle,
  categoryCode,
  List<int> listBook,
  Box<HiveBookAPI> apiBook,
) {
  return SizedBox(
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: CarouselTitle(
            title: categoryTitle + ' Terkini',
            seeAllText: "Lihat Semua",
            seeAllOnTap: () {
              PersistentNavBarNavigator.pushNewScreen(
                context,
                withNavBar: false,
                screen: AllBooks(
                    categoryTitle: categoryTitle,
                    listBook: listBook,
                    bookBox: apiBook),
              );
            },
          ),
        ),
        SizedBox(
          height: 320,
          child: BooksInsideShelf(dataBooks: listBook, bookBox: apiBook),
        )
      ],
    ),
  );
}
