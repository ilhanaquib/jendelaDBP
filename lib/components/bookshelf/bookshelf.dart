import 'package:flutter/material.dart';

import 'package:hive/hive.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import 'package:jendela_dbp/components/bookshelf/booksInsideShelf.dart';
import 'package:jendela_dbp/view/pages/allBooks.dart';
import 'carouselTitle.dart';
import 'package:jendela_dbp/hive/models/hiveBookModel.dart';

Widget bookShelf(
  context,
  categoryTitle,
  categoryCode,
  List<int> listBook,
  Box<HiveBookAPI> APIBook,
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
                    bookBox: APIBook),
              );
            },
          ),
        ),
        SizedBox(
          height: 320,
          child: BooksInsideShelf(dataBooks: listBook, bookBox: APIBook),
        )
      ],
    ),
  );
}
