import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jendela_dbp/components/DBPImportedWidgets/noDescriptionCard.dart';
import 'package:jendela_dbp/components/chapterList.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:jendela_dbp/hive/models/hiveBookModel.dart';
import 'package:jendela_dbp/stateManagement/cubits/likedStatusCubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:like_button/like_button.dart';

class BookDetail extends StatefulWidget {
  const BookDetail(
      {super.key,
      required this.bookId,
      required this.bookImage,
      required this.bookTitle,
      required this.bookDesc,
      required this.bookPrice,
      this.likedStatusBox,
      this.bookBox});

  final int bookId;
  final String bookTitle;
  final String bookImage;
  final String bookDesc;
  final String bookPrice;
  final Box<bool>? likedStatusBox;
  final Box<HiveBookAPI>? bookBox;

  @override
  State<BookDetail> createState() => _BookDetailState();
}

class _BookDetailState extends State<BookDetail> {
  bool _isBookLiked = false;
  final likedBooksBox = Hive.box<HiveBookAPI>('liked_books');

  @override
  void initState() {
    super.initState();
    _isBookLiked =
        context.read<LikedStatusCubit>().state[widget.bookId] ?? false;

    // Listen to changes in liked status through the cubit
    context.read<LikedStatusCubit>().stream.listen((state) {
      // setState(() {
      //   _isBookLiked = state[widget.bookId] ?? false;
      // });
    });
  }

  void _toggleLikedStatus() async {
    final newLikedStatus = !_isBookLiked;
    final book = widget.bookBox!.get(widget.bookId);

    // Update liked status in the 'liked_status' box
    await widget.likedStatusBox!.put(widget.bookId, newLikedStatus);

    // Update liked status in 'liked_books' box
    if (newLikedStatus) {
      likedBooksBox.put(widget.bookId, book!);
    } else {
      likedBooksBox.delete(widget.bookId);
    }

    // Update liked status through the cubit
    context
        .read<LikedStatusCubit>()
        .updateLikedStatus(widget.bookId, newLikedStatus);

    // setState(() {
    //   _isBookLiked = newLikedStatus;
    // });
  }

  void bottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        elevation: 0,
        context: context,
        builder: (BuildContext context) {
          return const ChapterList();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 246, 239),
        actions: [
          LikeButton(
            size: 20,
            bubblesColor: const BubblesColor(
              dotPrimaryColor: Color.fromARGB(255, 245, 88, 88),
              dotSecondaryColor: Colors.white,
            ),
            likeBuilder: (bool isLiked) {
              return Icon(
                isLiked
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                color: Color(0xfff55858),
                size: 20,
              );
            },
            isLiked: _isBookLiked,
            onTap: (isLiked) async {
              _toggleLikedStatus(); // Toggle the liked status (void function)
              return !_isBookLiked; // Return the new liked status
            },
          ),
        ],
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
                                  imageUrl: widget.bookImage,
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
                            widget.bookTitle,
                            textAlign:
                                TextAlign.center, // Center-aligns the text
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        const Text(
                          'Book Author',
                          style: TextStyle(
                              color: Color.fromARGB(255, 123, 123, 123)),
                        ),
                        Container(
                          height: 100,
                          margin: const EdgeInsets.only(
                              left: 50, right: 50, top: 20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12)),
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
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Page',
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 123, 123, 123)),
                                  ),
                                  Text(
                                    '244',
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Color.fromARGB(255, 123, 123, 123)),
                                  )
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Language',
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 123, 123, 123)),
                                  ),
                                  Text(
                                    'Malay',
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Color.fromARGB(255, 123, 123, 123)),
                                  )
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Audio',
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 123, 123, 123)),
                                  ),
                                  Text(
                                    '3hr',
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Color.fromARGB(255, 123, 123, 123)),
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
                              Text('What\'s it about?',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17)),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, top: 10, bottom: 10),
                          child: SizedBox(
                            height: 175,
                            child: SingleChildScrollView(
                              child: widget.bookDesc.isEmpty
                                  ? const NoDescriptionCard()
                                  : Text(
                                      widget.bookDesc,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        color:
                                            Color.fromARGB(255, 123, 123, 123),
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
                    top: MediaQuery.of(context).size.height * 0.77,
                    left: MediaQuery.of(context).size.width * 0.03,
                    child: SafeArea(
                        child: ButtonBar(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 7.5),
                              child: Row(
                                children: [
                                  TextButton(
                                      onPressed: () {
                                        bottomSheet(context);
                                      },
                                      child: const Text(
                                        'Chapter >',
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 235, 127, 35),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      )),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                        side: const BorderSide(
                                            color: Color.fromARGB(
                                                255, 235, 127, 35))),
                                    onPressed: () {
                                      // 1. check if the book is purchased
                                      // 2. if book isnt purchased, should buy
                                      // 3. if book is purhcaesd, open the book pdf/epub
                                      Navigator.pushNamed(context, '/bookRead');
                                    },
                                    child: const Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 10),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.import_contacts_rounded,
                                            color: Color.fromARGB(
                                                255, 235, 127, 35),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            'Read Book',
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 235, 127, 35)),
                                          )
                                        ],
                                      ),
                                    )),
                                const SizedBox(
                                  width: 29,
                                ),
                                OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromARGB(255, 235, 127, 35),
                                    side: const BorderSide(
                                      color: Color.fromARGB(255, 235, 127, 35),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/audiobooks');
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
                                          'Play Book',
                                          style: TextStyle(color: Colors.white),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    )),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
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
