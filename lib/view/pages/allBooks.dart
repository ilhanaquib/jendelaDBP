import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:jendela_dbp/controllers/likedBooksManagement.dart';
import 'package:jendela_dbp/hive/models/hiveBookModel.dart';
import 'package:jendela_dbp/stateManagement/cubits/likedStatusCubit.dart';
import 'package:like_button/like_button.dart';
import 'bookDetails.dart';

enum SortingOrder {
  highToLow,
  lowToHigh,
  latest,
  alphabeticallyAToZ,
  alphabeticallyZToA,
}

class AllBooks extends StatefulWidget {
  AllBooks(
      {super.key,
      required this.categoryTitle,
      required this.listBook,
      required this.bookBox});

  final String categoryTitle;
  List<int> listBook;
  final Box<HiveBookAPI> bookBox;
  final likedBooksBox = Hive.box<HiveBookAPI>('liked_books');

  @override
  State<AllBooks> createState() => _AllBooksState();
}

class _AllBooksState extends State<AllBooks> {
  late Map<int, bool> likedStatusMap;
  late Box<bool> likedStatusBox;

// sort books ----------------------------------------------
  SortingOrder selectedSortingOrder = SortingOrder.latest;
  void _sortBooks() {
    setState(() {
      widget.listBook.sort((a, b) {
        final HiveBookAPI? bookA = widget.bookBox.get(a);
        final HiveBookAPI? bookB = widget.bookBox.get(b);

        if (bookA == null || bookB == null) return 0;

        final double priceA = double.tryParse(bookA.price!) ?? 0;
        final double priceB = double.tryParse(bookB.price!) ?? 0;

        if (selectedSortingOrder == SortingOrder.highToLow) {
          return priceB.compareTo(priceA); // Sort high to low
        } else {
          return priceA.compareTo(priceB); // Sort low to high
        }
      });
    });
  }

  void _sortBooksByLatest() {
    setState(() {
      widget.listBook.sort((a, b) {
        final HiveBookAPI? bookA = widget.bookBox.get(a);
        final HiveBookAPI? bookB = widget.bookBox.get(b);

        if (bookA == null || bookB == null) return 0;

        return bookB.date_created!
            .compareTo(bookA.date_created!); // Sort by latest
      });
    });
  }

  void _sortBooksAlphabetically(bool ascending) {
    setState(() {
      widget.listBook.sort((a, b) {
        final HiveBookAPI? bookA = widget.bookBox.get(a);
        final HiveBookAPI? bookB = widget.bookBox.get(b);

        if (bookA == null || bookB == null) return 0;

        final comparison = bookA.name!.compareTo(bookB.name!);
        return ascending ? comparison : -comparison; // Sort alphabetically
      });
    });
  }
  // sort books---------------------------------------------------------

