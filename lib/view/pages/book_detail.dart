import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jendela_dbp/components/DBPImportedWidgets/noDescriptionCard.dart';
import 'package:jendela_dbp/components/chapter_list.dart';

class BookDetail extends StatelessWidget {
  const BookDetail(
      {super.key,
      required this.bookImage,
      required this.bookTitle,
      required this.bookDesc});

  final String bookTitle;
  final String bookImage;
  final String bookDesc;

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
                                  imageUrl: bookImage,
                                  height: 220,
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
                            bookTitle,
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
                              left: 20, right: 20, top: 10),
                          child: SizedBox(
                            height: 200,
                            child: SingleChildScrollView(
                              child: bookDesc.isEmpty
                                  ? NoDescriptionCard()
                                  : Text(
                                      bookDesc,
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
                    top: 690,
                    left: 8,
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
