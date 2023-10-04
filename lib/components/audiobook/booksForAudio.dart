import 'package:flutter/material.dart';

import 'package:hive/hive.dart';
import 'package:jendela_dbp/components/audiobook/audiosInsideShelf.dart';
import 'package:jendela_dbp/components/bookshelf/carouselTitle.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import 'package:jendela_dbp/components/bookshelf/booksInsideShelf.dart';
import 'package:jendela_dbp/view/pages/allBooks.dart';
import 'package:jendela_dbp/hive/models/hiveBookModel.dart';

Widget AudiobookShelf(
  context,
  List listBook,
  Box<HiveBookAPI> APIBook,
) {
  return Container(
    child: Container(
      child: Column(
        children: [
          SizedBox(
              height: MediaQuery.of(context).size.height * 0.83,
              child: AudiosInsideShelf(dataBooks: listBook, bookBox: APIBook))
        ],
      ),
    ),
  );
}
