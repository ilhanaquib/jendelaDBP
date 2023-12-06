import 'dart:convert' as convert;
import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jendela_dbp/components/bookDetail/no_format.dart';
import 'package:jendela_dbp/components/cart/cart_icon.dart';
import 'package:jendela_dbp/controllers/screen_size.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import 'package:jendela_dbp/components/DBPImportedWidgets/no_description_card.dart';
import 'package:jendela_dbp/components/bookDetail/buy_bottom_sheet.dart';
import 'package:jendela_dbp/components/bookDetail/bought_book_bottom_sheet.dart';
import 'package:jendela_dbp/hive/models/hiveBookModel.dart';
import 'package:jendela_dbp/hive/models/hivePurchasedBookModel.dart';
import 'package:jendela_dbp/controllers/dbp_color.dart';
import 'package:jendela_dbp/controllers/global_var.dart';
import 'package:jendela_dbp/stateManagement/cubits/liked_status_cubit.dart';
import 'package:jendela_dbp/view/pages/audiobooks/audiobooks.dart';

// ignore: must_be_immutable
class BookDetail extends StatefulWidget {
  BookDetail(
      {super.key,
      this.book,
      this.likedStatusBox,
      this.bookBox,
      this.bookIdentification});

  final HiveBookAPI? book;
  final Box<bool>? likedStatusBox;
  final Box<HiveBookAPI>? bookBox;
  HivePurchasedBook? bookIdentification;

  @override
  State<BookDetail> createState() => _BookDetailState();
}

class _BookDetailState extends State<BookDetail> {
  //bool _isBookLiked = false;
  final likedBooksBox = Hive.box<HiveBookAPI>('liked_books');
  bool isBookAvailable = false;
  bool isPdf = true;
  final controller = PageController();
  Box<HiveBookAPI> toCartBook = Hive.box<HiveBookAPI>(GlobalVar.toCartBook);
  Box<HivePurchasedBook> purchasedBooks =
      Hive.box<HivePurchasedBook>(GlobalVar.puchasedBook);
  Set<String> selectedFormats = {};
  dynamic format;

  bool isBookPurchased(int bookId) {
    return purchasedBooks.containsKey(bookId);
  }

  HivePurchasedBook getBook(int bookId) {
    return HivePurchasedBook();
  }

  @override
  void initState() {
    super.initState();
    // _isBookLiked =
    //     context.read<LikedStatusCubit>().state[widget.book!.id!] ?? false;

    // Listen to changes in liked status through the cubit
    context.read<LikedStatusCubit>().stream.listen((state) {
      // setState(() {
      //   _isBookLiked = state[widget.bookId] ?? false;
      // });
    });
  }

  // void _toggleLikedStatus() async {
  //   final newLikedStatus = !_isBookLiked;
  //   final book = widget.bookBox!.get(widget.book!.id);

  //   // Update liked status in the 'liked_status' box
  //   await widget.likedStatusBox!.put(widget.book!.id, newLikedStatus);

  //   // Update liked status in 'liked_books' box
  //   if (newLikedStatus) {
  //     likedBooksBox.put(widget.book!.id, book!);
  //   } else {
  //     likedBooksBox.delete(widget.book!.id);
  //   }

  //   // Update liked status through the cubit
  //   context
  //       .read<LikedStatusCubit>()
  //       .updateLikedStatus(widget.book!.id!, newLikedStatus);

  //   // setState(() {
  //   //   _isBookLiked = newLikedStatus;
  //   // });
  // }

  // void bottomSheetChapter(BuildContext context) {
  //   showModalBottomSheet<void>(
  //       backgroundColor: const Color.fromARGB(255, 255, 255, 255),
  //       elevation: 0,
  //       context: context,
  //       builder: (BuildContext context) {
  //         return ChapterList(
  //           book: widget.book,
  //         );
  //       });
  // }

