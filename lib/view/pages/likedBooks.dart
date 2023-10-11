import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:jendela_dbp/controllers/dbpColor.dart';
import 'package:like_button/like_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:jendela_dbp/components/DBPImportedWidgets/noBooksLikedCard.dart';
import 'package:jendela_dbp/controllers/likedBooksManagement.dart';
import 'package:jendela_dbp/hive/models/hiveBookModel.dart';
import 'package:jendela_dbp/stateManagement/cubits/likedStatusCubit.dart';
import 'package:jendela_dbp/view/pages/bookDetails.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class LikedBooks extends StatefulWidget {
  const LikedBooks({super.key, this.controller});
  final controller;

  @override
  _LikedBooksState createState() => _LikedBooksState();
}

class _LikedBooksState extends State<LikedBooks> {
  late Box<bool> likedStatusBox;
  late Box<HiveBookAPI> likedBooksBox;
  late Map<int, bool> likedStatusMap = {};
  late List boxKeys;

  @override
  void initState() {
    super.initState();
    likedBooksBox = Hive.box<HiveBookAPI>('liked_books');
    boxKeys = likedBooksBox.keys.toList();
    likedStatusBox = LikedStatusManager.likedStatusBox!;

    for (final key in boxKeys) {
      likedStatusMap[key] = false;
    }

    // Listen to state changes of the LikedStatusCubit
    context.read<LikedStatusCubit>().stream.listen((state) {
      setState(() {
        likedStatusMap = state;
      });
    });

    _openLikedStatusBox();
  }

  Future<void> _openLikedStatusBox() async {
    for (final key in boxKeys) {
      final isLiked = LikedStatusManager.isBookLiked(key);

      // Update the liked status in the HiveBookAPI model
      final book = likedBooksBox.get(key);
      if (book != null) {
        book.isFavorite = isLiked;
        likedBooksBox.put(key, book);
      }

      LikedStatusManager.updateLikedStatus(key, isLiked); // Update liked status
    }
  }

  void _updateLikedStatus(int bookId, bool isLiked) {
    context.read<LikedStatusCubit>().updateLikedStatus(bookId, isLiked);
    likedStatusMap[bookId] = isLiked; // Update liked status map

    setState(() {
      // Refresh the UI if needed
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(88.0),
        child: Column(
          children: [
            AppBar(
              title: const Text('Liked Books'),
              centerTitle: true,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SmoothPageIndicator(
                  controller: widget.controller,
                  count: 2,
                  effect: ExpandingDotsEffect(
                      activeDotColor: DbpColor().jendelaOrange,
                      dotColor: DbpColor().jendelaGray,
                      dotHeight: 8,
                      dotWidth: 8),
                  onDotClicked: (index) => widget.controller.animateToPage(index,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeIn),
                ),
              ],
            ),
          ],
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: likedBooksBox.listenable(),
        builder: (context, Box<HiveBookAPI> box, widget) {
          final likedBookKeys = likedStatusBox.keys
              .where(
                  (key) => likedStatusBox.get(key, defaultValue: false) == true)
              .map<int>((key) => key as int)
              .toList();

          final likedBooks = likedBookKeys
              .map((key) => likedBooksBox.get(key))
              .whereType<HiveBookAPI>()
              .toList();

          return likedBooks.isNotEmpty
              ? ListView.builder(
                  itemCount: likedBooks.length,
                  itemBuilder: (context, index) {
                    HiveBookAPI book = likedBooks[index];
                    return SizedBox(
                      width: MediaQuery.of(context).size.width * 0.94,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            bottom: 25, left: 10, right: 10),
                        child: GestureDetector(
                          onTap: () {
                            PersistentNavBarNavigator.pushNewScreen(
                              context,
                              withNavBar: false,
                              screen: BookDetail(
                                book: book,
                              ),
                            );
                          },
                          child: Card(
                            elevation: 0,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.18,
                                  width:
                                      MediaQuery.of(context).size.width * 0.27,
                                  child: Card(
                                    elevation: 4,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(book.images!,
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 25, top: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 170,
                                        child: Text(
                                          book.name!,
                                          maxLines: 2,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      // Text(
                                      //   book.type!,
                                      //   style: const TextStyle(
                                      //     color: Color.fromARGB(255, 123, 123, 123),
                                      //     fontSize: 14,
                                      //   ),
                                      // ),
                                      const SizedBox(
                                        height: 70,
                                      ),
                                      _buildCategoryBox(
                                        capitalizeFirstLetter(book.categories!),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 25, top: 40),
                                  child: LikeButton(
                                    bubblesColor: const BubblesColor(
                                      dotPrimaryColor:
                                          Color.fromARGB(255, 245, 88, 88),
                                      dotSecondaryColor: Colors.white,
                                    ),
                                    isLiked: true, // Set initial liked status
                                    onTap: (bool isLiked) async {
                                      int bookIdToDelete = book.id!;

                                      int? keyToDelete;

                                      for (var entry
                                          in likedBooksBox.toMap().entries) {
                                        if (entry.value.id == bookIdToDelete) {
                                          keyToDelete = entry.key;
                                          break;
                                        }
                                      }

                                      if (keyToDelete != null) {
                                        // Remove from likedBooksBox using the key
                                        likedBooksBox.delete(keyToDelete);

                                        // Update likedBooks list
                                        likedBooks.removeWhere((book) =>
                                            book.id == bookIdToDelete);

                                        // Update liked status map in the cubit and liked status box
                                        context
                                            .read<LikedStatusCubit>()
                                            .removeLikedStatus(keyToDelete);

                                        // Notify BooksInsideShelf about the change in liked status
                                        context
                                            .read<LikedStatusCubit>()
                                            .updateLikedStatusMap(
                                                likedStatusMap);

                                        _updateLikedStatus(keyToDelete, false);
                                      }
                                    },
                                    likeBuilder: (bool isLiked) {
                                      return const Icon(
                                        Icons.delete_outline_rounded,
                                        size: 32,
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                )
              : const Center(
                  child: NoBooksLikedCard(),
                );
        },
      ),
    );
  }
}

String capitalizeFirstLetter(String text) {
  if (text.isEmpty) return '';
  return text[0].toUpperCase() + text.substring(1);
}

Widget _buildCategoryBox(String category) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
    decoration: BoxDecoration(
      color: DbpColor().jendelaGreen,
      borderRadius: BorderRadius.circular(50),
    ),
    child: Text(
      category,
      style: const TextStyle(
        color: Colors.white,
      ),
    ),
  );
}

