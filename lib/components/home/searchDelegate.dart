import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jendela_dbp/hive/models/hiveBookModel.dart';
import 'package:jendela_dbp/view/pages/bookDetails.dart';
import 'package:hive_flutter/hive_flutter.dart';

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
    return StreamBuilder<List<HiveBookAPI>>(
      stream: searchResultsStream(query),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final searchResults = snapshot.data!;

        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // You can adjust the number of columns as needed
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 10.0,
          ),
          itemCount: searchResults.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookDetail(
                      bookImage: searchResults[index].images!,
                      bookTitle: searchResults[index].name!,
                      bookDesc: searchResults[index].description!,
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
    return StreamBuilder<List<HiveBookAPI>>(
      stream: searchResultsStream(query),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final suggestionList = snapshot.data!;

        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // You can adjust the number of columns as needed
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 10.0,
          ),
          itemCount: suggestionList.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookDetail(
                      bookImage: suggestionList[index].images!,
                      bookTitle: suggestionList[index].name!,
                      bookDesc: suggestionList[index].description!,
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