  // void bottomSheetRead(BuildContext context) {
  //   showModalBottomSheet<void>(
  //       backgroundColor: const Color.fromARGB(255, 255, 255, 255),
  //       elevation: 0,
  //       context: context,
  //       builder: (BuildContext context) {
  //         return ChapterList(
  //           book: widget.book,
  //         );
  //       });
  // }

  Future<void> buyItem(context) {
    List toJSonVariation =
        convert.json.decode(widget.book!.woocommerceVariations ?? '[]');
    toJSonVariation = toJSonVariation.where((variation) {
      if (variation['status'].toString().toLowerCase() == "publish") {
        return true;
      }
      return false;
    }).toList();

    return showModalBottomSheet(
      useRootNavigator: true,
      elevation: 0,
      barrierColor: Colors.black.withOpacity(0.8),
      backgroundColor: Colors.white,
      context: context,
      builder: (builder) {
        dynamic formatType;

        return SizedBox(
          height: 300,
          child: BuyBottomSheet(
            book: widget.book,
            toJSonVariation: toJSonVariation,
            formatType: formatType,
            toCartBook: toCartBook,
          ),
        );
      },
    );
  }

  Future<void> boughtBook(context) {
    return showModalBottomSheet(
      useRootNavigator: true,
      elevation: 2,
      barrierColor: Colors.black.withOpacity(0.8),
      backgroundColor: Colors.white,
      context: context,
      builder: (builder) {
        return const SizedBox(
          height: 150,
          child: BoughtBookBottomSheet(),
        );
      },
    );
  }

