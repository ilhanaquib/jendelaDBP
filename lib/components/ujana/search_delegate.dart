import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import 'package:jendela_dbp/hive/models/hive_book_model.dart';
import 'package:jendela_dbp/view/pages/book_details.dart';
import 'package:jendela_dbp/controllers/dbp_color.dart';

class BookSearchDelegate extends SearchDelegate<String> {
  final Box<HiveBookAPI> apiBook;

  BookSearchDelegate(this.apiBook);

  Stream<List<HiveBookAPI>> searchResultsStream(String query) {
    return Stream.fromFuture(
        Future.delayed(const Duration(milliseconds: 300), () {
      return apiBook.values.where((book) {
        final title = book.name;
        return title!.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }));
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  // back button
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  // search result
  Widget buildResults(BuildContext context) {
    bool isDesktop = MediaQuery.of(context).size.width >= 600;
    return StreamBuilder<List<HiveBookAPI>>(
      stream: searchResultsStream(query),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: LoadingAnimationWidget.discreteCircle(
              color: DbpColor().jendelaGray,
              secondRingColor: DbpColor().jendelaGreen,
              thirdRingColor: DbpColor().jendelaOrange,
              size: 50.0,
            ),
          );
        }

        final searchResults = snapshot.data!;

        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isDesktop
                ? 6
                : 2,
            mainAxisSpacing: isDesktop ? 5 : 10.0,
            crossAxisSpacing: isDesktop ? 5 : 10.0,
          ),
          itemCount: searchResults.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                PersistentNavBarNavigator.pushNewScreen(
                  context,
                  screen: BookDetail(book: searchResults[index]),
                );
              },
              child: Column(
                children: [
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Stack(
                        children: [
                          CachedNetworkImage(
                            imageUrl: searchResults[index].images!,
                            height: 220,
                            width: 150,
                            fit: BoxFit.fill,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Text(searchResults[index].name!),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  // suggestion
  Widget buildSuggestions(BuildContext context) {
    bool isDesktop = MediaQuery.of(context).size.width >= 600;
    return StreamBuilder<List<HiveBookAPI>>(
      stream: searchResultsStream(query),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: LoadingAnimationWidget.discreteCircle(
              color: DbpColor().jendelaGray,
              secondRingColor: DbpColor().jendelaGreen,
              thirdRingColor: DbpColor().jendelaOrange,
              size: 50.0,
            ),
          );
        }

        final suggestionList = snapshot.data!;

        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isDesktop
                ? 6
                : 2,
            mainAxisSpacing: isDesktop ? 5 : 20.0,
            crossAxisSpacing: isDesktop ? 5 : 20.0,
          ),
          itemCount: suggestionList.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                PersistentNavBarNavigator.pushNewScreen(
                  context,
                  withNavBar: false,
                  screen: BookDetail(
                    book: suggestionList[index],
                  ),
                );
              },
              child: Column(
                children: [
                  Expanded(
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: CachedNetworkImage(
                          imageUrl: suggestionList[index].images!,
                          width: 100,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    suggestionList[index].name!,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
