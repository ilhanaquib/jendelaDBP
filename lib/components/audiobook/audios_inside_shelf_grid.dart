import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:jendela_dbp/controllers/screen_size.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import 'package:jendela_dbp/components/DBPImportedWidgets/not_found_card.dart';
import 'package:jendela_dbp/hive/models/hiveBookModel.dart';
import 'package:jendela_dbp/stateManagement/cubits/liked_status_cubit.dart';
import 'package:jendela_dbp/view/pages/book_details.dart';

class AudiosInsideShelfGrid extends StatefulWidget {
  final List<dynamic> dataBooks;
  final Box<HiveBookAPI> bookBox;

  const AudiosInsideShelfGrid(
      {super.key, required this.dataBooks, required this.bookBox});

  @override
  // ignore: library_private_types_in_public_api
  _AudiosInsideShelfGridState createState() => _AudiosInsideShelfGridState();
}

class _AudiosInsideShelfGridState extends State<AudiosInsideShelfGrid> {
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
      // Increase left and right padding for desktop
      imageWidth = 250;
    } else if (ResponsiveLayout.isTablet(context)) {
      // Increase left and right padding for tablets
      imageWidth = 200;
    } else {
      // Use the default padding for phones and other devices
      imageWidth = 100;
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: widget.dataBooks.isEmpty
          ? const Center(
              child: NotFoundCard(),
            )
          : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: ResponsiveLayout.isDesktop(context) ? 3 : 2,
                mainAxisSpacing: 1,
                crossAxisSpacing: 1,
                childAspectRatio:
                    ResponsiveLayout.isDesktop(context) ? 1.32 : 0.1,
              ),
              scrollDirection: Axis.vertical,
              itemCount: widget.dataBooks.length,
              itemBuilder: (context, index) {
                final int key = widget.dataBooks[index];
                final HiveBookAPI? bookSpecific = widget.bookBox.get(key);
                String woocommerceVariationsString =
                    bookSpecific!.woocommerceVariations!;
                List<dynamic> variations =
                    jsonDecode(woocommerceVariationsString);

                // Check if the book has the format 'Buku Audio'
                bool hasBukuAudioFormat = variations.any((variation) {
                  return variation['attribute_summary'] ==
                      'Pilihan Format: Buku Audio';
                });

                // Skip books that don't have the 'Buku Audio' format
                if (!hasBukuAudioFormat) {
                  return const SizedBox
                      .shrink(); // Return an empty SizedBox to hide the book
                }

                return GestureDetector(
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
                          padding: const EdgeInsets.only(left: 20, right: 20),
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
                );
              },
            ),
    );
  }
}