  Future<void> noFormat(context) {
    return showModalBottomSheet(
      useRootNavigator: true,
      elevation: 2,
      barrierColor: Colors.black.withOpacity(0.8),
      backgroundColor: Colors.white,
      context: context,
      builder: (builder) {
        return const SizedBox(
          height: 150,
          child: NoFormatSheet(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double containerWidth;
    if (ResponsiveLayout.isDesktop(context)) {
      // Increase left and right padding for desktop
      containerWidth = 500;
    } else if (ResponsiveLayout.isTablet(context)) {
      // Increase left and right padding for tablets
      containerWidth = 400;
    } else {
      // Use the default padding for phones and other devices
      containerWidth = 300;
    }
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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 246, 239),
        actions: const [
          Padding(
            padding:  EdgeInsets.only(right: 10),
            child: CartIcon(),
          )
        ],
        // actions: [
        //   LikeButton(
        //     size: 20,
        //     bubblesColor: const BubblesColor(
        //       dotPrimaryColor: Color.fromARGB(255, 245, 88, 88),
        //       dotSecondaryColor: Colors.white,
        //     ),
        //     isLiked: _isBookLiked,
        //     onTap: (isLiked) async {
        //       _toggleLikedStatus(); // Toggle the liked status (void function)
        //       return !_isBookLiked; // Return the new liked status
        //     },
        //     likeBuilder: (bool isLiked) {
        //       return Icon(
        //         isLiked
        //             ? Icons.favorite_rounded
        //             : Icons.favorite_border_rounded,
        //         color: Color(0xfff55858),
        //         size: 20,
        //       );
        //     },
        //   ),
        // ],
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
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: Stack(
                children: [
                  const CurvedBackground(),
                  Center(
                    child: SingleChildScrollView(
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
                                    imageUrl: widget.book!.images!,
                                    width: 150,
                                    fit: BoxFit.fill,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              widget.book!.name!,
                              textAlign:
                                  TextAlign.center, // Center-aligns the text
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          // Text(
                          //   'book author',
                          //   style: TextStyle(
                          //     color: DbpColor().jendelaGray,
                          //   ),
                          // ),
                          Container(
                            height: 100,
                            width: containerWidth,
                            margin: const EdgeInsets.only(
                                left: 50, right: 50, top: 20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(12),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  spreadRadius: 2,
                                  blurRadius: 2,
                                  offset: const Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Kategori',
                                      style: TextStyle(
                                        color: DbpColor().jendelaGray,
                                      ),
                                    ),
                                    Text(
                                      getCategory(
                                          widget.book!.productCategory!),
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: DbpColor().jendelaGray,
                                      ),
                                    )
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Bahasa',
                                      style: TextStyle(
                                        color: DbpColor().jendelaGray,
                                      ),
                                    ),
                                    Text(
                                      'Melayu',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: DbpColor().jendelaGray,
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          if (ResponsiveLayout.isDesktop(context))
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 400, right: 400),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(top: 30),
                                    child: Text(
                                      'Tentang Buku',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, bottom: 100),
                                    child: SizedBox(
                                      height: 212,
                                      child: widget.book!.description!.isEmpty
                                          ? const NoDescriptionCard()
                                          : Text(
                                              widget.book!.description!,
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: DbpColor().jendelaBlack,
                                                height: 1.5,
                                              ),
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          else
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(top: 30),
                                    child: Text(
                                      'Tentang Buku',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, bottom: 100),
                                    child: SizedBox(
                                      height: 212,
                                      child: widget.book!.description!.isEmpty
                                          ? const NoDescriptionCard()
                                          : Text(
                                              widget.book!.description!,
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: DbpColor().jendelaBlack,
                                                height: 1.5,
                                              ),
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                        ],
                      ),
                    ),
                  ),
                  if (ResponsiveLayout.isDesktop(context) ||
                      ResponsiveLayout.isTablet(context))
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 70,
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(
                                width: 10,
                              ),
                              OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  side: BorderSide(
                                    color: DbpColor().jendelaOrange,
                                  ),
                                ),
                                // 1. check if the book is purchased
                                // 2. if book isnt purchased, should buy
                                // 3. if book is purhcaesd, open the book pdf/epub
                                onPressed: isBookPurchased(widget.book!.id!)
                                    ? () {
                                        // 1. check if book is downloaded
                                        // 2. if book isnt downloaded, open a popup that asks user to download book/
                                        boughtBook(context);
                                      }
                                    : () {
                                        buyItem(context);
                                      },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.import_contacts_rounded,
                                        color: DbpColor().jendelaOrange,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Baca Buku',
                                            style: TextStyle(
                                              color: DbpColor().jendelaOrange,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 24,
                              ),
                              OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: DbpColor().jendelaOrange,
                                  side: BorderSide(
                                    color: DbpColor().jendelaOrange,
                                  ),
                                ),
                                onPressed: () {
                                  List toJSonVariation = convert.json.decode(
                                      widget.book!.woocommerceVariations ??
                                          '[]');

                                  toJSonVariation =
                                      toJSonVariation.where((variation) {
                                    return variation['status']
                                            .toString()
                                            .toLowerCase() ==
                                        "publish";
                                  }).toList();

                                  List<String> format = List.generate(
                                      toJSonVariation.length, (index) {
                                    return toJSonVariation[index]
                                                ['attributes']![
                                            "pa_pilihan-format"] is String
                                        ? "Pilihan Format: ${toJSonVariation[index]['attributes']!["pa_pilihan-format"]}"
                                        : "Pilihan Format: Buku Cetak";
                                  });

                                  String joinedFormat = format.join(", ");
                                  joinedFormat = joinedFormat.split(":")[1];

                                  if (joinedFormat
                                          .toLowerCase()
                                          .contains('audio') ||
                                      joinedFormat
                                          .toLowerCase()
                                          .contains('mp3')) {
                                    if (isBookPurchased(widget.book!.id!)) {
                                      PersistentNavBarNavigator.pushNewScreen(
                                        context,
                                        screen: Audiobooks(
                                          book: widget.bookIdentification,
                                        ),
                                      );
                                    } else {
                                      buyItem(context);
                                    }
                                  } else {
                                    noFormat(context);
                                  }
                                },
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.headphones_rounded,
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Main Audio',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  else
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 70,
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              // read book button
                              OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  side: BorderSide(
                                    color: DbpColor().jendelaOrange,
                                  ),
                                ),
                                // 1. check if the book is purchased
                                // 2. if book isnt purchased, should buy
                                // 3. if book is purhcaesd, open the book pdf/epub
                                onPressed: isBookPurchased(widget.book!.id!)
                                    ? () {
                                        // 1. check if book is downloaded
                                        // 2. if book isnt downloaded, open a popup that asks user to download book
                                        boughtBook(context);
                                      }
                                    : () {
                                        buyItem(context);
                                      },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.import_contacts_rounded,
                                        color: DbpColor().jendelaOrange,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Baca',
                                            style: TextStyle(
                                              color: DbpColor().jendelaOrange,
                                            ),
                                          ),
                                          Text(
                                            'Buku',
                                            style: TextStyle(
                                              color: DbpColor().jendelaOrange,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              // play audio button
                              OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: DbpColor().jendelaOrange,
                                  side: BorderSide(
                                    color: DbpColor().jendelaOrange,
                                  ),
                                ),
                                onPressed: () {
                                  List toJSonVariation = convert.json.decode(
                                      widget.book!.woocommerceVariations ??
                                          '[]');

                                  toJSonVariation =
                                      toJSonVariation.where((variation) {
                                    return variation['status']
                                            .toString()
                                            .toLowerCase() ==
                                        "publish";
                                  }).toList();

                                  List<String> format = List.generate(
                                      toJSonVariation.length, (index) {
                                    return toJSonVariation[index]
                                                ['attributes']![
                                            "pa_pilihan-format"] is String
                                        ? "Pilihan Format: ${toJSonVariation[index]['attributes']!["pa_pilihan-format"]}"
                                        : "Pilihan Format: Buku Cetak";
                                  });

                                  String joinedFormat = format.join(", ");
                                  joinedFormat = joinedFormat.split(":")[1];

                                  if (joinedFormat
                                          .toLowerCase()
                                          .contains('audio') ||
                                      joinedFormat
                                          .toLowerCase()
                                          .contains('mp3')) {
                                    if (isBookPurchased(widget.book!.id!)) {
                                      PersistentNavBarNavigator.pushNewScreen(
                                        context,
                                        screen: Audiobooks(
                                          book: widget.bookIdentification,
                                        ),
                                      );
                                    } else {
                                      buyItem(context);
                                    }
                                  } else {
                                    noFormat(context);
                                  }
                                },
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.headphones_rounded,
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Main',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          Text(
                                            'Audio',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  // bool _hasFormat(HiveBookAPI? book, String format) {
  //   if (book == null) return false;
  //   String woocommerceVariationsString = book.woocommerce_variations!;
  //   List<dynamic> variations = convert.jsonDecode(woocommerceVariationsString);
  //   print(variations);

  //   return variations.any((variation) {
  //     return variation['attribute_summary'] == 'Pilihan Format: $format';
  //   });
  // }
}

class CurvedBackground extends StatelessWidget {
  const CurvedBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(MediaQuery.of(context).size.width,
          300), // Set the size of the curved background
      painter: CurvedBackgroundPainter(),
    );
  }
}

class CurvedBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Define the colors and the curved divider path
    final Paint paint = Paint();
    paint.color = Colors.white; // First background color
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    paint.color =
        const Color.fromARGB(255, 255, 246, 239); // Second background color
    final Path path = Path()
      ..moveTo(0, size.height * 1.0) // Start point of the curve
      ..quadraticBezierTo(size.width * 0.5, size.height * 1.5, size.width,
          size.height * 1.0) // Control and end points of the curve
      ..lineTo(size.width, 0) // Line to the top right corner
      ..lineTo(0, 0) // Line back to the top left corner
      ..close(); // Close the path
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
