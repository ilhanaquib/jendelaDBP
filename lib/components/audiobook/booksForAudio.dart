import 'package:flutter/material.dart';

import 'package:hive/hive.dart';

import 'package:jendela_dbp/components/audiobook/audiosInsideShelf.dart';
import 'package:jendela_dbp/hive/models/hiveBookModel.dart';

Widget AudiobookShelf(
  context,
  List listBook,
  Box<HiveBookAPI> APIBook,
) {
  return SizedBox(
    child: SizedBox(
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
