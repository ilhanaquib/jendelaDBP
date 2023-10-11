import 'dart:convert' as convert;
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:jendela_dbp/components/bookDetail/buyBottomSheet.dart';
import 'package:jendela_dbp/components/bukuDibeli/downloadButton.dart';
import 'package:jendela_dbp/components/pdfViewer.dart';
import 'package:jendela_dbp/controllers/dbpColor.dart';
import 'package:jendela_dbp/controllers/encryptFile.dart';
import 'package:jendela_dbp/controllers/globalVar.dart';
import 'package:jendela_dbp/hive/models/hivePurchasedBookModel.dart';
import 'package:jendela_dbp/view/pages/audiobooks.dart';
import 'package:jendela_dbp/view/pages/userBooks.dart';
import 'package:like_button/like_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jendela_dbp/controllers/constants.dart';
import 'package:jendela_dbp/components/bookDetail/boughtBookBottomSheet.dart';

import 'package:jendela_dbp/components/DBPImportedWidgets/noDescriptionCard.dart';
import 'package:jendela_dbp/components/bookDetail/chapterList.dart';
import 'package:jendela_dbp/hive/models/hiveBookModel.dart';
import 'package:jendela_dbp/stateManagement/cubits/likedStatusCubit.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:jendela_dbp/components/epubViewer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vocsy_epub_viewer/epub_viewer.dart';

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
  bool _isBookLiked = false;
  final likedBooksBox = Hive.box<HiveBookAPI>('liked_books');
  bool isBookAvailable = false;
  bool isPdf = true;
  final controller = PageController();
  HivePurchasedBook? myDetailsBook;
  bool isDownloadingFile = false;
  bool isDownloadFile = false;
  bool isLoadingBook = true;
  String localPathPermanent = "Tiada";
  String? currentUserID;
  String currentUser = "";
  Box<HivePurchasedBook> PurchasedBook =
      Hive.box<HivePurchasedBook>(GlobalVar.PuchasedBook);
  List<int> myBook = [];
  bool isCompleteLoading = false;
  Box<HiveBookAPI> toCartBook = Hive.box<HiveBookAPI>(GlobalVar.ToCartBook);

  @override
  void initState() {
    super.initState();
    _isBookLiked =
        context.read<LikedStatusCubit>().state[widget.book!.id!] ?? false;

    // Listen to changes in liked status through the cubit
    context.read<LikedStatusCubit>().stream.listen((state) {
      // setState(() {
      //   _isBookLiked = state[widget.bookId] ?? false;
      // });
    });
  }

  void _toggleLikedStatus() async {
    final newLikedStatus = !_isBookLiked;
    final book = widget.bookBox!.get(widget.book!.id);

    // Update liked status in the 'liked_status' box
    await widget.likedStatusBox!.put(widget.book!.id, newLikedStatus);

    // Update liked status in 'liked_books' box
    if (newLikedStatus) {
      likedBooksBox.put(widget.book!.id, book!);
    } else {
      likedBooksBox.delete(widget.book!.id);
    }

    // Update liked status through the cubit
    context
        .read<LikedStatusCubit>()
        .updateLikedStatus(widget.book!.id!, newLikedStatus);

    // setState(() {
    //   _isBookLiked = newLikedStatus;
    // });
  }

  void bottomSheetChapter(BuildContext context) {
    showModalBottomSheet<void>(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        elevation: 0,
        context: context,
        builder: (BuildContext context) {
          return ChapterList(
            book: widget.book,
          );
        });
  }

  void bottomSheetRead(BuildContext context) {
    showModalBottomSheet<void>(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        elevation: 0,
        context: context,
        builder: (BuildContext context) {
          return ChapterList(
            book: widget.book,
          );
        });
  }

  Future<void> buyItem(context) {
    List toJSonVariation =
        convert.json.decode(widget.book!.woocommerce_variations ?? '[]');
    toJSonVariation = toJSonVariation.where((variation) {
      if (variation['status'].toString().toLowerCase() == "publish") {
        return true;
      }
      return false;
    }).toList();

    return showModalBottomSheet(
      useRootNavigator: true,
      elevation: 2,
      barrierColor: Colors.black.withOpacity(0.8),
      backgroundColor: Colors.white,
      context: context,
      builder: (builder) {
        var formatType;

        return SizedBox(
          height: 320,
          child: buyBottomSheet(
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
        return SizedBox(
          height: 150,
          child: boughtBookBottomSheet(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
                                    'Category',
                                    style: TextStyle(
                                      color: DbpColor().jendelaGray,
                                    ),
                                  ),
                                  Text(
                                    getCategory(widget.book!.product_category!),
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
                                    'Language',
                                    style: TextStyle(
                                      color: DbpColor().jendelaGray,
                                    ),
                                  ),
                                  Text(
                                    'Malay',
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
                        const Padding(
                          padding: EdgeInsets.only(top: 30, left: 20),
                          child: Row(
                            children: [
                              Text(
                                'What\'s it about?',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 17),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, top: 10, bottom: 10),
                          child: SizedBox(
                            height: 208,
                            child: SingleChildScrollView(
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
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.82,
                    left: MediaQuery.of(context).size.width * 0.03,
                    child: SafeArea(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
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
                            onPressed: isBookAvailable
                                ? () {
                                    // 1. check if book is downloaded
                                    // 2. if book isnt downloaded, open a popup that asks user to download book/
                                    boughtBook(context);
                                  }
                                : () {
                                    buyItem(context);
                                  },

                            // isPdf
                            //     ? Navigator.push(
                            //         context,
                            //         MaterialPageRoute(
                            //           builder: (context) =>
                            //               PdfViewerPage(
                            //             book: widget.book,
                            //           ),
                            //         ),
                            //       )
                            //     :
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //       builder: (context) =>
                            //           EpubViewerPage(
                            //         book: widget.book,
                            //       ),
                            //     ),
                            //   );

                            //       VocsyEpub.setConfig(
                            //           identifier: "iosBook",
                            //           scrollDirection:
                            //               EpubScrollDirection
                            //                   .HORIZONTAL,
                            //           allowSharing: true,
                            //           enableTts: true,
                            //           nightMode: false,

                            //         );
                            //   // get current locator
                            //   VocsyEpub.locatorStream
                            //       .listen((locator) {
                            //     print('LOCATOR: $locator');
                            //   });
                            //   VocsyEpub.openAsset(
                            //     'assets/books/accessible_epub_3.epub',
                            //     lastLocation:
                            //         EpubLocator.fromJson({
                            //       "bookId": "2239",
                            //       "href": "/OEBPS/ch06.xhtml",
                            //       "created": 1539934158390,
                            //       "locations": {
                            //         "cfi":
                            //             "epubcfi(/0!/4/4[simple_book]/2/2/6)"
                            //       }
                            //     }),
                            //   );
                            // }

                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.import_contacts_rounded,
                                    color: DbpColor().jendelaOrange,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Read Book',
                                    style: TextStyle(
                                      color: DbpColor().jendelaOrange,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 29,
                          ),
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              backgroundColor: DbpColor().jendelaOrange,
                              side: BorderSide(
                                color: DbpColor().jendelaOrange,
                              ),
                            ),
                            onPressed: () {
                              PersistentNavBarNavigator.pushNewScreen(
                                context,
                                screen: Audiobooks(
                                    // book: widget.book,
                                    ),
                              );
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.headphones_rounded,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Play Audio',
                                    style: TextStyle(color: Colors.white),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
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

  bool _hasFormat(HiveBookAPI? book, String format) {
    if (book == null) return false;
    String woocommerceVariationsString = book.woocommerce_variations!;
    List<dynamic> variations = convert.jsonDecode(woocommerceVariationsString);

    return variations.any((variation) {
      return variation['attribute_summary'] == 'Pilihan Format: $format';
    });
  }
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
