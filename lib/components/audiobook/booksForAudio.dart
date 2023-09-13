import 'package:flutter/material.dart';

import 'package:hive/hive.dart';
import 'package:jendela_dbp/components/audiobook/audiosInsideShelf.dart';

import 'package:jendela_dbp/hive/models/hiveBookModel.dart';

Widget AudioBookshelf(
  context,
  categoryTitle,
  categoryCode,
  List<int> listBook,
  Box<HiveBookAPI> APIBook,
) {
  return Container(
      child: AudiosInsideShelf(dataBooks: listBook, bookBox: APIBook));
}
