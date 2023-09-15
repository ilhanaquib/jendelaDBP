import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:jendela_dbp/view/pages/audiobooks.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import 'package:jendela_dbp/components/DBPImportedWidgets/notFoundCard.dart';
import 'package:jendela_dbp/hive/models/hiveBookModel.dart';
import 'package:jendela_dbp/stateManagement/cubits/likedStatusCubit.dart';
import 'package:jendela_dbp/view/pages/bookDetails.dart';

class AudiosInsideShelf extends StatefulWidget {
  final List<dynamic> dataBooks;
  final Box<HiveBookAPI> bookBox;

  AudiosInsideShelf({required this.dataBooks, required this.bookBox});

  @override
  _AudiosInsideShelfState createState() => _AudiosInsideShelfState();
}

class _AudiosInsideShelfState extends State<AudiosInsideShelf> {
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
  }

  void dispose() {
    super.dispose();
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
                scrollDirection: Axis.vertical,
                itemCount: widget.dataBooks.length,
                itemBuilder: (context, index) {
                  final int key = widget.dataBooks[index];
                  final HiveBookAPI? bookSpecific = widget.bookBox.get(key);
                  String woocommerceVariationsString =
                      bookSpecific!.woocommerce_variations!;
                  List<dynamic> variations =
                      jsonDecode(woocommerceVariationsString);
                  String format = '';

                  // Check if the book has the format 'Buku Audio'
                  bool hasBukuAudioFormat = variations.any((variation) {
                    return variation['attribute_summary'] ==
                        'Pilihan Format: Buku Audio';
                  });

                  // Skip books that don't have the 'Buku Audio' format
                  if (!hasBukuAudioFormat) {
                    return SizedBox
                        .shrink(); // Return an empty SizedBox to hide the book
                  }

                  return Padding(
                    padding: const EdgeInsets.only(left: 0),
                    child: GestureDetector(
                      onTap: () {
                        PersistentNavBarNavigator.pushNewScreen(
                          context,
                          withNavBar: false,
                          screen: BlocProvider.value(
                            value: context.read<LikedStatusCubit>(),
                            child: BookDetail(
                              bookId: key,
                              bookImage: bookSpecific.images!,
                              bookTitle: bookSpecific.name!,
                              bookDesc: bookSpecific.description!,
                              bookPrice: bookSpecific.price!,
                              bookBox: widget.bookBox,
                            ),
                          ),
                        );
                      },
                      child: Card(
                        elevation: 0,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.18,
                              width: MediaQuery.of(context).size.width * 0.27,
                              child: Card(
                                elevation: 4,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(bookSpecific!.images!,
                                      fit: BoxFit.cover),
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 170,
                                  child: Text(
                                    bookSpecific.name!,
                                    maxLines: 2,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                Text('RM${bookSpecific.price!}'),
                                const Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: SizedBox(
                                    width: 150,
                                    child: LinearProgressIndicator(
                                      color: Color.fromARGB(255, 235, 127, 35),
                                      value: 2,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            CircleAvatar(
                              backgroundColor:
                                  const Color.fromARGB(255, 123, 123, 123),
                              radius: 22,
                              child: Center(
                                // Center widget to center the IconButton
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 20,
                                  child: IconButton(
                                    onPressed: () {
                                      PersistentNavBarNavigator.pushNewScreen(
                                        context,
                                        withNavBar: false,
                                        screen: Audiobooks(
                                          bookDesc: bookSpecific.description!,
                                          bookId: bookSpecific.id!,
                                          bookImage: bookSpecific.images!,
                                          bookPrice: bookSpecific.price!,
                                          bookTitle: bookSpecific.name!,
                                        ),
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.play_arrow_rounded,
                                      color: Color.fromARGB(255, 123, 123, 123),
                                    ),
                                  ),
                                ),
                              ),
                            ),
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
