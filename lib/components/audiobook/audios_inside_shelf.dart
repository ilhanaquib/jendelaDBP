import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:jendela_dbp/controllers/global_var.dart';
import 'package:jendela_dbp/controllers/screen_size.dart';
import 'package:jendela_dbp/hive/models/hive_purchased_book_model.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import 'package:jendela_dbp/components/DBPImportedWidgets/not_found_card.dart';
import 'package:jendela_dbp/hive/models/hive_book_model.dart';
import 'package:jendela_dbp/stateManagement/cubits/liked_status_cubit.dart';
import 'package:jendela_dbp/view/pages/book_details.dart';

class AudiosInsideShelf extends StatefulWidget {
  final List<dynamic> dataBooks;
  final Box<HiveBookAPI> bookBox;

  const AudiosInsideShelf(
      {super.key, required this.dataBooks, required this.bookBox});

  @override
  State<AudiosInsideShelf> createState() => _AudiosInsideShelfState();
}

class _AudiosInsideShelfState extends State<AudiosInsideShelf> {
  Box<HivePurchasedBook> purchasedBooks =
      Hive.box<HivePurchasedBook>(GlobalVar.puchasedBook);

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

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double imageWidth;
    if (ResponsiveLayout.isDesktop(context)) {
      imageWidth = 250;
    } else if (ResponsiveLayout.isTablet(context)) {
      imageWidth = 200;
    } else {
      imageWidth = 100;
    }
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
                      bookSpecific!.woocommerceVariations!;
                  List<dynamic> variations =
                      jsonDecode(woocommerceVariationsString);

                  bool hasBukuAudioFormat = variations.any((variation) {
                    return variation['attribute_summary'] ==
                        'Pilihan Format: Buku Audio';
                  });

                  if (!hasBukuAudioFormat) {
                    return const SizedBox
                        .shrink();
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
                              book: bookSpecific,
                              bookBox: widget.bookBox,
                            ),
                          ),
                        );
                      },
                      child: Card(
                        elevation: 0,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              child: SizedBox(
                                width: imageWidth,
                                child: Card(
                                  elevation: 4,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(bookSpecific.images!,
                                        fit: BoxFit.cover),
                                  ),
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
                              ],
                            ),
                            // CircleAvatar(
                            //   backgroundColor:
                            //       const Color.fromARGB(255, 123, 123, 123),
                            //   radius: 22,
                            //   child: Center(
                            //     // Center widget to center the IconButton
                            //     child: CircleAvatar(
                            //       backgroundColor: Colors.white,
                            //       radius: 20,
                            //       child: IconButton(
                            //         onPressed: () {
                            //           PersistentNavBarNavigator.pushNewScreen(
                            //             context,
                            //             withNavBar: false,
                            //             screen: Audiobooks(
                            //              book: bookSpecific,
                            //             ),
                            //           );
                            //         },
                            //         icon: const Icon(
                            //           Icons.play_arrow_rounded,
                            //           color: Color.fromARGB(255, 123, 123, 123),
                            //         ),
                            //       ),
                            //     ),
                            //   ),
                            // ),
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
