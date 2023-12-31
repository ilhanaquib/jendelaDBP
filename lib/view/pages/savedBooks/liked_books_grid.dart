import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:jendela_dbp/components/cart/cart_icon.dart';
import 'package:jendela_dbp/components/ujana/home_drawer.dart';
import 'package:jendela_dbp/controllers/global_var.dart';
import 'package:jendela_dbp/controllers/screen_size.dart';
import 'package:like_button/like_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'package:jendela_dbp/components/DBPImportedWidgets/no_books_liked_card.dart';
import 'package:jendela_dbp/controllers/liked_books_management.dart';
import 'package:jendela_dbp/hive/models/hive_book_model.dart';
import 'package:jendela_dbp/stateManagement/cubits/liked_status_cubit.dart';
import 'package:jendela_dbp/view/pages/book_details.dart';

import 'package:jendela_dbp/controllers/dbp_color.dart';

class LikedBooksGrid extends StatefulWidget {
  const LikedBooksGrid({super.key, this.controller});
  // ignore: prefer_typing_uninitialized_variables
  final controller;

  @override
  State<LikedBooksGrid> createState() => _LikedBooksGridState();
}

class _LikedBooksGridState extends State<LikedBooksGrid> {
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
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    final GlobalKey appBarKey = GlobalKey();
    String getCategory(String category) {
      final categoryMap = {
        GlobalVar.kategori1: GlobalVar.kategori1Title,
        GlobalVar.kategori2: GlobalVar.kategori2Title,
        GlobalVar.kategori3: GlobalVar.kategori3Title,
        GlobalVar.kategori4: GlobalVar.kategori4Title,
        GlobalVar.kategori5: GlobalVar.kategori5Title,
        GlobalVar.kategori6: GlobalVar.kategori6Title,
        GlobalVar.kategori7: GlobalVar.kategori7Title,
        GlobalVar.kategori8: GlobalVar.kategori8Title,
        GlobalVar.kategori9: GlobalVar.kategori9Title,
        GlobalVar.kategori10: GlobalVar.kategori10Title,
        GlobalVar.kategori11: GlobalVar.kategori11Title,
        GlobalVar.kategori12: GlobalVar.kategori12Title,
        GlobalVar.kategori13: GlobalVar.kategori13Title,
        GlobalVar.kategori14: GlobalVar.kategori14Title,
        GlobalVar.kategori15: GlobalVar.kategori15Title,
        GlobalVar.kategori16: GlobalVar.kategori16Title,
      };
      return categoryMap[category] ?? 'Unknown Category';
    }

    double imageWidth;
    if (ResponsiveLayout.isDesktop(context)) {
      imageWidth = 200;
    } else if (ResponsiveLayout.isTablet(context)) {
      imageWidth = 150;
    } else {
      imageWidth = 100;
    }
    EdgeInsetsGeometry padding;
    if (ResponsiveLayout.isDesktop(context)) {
      padding = const EdgeInsets.only(top: 200);
    } else if (ResponsiveLayout.isTablet(context)) {
      padding = const EdgeInsets.only(top: 100);
    } else {
      padding = const EdgeInsets.only(top: 50);
    }
    double mainAxisSpacing;
    if (ResponsiveLayout.isDesktop(context)) {
      mainAxisSpacing = 50;
    } else {
      mainAxisSpacing = 10;
    }
    double crossAxisSpacing;
    if (ResponsiveLayout.isDesktop(context)) {
      crossAxisSpacing = 50;
    } else {
      crossAxisSpacing = 10;
    }
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(88.0),
        child: Column(
          children: [
            AppBar(
              backgroundColor: Colors.white,
              key: appBarKey,
              centerTitle: true,
              title: const Text('Buku Kegemaran'),
              leading: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: GestureDetector(
                    onTap: () {
                      scaffoldKey.currentState?.openDrawer();
                    },
                    child: Image.asset('assets/images/logo.png')
                    // CircleAvatar(
                    //   backgroundImage:
                    //       context.watch<ImageBloc>().selectedImageProvider ??
                    //           const AssetImage('assets/images/logo.png'),
                    // ),
                    ),
              ),
              actions: const [
                Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: CartIcon(),
                ),
              ],
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
                  onDotClicked: (index) => widget.controller.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeIn),
                ),
              ],
            ),
          ],
        ),
      ),
      drawer: const HomeDrawer(),
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
              ? GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: ResponsiveLayout.isDesktop(context) ? 3 : 2,
                    mainAxisSpacing: mainAxisSpacing,
                    crossAxisSpacing: crossAxisSpacing,
                    childAspectRatio:
                        ResponsiveLayout.isDesktop(context) ? 1.32 : 1,
                  ),
                  itemCount: likedBooks.length,
                  itemBuilder: (context, index) {
                    HiveBookAPI book = likedBooks[index];
                    return GestureDetector(
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
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SizedBox(
                              width: imageWidth,
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
                              padding: const EdgeInsets.only(left: 25, top: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 170,
                                    child: Text(
                                      book.name!,
                                      maxLines: 3,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  _buildCategoryBox(
                                    capitalizeFirstLetter(
                                        getCategory(book.productCategory!)),
                                  ),
                                  Padding(
                                    padding: padding,
                                    child: LikeButton(
                                      bubblesColor: const BubblesColor(
                                        dotPrimaryColor:
                                            Color.fromARGB(255, 245, 88, 88),
                                        dotSecondaryColor: Colors.white,
                                      ),
                                      isLiked: true,
                                      onTap: (bool isLiked) async {
                                        int bookIdToDelete = book.id!;

                                        int? keyToDelete;

                                        for (var entry
                                            in likedBooksBox.toMap().entries) {
                                          if (entry.value.id ==
                                              bookIdToDelete) {
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

                                          _updateLikedStatus(
                                              keyToDelete, false);
                                        }
                                        return null;
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
                          ],
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
