import 'package:flutter/material.dart';
import 'package:jendela_dbp/components/DBPImportedWidgets/notFoundCard.dart';
import 'package:jendela_dbp/hive/models/hiveBookModel.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:jendela_dbp/view/pages/bookDetails.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class BooksInsideShelf extends StatefulWidget {
  final List<dynamic> dataBooks;
  final Box<HiveBookAPI> bookBox;
  final likedBooksBox = Hive.box<HiveBookAPI>('liked_books');

  BooksInsideShelf({required this.dataBooks, required this.bookBox});

  @override
  _BooksInsideShelfState createState() => _BooksInsideShelfState();
}

class _BooksInsideShelfState extends State<BooksInsideShelf> {
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

  Map<int, bool> likedBooks = {}; // Map to store liked status

  late Box<bool> likedStatusBox;

  @override
  void initState() {
    super.initState();
    _openLikedStatusBox();
  }

  Future<void> _openLikedStatusBox() async {
    likedStatusBox = await Hive.openBox<bool>('liked_status');

    for (final key in widget.dataBooks) {
      final isLiked = likedStatusBox.get(key, defaultValue: false) ?? false;

      // Update the liked status in the HiveBookAPI model
      final book = widget.bookBox.get(key);
      if (book != null) {
        book.isFavorite = isLiked;
        widget.bookBox.put(key, book);
      }

      setState(() {
        likedBooks[key] = isLiked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: widget.dataBooks.isEmpty
            ? Center(
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
                  final isBookLiked = likedBooks[key] ?? false;

                  return Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: GestureDetector(
                      onTap: () {
                        PersistentNavBarNavigator.pushNewScreen(
                          context,
                          withNavBar: false,
                          screen: BookDetail(
                            bookImage: bookSpecific.images!,
                            bookTitle: bookSpecific.name!,
                            bookDesc: bookSpecific.description!,
                          ),
                        );
                      },
                      child: SizedBox(
                        height: 300,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 2),
                          child: SizedBox(
                            height: 250,
                            width: 150,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
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
                                          imageUrl: bookSpecific!.images!,
                                          height: 220,
                                          width: 150,
                                          fit: BoxFit.fill,
                                        ),
                                        Positioned(
                                          top: 2,
                                          right: 2,
                                          child: CircleAvatar(
                                            radius: 15,
                                            backgroundColor: isBookLiked
                                                ? const Color.fromARGB(
                                                    255, 144, 191, 63)
                                                : const Color.fromARGB(
                                                    230, 128, 128, 128),
                                            child: Center(
                                              child: Transform.translate(
                                                offset:
                                                    const Offset(-2.7, -1.7),
                                                child: IconButton(
                                                    onPressed: () async {
                                                      final newLikedStatus =
                                                          !isBookLiked;

                                                      // Update liked status in the 'liked_status' box
                                                      await likedStatusBox.put(
                                                          key, newLikedStatus);

                                                      // Update the liked status in the book model and in the main book storage box
                                                      final book = widget
                                                          .bookBox
                                                          .get(key);
                                                      if (book != null) {
                                                        book.isFavorite =
                                                            newLikedStatus;
                                                        widget.bookBox
                                                            .put(key, book);

                                                        // Add or remove the book from the 'liked_books' box based on the liked status
                                                        if (newLikedStatus) {
                                                          widget.likedBooksBox
                                                              .put(key, book);
                                                        } else {
                                                          widget.likedBooksBox
                                                              .delete(
                                                                  key); // Remove the book from 'liked_books' box
                                                        }
                                                      }

                                                      setState(() {
                                                        likedBooks[key] =
                                                            newLikedStatus;
                                                      });

                                                      print(widget.likedBooksBox
                                                          .values);
                                                    },
                                                    icon: const Icon(
                                                      Icons
                                                          .favorite_border_rounded,
                                                      color: Colors.white,
                                                      size: 20,
                                                    )),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 7),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        capitalizeEachWord(
                                            bookSpecific.name!.toLowerCase()),
                                        maxLines: 1,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color:
                                              Color.fromARGB(255, 51, 51, 51),
                                          overflow: TextOverflow.visible,
                                        ),
                                      ),
                                      Text(
                                        'RM' + bookSpecific.price!,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Color.fromARGB(
                                              255, 123, 123, 123),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
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