  @override
  void initState() {
    super.initState();
    likedStatusBox = LikedStatusManager.likedStatusBox!;
    likedStatusMap = {};
    for (final key in widget.listBook) {
      likedStatusMap[key] = false;
    }

    // Listen to state changes of the LikedStatusCubit
    context.read<LikedStatusCubit>().stream.listen((state) {
      // setState(() {
      //   likedStatusMap = state;
      // });
    });
    _openLikedStatusBox();

    context.read<LikedStatusCubit>().stream.listen((state) {
      // setState(() {
      //   likedStatusMap = state;
      // });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _openLikedStatusBox() async {
    for (final key in widget.listBook) {
      final isLiked = LikedStatusManager.isBookLiked(key);

      // Update the liked status in the HiveBookAPI model
      final book = widget.bookBox.get(key);
      if (book != null) {
        book.isFavorite = isLiked;
        widget.bookBox.put(key, book);
      }

      LikedStatusManager.updateLikedStatus(key, isLiked); // Update liked status
    }

    // setState(() {
    //   // Refresh the UI if needed
    // });
  }

  void _updateLikedStatus(int bookId, bool isLiked) {
    context.read<LikedStatusCubit>().updateLikedStatus(bookId, isLiked);
  }

  Color getCircleAvatarBackgroundColor(int bookId) {
    return likedStatusMap[bookId] ?? false
        ? const Color.fromARGB(255, 245, 88, 88)
        : Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    Map<SortingOrder, void Function()> sortingFunctions = {
      SortingOrder.highToLow: _sortBooks,
      SortingOrder.lowToHigh: _sortBooks,
      SortingOrder.latest: _sortBooksByLatest,
      SortingOrder.alphabeticallyAToZ: () => _sortBooksAlphabetically(true),
      SortingOrder.alphabeticallyZToA: () => _sortBooksAlphabetically(false),
    };

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.categoryTitle} Terkini'),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final crossAxisCount = _calculateCrossAxisCount(constraints);
          final mainAxisSpacing =
              _calculateMainAxisSpacing(constraints, crossAxisCount);
          final crossAxisSpacing =
              _calculateCrossAxisSpacing(constraints, crossAxisCount);
          final childAspectRatio =
              _calculateChildAspectRatio(constraints, crossAxisCount);
          return CustomScrollView(
            slivers: [
              const SliverAppBar(
                floating: true,
                snap: true,
                elevation: 0.0,
                toolbarHeight: 0.01,
              ),
              SliverFillRemaining(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text('Sort by: '),
                        DropdownButton<SortingOrder>(
                          value: selectedSortingOrder,
                          onChanged: (newValue) {
                            setState(() {
                              selectedSortingOrder = newValue!;
                              sortingFunctions[selectedSortingOrder]?.call();
                            });
                          },
                          items: const [
                            DropdownMenuItem(
                              value: SortingOrder.latest,
                              child: Text('Latest'),
                            ),
                            DropdownMenuItem(
                              value: SortingOrder.highToLow,
                              child: Text('Price High to Low'),
                            ),
                            DropdownMenuItem(
                              value: SortingOrder.lowToHigh,
                              child: Text('Price Low to High'),
                            ),
                            DropdownMenuItem(
                              value: SortingOrder.alphabeticallyAToZ,
                              child: Text('A-Z'),
                            ),
                            DropdownMenuItem(
                              value: SortingOrder.alphabeticallyZToA,
                              child: Text('Z-A'),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Expanded(
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: _calculateCrossAxisCount(constraints),
                          mainAxisSpacing: mainAxisSpacing,
                          crossAxisSpacing: crossAxisSpacing,
                          childAspectRatio: childAspectRatio,
                        ),
                        itemCount: widget.listBook.length,
                        itemBuilder: (context, index) {
                          final int key = widget.listBook[index];
                          final HiveBookAPI? bookSpecific =
                              widget.bookBox.get(key);
                          var isBookLiked =
                              context.read<LikedStatusCubit>().state[key] ??
                                  false;
                          //final isBookLikedMap = likedStatusMap[key] ?? false;

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BookDetail(
                                    bookId: key,
                                    bookImage: bookSpecific.images!,
                                    bookTitle: bookSpecific.name!,
                                    bookDesc: bookSpecific.description!,
                                    bookPrice: bookSpecific.price!,
                                    likedStatusBox: likedStatusBox,
                                    bookBox: widget.bookBox,
                                  ),
                                ),
                              );
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
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
                                          isLiked: isBookLiked,
                                          onTap: (bool isLiked) async {
                                            final newLikedStatus = !isLiked;

                                            // Update liked status in the 'liked_status' box
                                            await likedStatusBox.put(
                                                key, newLikedStatus);

                                            // Update the liked status in the book model and in the main book storage box
                                            final book =
                                                widget.bookBox.get(key);

                                            if (book != null) {
                                              book.isFavorite = newLikedStatus;
                                              widget.bookBox.put(key, book);

                                              // Add or remove the book from the 'liked_books' box based on the liked status
                                              if (newLikedStatus) {
                                                widget.likedBooksBox
                                                    .put(key, book);
                                              } else {
                                                widget.likedBooksBox.delete(
                                                    key); // Remove the book from 'liked_books' box
                                              }

                                              // Update liked status in LikedStatusManager
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
                                                  color: isLiked
                                                      ? const Color.fromARGB(
                                                          255, 245, 88, 88)
                                                      : Colors.white,
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
                                  padding: EdgeInsets.only(top: 0),
                                  child: Text(
                                    bookSpecific.name!,
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    style: TextStyle(fontSize: 10),
                                  ),
                                ),
                                Text(
                                  bookSpecific.price == ''
                                      ? 'Naskhah Ikhlas'
                                      : 'RM ${bookSpecific.price!}',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Color.fromARGB(255, 123, 123, 123),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }

  int _calculateCrossAxisCount(BoxConstraints constraints) {
    // Calculate the cross-axis count based on screen width
    double screenWidth = constraints.maxWidth;
    if (screenWidth < 600) {
      return 2; // For smaller screens
    } else if (screenWidth < 1200) {
      return 3; // For medium screens
    } else {
      return 4; // For larger screens
    }
  }

  double _calculateMainAxisSpacing(
      BoxConstraints constraints, int crossAxisCount) {
    // Calculate mainAxisSpacing based on screen width and crossAxisCount
    double screenWidth = constraints.maxWidth;
    if (screenWidth < 600) {
      return 8.0; // For smaller screens
    } else if (screenWidth < 1200) {
      return 12.0; // For medium screens
    } else {
      return 4.0; // For larger screens
    }
  }

  double _calculateCrossAxisSpacing(
      BoxConstraints constraints, int crossAxisCount) {
    // Calculate crossAxisSpacing based on screen width and crossAxisCount
    double screenWidth = constraints.maxWidth;
    if (screenWidth < 600) {
      return 8.0; // For smaller screens
    } else if (screenWidth < 1200) {
      return 12.0; // For medium screens
    } else {
      return 4.0; // For larger screens
    }
  }

  double _calculateChildAspectRatio(
      BoxConstraints constraints, int crossAxisCount) {
    // Calculate childAspectRatio based on screen width and crossAxisCount
    double screenWidth = constraints.maxWidth;
    if (screenWidth < 600) {
      return 0.6; // For smaller screens
    } else if (screenWidth < 1200) {
      return 0.6; // For medium screens
    } else {
      return 1.4; // For larger screens
    }
  }
}
