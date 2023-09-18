import 'dart:convert';

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

  bool ascendingPrice = true;
  bool ascendingAlphabet = true;
  bool sortLatest = false;
  bool sortPrice = false;
  bool sortAlphabet = false;

  bool pdfSelected = false;
  bool printSelected = false;
  bool audiobookSelected = false;
  Set<String> selectedFormats = {'PDF', 'Buku Cetak', 'Buku Audio'};

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
          return ascendingPrice
              ? priceB.compareTo(priceA)
              : priceA.compareTo(priceB);
        } else {
          return ascendingPrice
              ? priceA.compareTo(priceB)
              : priceB.compareTo(priceA);
        }
      });
    });
  }

  void _sortBooksAlphabetically() {
    setState(() {
      widget.listBook.sort((a, b) {
        final HiveBookAPI? bookA = widget.bookBox.get(a);
        final HiveBookAPI? bookB = widget.bookBox.get(b);

        if (bookA == null || bookB == null) return 0;

        final comparison = bookA.name!.compareTo(bookB.name!);
        return ascendingAlphabet ? comparison : -comparison;
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

  void bottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      elevation: 0,
      context: context,
      builder: (BuildContext context) {
        //return const FormatSelection();
        return SizedBox(
          height: 170,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 40, left: 20),
                child: Row(
                  children: [
                    Text(
                      'Format',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.white,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildFormatButton(
                            Icons.picture_as_pdf_rounded,
                            'PDF',
                            () {
                              setState(() {
                                pdfSelected = !pdfSelected;
                                Navigator.pop(context);
                              });
                            },
                            pdfSelected,
                          ),
                          _buildFormatButton(
                            Icons.library_books_rounded,
                            'Print',
                            () {
                              setState(() {
                                printSelected = !printSelected;
                                Navigator.pop(context);
                              });
                            },
                            printSelected,
                          ),
                          _buildFormatButton(
                            Icons.graphic_eq_rounded,
                            'Audiobook',
                            () {
                              setState(() {
                                audiobookSelected = !audiobookSelected;
                                Navigator.pop(context);
                              });
                            },
                            audiobookSelected,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    void _toggleSortingOrder(SortingOrder newSortingOrder) {
      setState(() {
        // Call the appropriate sorting function with the ascending parameter
        if (newSortingOrder == SortingOrder.latest) {
          _sortBooksByLatest();
        } else if (newSortingOrder == SortingOrder.highToLow) {
          _sortBooks(); // Pass the ascending parameter
        } else if (newSortingOrder == SortingOrder.lowToHigh) {
          _sortBooks(); // Reverse the ascending parameter
        } else if (newSortingOrder == SortingOrder.alphabeticallyAToZ) {
          _sortBooksAlphabetically();
        } else if (newSortingOrder == SortingOrder.alphabeticallyZToA) {
          _sortBooksAlphabetically(); // Reverse the ascending parameter
        }
      });
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(88.0),
        child: Column(
          children: [
            AppBar(
              title: Text('${widget.categoryTitle} Terkini'),
              centerTitle: true,
              actions: [
                IconButton(
                  onPressed: () {
                    bottomSheet(context);
                  },
                  icon: const Icon(Icons.filter_alt_rounded),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    _toggleSortingOrder(SortingOrder.latest);
                    setState(() {
                      sortLatest = true;
                      sortAlphabet = false;
                      sortPrice = false;
                    });
                  },
                  child: Text(
                    'Latest',
                    style: TextStyle(
                        color: sortLatest == true
                            ? const Color.fromARGB(255, 235, 127, 35)
                            : Colors.black),
                  ),
                ),
                const Text(' | '),
                GestureDetector(
                  onTap: () {
                    if (ascendingPrice) {
                      _toggleSortingOrder(SortingOrder.lowToHigh);
                    } else {
                      _toggleSortingOrder(SortingOrder.highToLow);
                    }
                    setState(() {
                      ascendingPrice = !ascendingPrice;
                      sortPrice = true;
                      sortLatest = false;
                      sortAlphabet = false;
                    });
                  },
                  child: Text(
                    'Price ${ascendingPrice ? '↑' : '↓'}',
                    style: TextStyle(
                      color: sortPrice
                          ? const Color.fromARGB(255, 235, 127, 35)
                          : Colors.black,
                    ),
                  ),
                ),
                const Text(' | '),
                GestureDetector(
                  onTap: () {
                    if (ascendingAlphabet) {
                      _toggleSortingOrder(SortingOrder.alphabeticallyAToZ);
                    } else {
                      _toggleSortingOrder(SortingOrder.alphabeticallyZToA);
                    }
                    setState(() {
                      ascendingAlphabet = !ascendingAlphabet;
                      sortAlphabet = true;
                      sortLatest = false;
                      sortPrice = false;
                    });
                  },
                  child: Text(
                    'A-Z ${ascendingAlphabet ? '↑' : '↓'}',
                    style: TextStyle(
                      color: sortAlphabet
                          ? const Color.fromARGB(255, 235, 127, 35)
                          : Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
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

                          bool matchesSelectedFormats = true;
                          if (pdfSelected && !_hasFormat(bookSpecific, 'PDF')) {
                            matchesSelectedFormats = false;
                          }
                          if (printSelected &&
                              !_hasFormat(bookSpecific, 'Buku Cetak')) {
                            matchesSelectedFormats = false;
                          }
                          if (audiobookSelected &&
                              !_hasFormat(bookSpecific, 'Buku Audio')) {
                            matchesSelectedFormats = false;
                          }

                          // If the book matches the selected formats, display it
                          if (matchesSelectedFormats) {
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
                                          borderRadius:
                                              BorderRadius.circular(8),
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
                                                book.isFavorite =
                                                    newLikedStatus;
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
                                    padding: const EdgeInsets.only(top: 0),
                                    child: Text(
                                      bookSpecific.name!,
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      style: const TextStyle(fontSize: 11),
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
                          } else {
                            return const SizedBox.shrink();
                          }
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
      return 0.7; // For smaller screens
    } else if (screenWidth < 1200) {
      return 0.6; // For medium screens
    } else {
      return 1.4; // For larger screens
    }
  }

  bool _hasFormat(HiveBookAPI? book, String format) {
    if (book == null) return false;
    String woocommerceVariationsString = book.woocommerce_variations!;
    List<dynamic> variations = jsonDecode(woocommerceVariationsString);

    return variations.any((variation) {
      return variation['attribute_summary'] == 'Pilihan Format: $format';
    });
  }

  Widget _buildFormatButton(
    IconData icon,
    String text,
    VoidCallback onPressed,
    bool isSelected,
  ) {
    return ElevatedButton(
      onPressed: () {
        onPressed(); // Call the onPressed callback first
        setState(() {}); // Trigger a rebuild to update the button color
      },
      style: ElevatedButton.styleFrom(
        backgroundColor:
            isSelected ? const Color.fromARGB(255, 144, 191, 63) : Colors.white,
        foregroundColor: isSelected
            ? Colors.white
            : const Color.fromARGB(255, 123, 123, 132),
        elevation: 0, // Set elevation to 0 to remove shadow
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: isSelected
                ? Colors.white
                : const Color.fromARGB(255, 123, 123, 132),
          ),
          const SizedBox(width: 10),
          Text(
            text,
            style: TextStyle(
              color: isSelected
                  ? Colors.white
                  : const Color.fromARGB(255, 123, 123, 132),
            ),
          ),
        ],
      ),
    );
  }
}
