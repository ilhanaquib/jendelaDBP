import 'package:flutter/material.dart';
import 'package:jendela_dbp/components/bottom_nav_bar.dart';
import 'package:jendela_dbp/hive/models/hiveBookModel.dart';
import 'package:hive/hive.dart';
import 'package:jendela_dbp/view/pages/book_detail.dart';

class SavedBooks extends StatefulWidget {
  @override
  _SavedBooksState createState() => _SavedBooksState();
}

class _SavedBooksState extends State<SavedBooks> {
  late Box<bool> likedStatusBox;
  late Box<HiveBookAPI> likedBooksBox;

  late List<HiveBookAPI> likedBooks;

  @override
  void initState() {
    super.initState();
    likedBooks = loadLikedBooks();
  }

  List<HiveBookAPI> loadLikedBooks() {
    likedStatusBox = Hive.box<bool>('liked_status');
    likedBooksBox = Hive.box<HiveBookAPI>('liked_books');

    List<int> likedBookKeys = likedStatusBox.keys
        .where((key) => likedStatusBox.get(key, defaultValue: false) == true)
        .map<int>((key) => key as int)
        .toList();

    return likedBookKeys
        .map((key) => likedBooksBox.get(key))
        .whereType<HiveBookAPI>()
        .toList();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Saved Books'),
      ),
      bottomNavigationBar: const BottomNavBar(),
      body: likedBooks.isNotEmpty
          ? ListView.builder(
              itemCount: likedBooks.length,
              itemBuilder: (context, index) {
                HiveBookAPI book = likedBooks[index];
                return SizedBox(
                  width: MediaQuery.of(context).size.width * 0.94,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(bottom: 25, left: 10, right: 10),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BookDetail(
                                  bookImage: book.images!,
                                  bookTitle: book.name!,
                                  bookDesc: book.description!)),
                        );
                      },
                      child: Card(
                        elevation: 0,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.18,
                              width: MediaQuery.of(context).size.width * 0.27,
                              child: Card(
                                elevation: 4,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(book.images!,
                                      fit: BoxFit.cover),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 25, top: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                      capitalizeFirstLetter(book.categories!)),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 25, top: 40),
                              child: IconButton(
                                onPressed: () {
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
                                    setState(() {
                                      // Remove from likedBooksBox using the key
                                      likedBooksBox.delete(keyToDelete);

                                      // Update likedBooks list
                                      likedBooks.removeWhere(
                                          (book) => book.id == bookIdToDelete);
                                    });
                                  }
                                },
                                icon: const Icon(
                                  Icons.delete_outline_rounded,
                                  size: 32,
                                ),
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
              child: Text('You have not liked any books yet.'),
            ),
    );
  }

  String capitalizeFirstLetter(String text) {
    if (text.isEmpty) return '';
    return text[0].toUpperCase() + text.substring(1);
  }
}

Widget _buildCategoryBox(String category) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
    decoration: BoxDecoration(
      color: const Color.fromARGB(255, 144, 191, 63),
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
