import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:jendela_dbp/controllers/likedBooksManagement.dart';
import 'package:jendela_dbp/hive/models/hiveBookModel.dart';
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


  late Box<bool> likedStatusBox;

  @override
  void initState() {
    super.initState();
    _openLikedStatusBox();
  }

  Future<void> _openLikedStatusBox() async {
    likedStatusBox = await Hive.openBox<bool>('liked_status');

    for (final key in widget.listBook) {
      final isLiked = likedStatusBox.get(key, defaultValue: false) ?? false;

      // Update the liked status in the HiveBookAPI model
      final book = widget.bookBox.get(key);
      if (book != null) {
        book.isFavorite = isLiked;
        widget.bookBox.put(key, book);
      }

      setState(() {
        LikedStatusManager.likedBooks[key] = isLiked;
      });
    }
  }

  void _updateLikedStatus(int bookId, bool isLiked) {
    setState(() {
      LikedStatusManager.updateLikedStatus(bookId, isLiked);
    });
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
      body: CustomScrollView(
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
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            childAspectRatio: 0.6),
                    itemCount: widget.listBook.length,
                    itemBuilder: (context, index) {
                      final int key = widget.listBook[index];
                      final HiveBookAPI? bookSpecific = widget.bookBox.get(key);
                      final isBookLiked = LikedStatusManager.likedBooks[key] ?? false;

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BookDetail(
                                bookImage: bookSpecific.images!,
                                bookTitle: bookSpecific.name!,
                                bookDesc: bookSpecific.description!,
                                bookPrice: bookSpecific.price!,
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
                                      imageUrl: bookSpecific!.images!,
                                      height: 150,
                                      width: 100,
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
                                            offset: const Offset(-2.7, -1.7),
                                            child: IconButton(
                                              onPressed: () async {
                                                final newLikedStatus =
                                                    !isBookLiked;

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
                                                }
                                                _updateLikedStatus(
                                                    key, newLikedStatus);

                                                setState(() {
                                                  LikedStatusManager.likedBooks[key] =
                                                      newLikedStatus;
                                                });
                                              },
                                              icon: const Icon(
                                                Icons.favorite_border_rounded,
                                                color: Colors.white,
                                                size: 20,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Text(
                              bookSpecific.name!,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              style: TextStyle(fontSize: 10),
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
      ),
    );
  }
}
