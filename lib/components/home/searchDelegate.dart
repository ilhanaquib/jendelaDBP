import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:jendela_dbp/hive/models/hiveBookModel.dart';
import 'package:jendela_dbp/view/pages/bookDetails.dart';


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
    // clear button
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
    // bool isMobile = MediaQuery.of(context).size.width <= 600;
    return StreamBuilder<List<HiveBookAPI>>(
      stream: searchResultsStream(query),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: LoadingAnimationWidget.discreteCircle(
              color: const Color.fromARGB(255, 123, 123, 123),
              secondRingColor: const Color.fromARGB(255, 144, 191, 63),
              thirdRingColor: const Color.fromARGB(255, 235, 127, 35),
              size: 50.0,
            ),
          );
        }

        final searchResults = snapshot.data!;

        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isDesktop
                ? 6
                : 2, // You can adjust the number of columns as needed
            mainAxisSpacing: isDesktop ? 5 : 10.0,
            crossAxisSpacing: isDesktop ? 5 : 10.0,
          ),
          itemCount: searchResults.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookDetail(
                      bookId: searchResults[index].id!,
                      bookImage: searchResults[index].images!,
                      bookTitle: searchResults[index].name!,
                      bookDesc: searchResults[index].description!,
                      bookPrice: searchResults[index].price!,
                      bookFavorite: searchResults[index].isFavorite,
                    ),
                  ),
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
                  ), // Use your image data
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
    // bool isMobile = MediaQuery.of(context).size.width <= 600;
    return StreamBuilder<List<HiveBookAPI>>(
      stream: searchResultsStream(query),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: LoadingAnimationWidget.discreteCircle(
              color: const Color.fromARGB(255, 123, 123, 123),
              secondRingColor: const Color.fromARGB(255, 144, 191, 63),
              thirdRingColor: const Color.fromARGB(255, 235, 127, 35),
              size: 50.0,
            ),
          );
        }

        final suggestionList = snapshot.data!;

        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isDesktop
                ? 6
                : 2, // You can adjust the number of columns as needed
            mainAxisSpacing: isDesktop ? 5 : 10.0,
            crossAxisSpacing: isDesktop ? 5 : 10.0,
          ),
          itemCount: suggestionList.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookDetail(
                      bookId: suggestionList[index].id!,
                      bookImage: suggestionList[index].images!,
                      bookTitle: suggestionList[index].name!,
                      bookDesc: suggestionList[index].description!,
                      bookPrice: suggestionList[index].price!,
                      bookFavorite: suggestionList[index].isFavorite,
                    ),
                  ),
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
                            imageUrl: suggestionList[index].images!,
                            height: 150,
                            width: 100,
                            fit: BoxFit.fill,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Text(
                    suggestionList[index].name!,
                    textAlign: TextAlign.center,
                    maxLines: 1,
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
