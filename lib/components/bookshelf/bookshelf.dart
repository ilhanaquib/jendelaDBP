import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
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
  return Container(
    height: 350,
    child: Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: CarouselTitle(
              title: categoryTitle + ' Terkini',
              seeAllText: "View All",
              seeAllOnTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AllBooks(
                        categoryTitle: categoryTitle, listBook: listBook, bookBox: APIBook,),
                  ),
                );
                // List<dynamic> lihatSemuaObject = [categoryTitle, categoryCode];
                // Navigator.of(context)
                //     .pushNamed('/AllBook', arguments: lihatSemuaObject);
              },
            ),
          ),
          SizedBox(
              height: 275,
              child: BooksInsideShelf(dataBooks: listBook, bookBox: APIBook))
          //setBookShelf(context, listBook, APIBook),
        ],
      ),
    ),
  );
}
