import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:like_button/like_button.dart';

import 'package:jendela_dbp/components/DBPImportedWidgets/not_found_card.dart';
import 'package:jendela_dbp/controllers/liked_books_management.dart';
import 'package:jendela_dbp/hive/models/hive_book_model.dart';
import 'package:jendela_dbp/stateManagement/cubits/liked_status_cubit.dart';
import 'package:jendela_dbp/view/pages/book_details.dart';
import 'package:jendela_dbp/controllers/dbp_color.dart';

class BooksInsideShelf extends StatefulWidget {
  final List<dynamic> dataBooks;
  final Box<HiveBookAPI> bookBox;
  final likedBooksBox = Hive.box<HiveBookAPI>('liked_books');

  BooksInsideShelf({super.key, required this.dataBooks, required this.bookBox});

  @override
  State<BooksInsideShelf> createState() => _BooksInsideShelfState();
}

class _BooksInsideShelfState extends State<BooksInsideShelf> {
  late Map<int, bool> likedStatusMap = {};
  late Box<bool> likedStatusBox;
  String capitalizeEachWord(String input) {
    List<String> words = input.toLowerCase().split(' ');
    List<String> capitalizedWords = [];
    for (String word in words) {
      if (word.isNotEmpty) {
        String capitalizedWord = word[0].toUpperCase() + word.substring(1);
        capitalizedWords.add(capitalizedWord);
      }
    }

    return capitalizedWords.join(' ');
  }

  @override
  void initState() {
    super.initState();
    likedStatusBox = LikedStatusManager.likedStatusBox!;

    for (final key in widget.dataBooks) {
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

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _openLikedStatusBox() async {
    for (final key in widget.dataBooks) {
      final isLiked = LikedStatusManager.isBookLiked(key);

      // Update the liked status in the HiveBookAPI model
      final book = widget.bookBox.get(key);
      if (book != null) {
        book.isFavorite = isLiked;
        widget.bookBox.put(key, book);
      }

      LikedStatusManager.updateLikedStatus(key, isLiked); // Update liked status
    }
  }

  void _updateLikedStatus(int bookId, bool isLiked) {
    context.read<LikedStatusCubit>().updateLikedStatus(bookId, isLiked);
    likedStatusMap[bookId] = isLiked; // Update liked status map

    setState(() {});
  }

  Color getCircleAvatarBackgroundColor(int bookId) {
    return likedStatusMap[bookId] ?? false
        ? const Color.fromARGB(255, 245, 88, 88)
        : Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: widget.dataBooks.isEmpty
            ? const Center(
                child: NotFoundCard(),
              )
            : ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.dataBooks.length >= 10
                    ? 10
                    : widget.dataBooks.length,
                itemBuilder: (context, index) {
                  final int key = widget.dataBooks[index];
                  final HiveBookAPI? bookSpecific = widget.bookBox.get(key);
                  final isBookLiked = LikedStatusManager.isBookLiked(key);
                  //final isBookLikedMap = likedStatusMap[key] ?? false;
                  return Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: GestureDetector(
                      onTap: () {
                        PersistentNavBarNavigator.pushNewScreen(
                          context,
                          withNavBar: false,
                          screen: BlocProvider.value(
                            value: context.read<LikedStatusCubit>(),
                            child: BookDetail(
                              book: bookSpecific,
                              likedStatusBox: likedStatusBox,
                              bookBox: widget.bookBox,
                            ),
                          ),
                        );
                        // print(bookSpecific.woocommerce_variations);
                      },
                      child: SizedBox(
                        width: 150,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Stack(
                                      children: [
                                        CachedNetworkImage(
                                          imageUrl: bookSpecific!.images!,
                                          // height: 220,
                                          width: 140,
                                          fit: BoxFit.fill,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    top: 4,
                                    right: 4,
                                    child: LikeButton(
                                      bubblesColor: const BubblesColor(
                                        dotPrimaryColor:
                                            Color.fromARGB(255, 245, 88, 88),
                                        dotSecondaryColor: Colors.white,
                                      ),
                                      isLiked:
                                          isBookLiked,
                                      onTap: (bool isLiked) async {
                                        final newLikedStatus = !isLiked;

                                        await likedStatusBox.put(
                                            key, newLikedStatus);

                                        final book = widget.bookBox.get(key);

                                        if (book != null) {
                                          book.isFavorite = newLikedStatus;
                                          widget.bookBox.put(key, book);

                                          if (newLikedStatus) {
                                            widget.likedBooksBox.put(key, book);
                                          } else {
                                            widget.likedBooksBox.delete(key);
                                          }

                                          _updateLikedStatus(
                                              key, newLikedStatus);
                                        }

                                        return newLikedStatus;
                                      },
                                      likeBuilder: (bool isLiked) {
                                        return Stack(
                                          children: [
                                            Icon(
                                              Icons.favorite,
                                              color:
                                                  getCircleAvatarBackgroundColor(
                                                      key),
                                              size: 30,
                                            ),
                                            const Icon(
                                              Icons.favorite_border,
                                              color: Color.fromARGB(
                                                  255, 245, 88, 88),
                                              size: 30,
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 7),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    capitalizeEachWord(
                                        bookSpecific.name!.toLowerCase()),
                                    maxLines: 2,
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: DbpColor().jendelaBlack,
                                      overflow: TextOverflow.visible,
                                    ),
                                  ),
                                  Text(
                                    bookSpecific.price == ''
                                        ? 'Naskhah Ikhlas'
                                        : 'RM ${bookSpecific.price!}',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: DbpColor().jendelaGray,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
