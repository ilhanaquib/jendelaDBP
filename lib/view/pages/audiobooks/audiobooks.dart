import 'package:flutter/material.dart';

import 'package:text_scroll/text_scroll.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:jendela_dbp/components/audiobook/audio_player.dart';
import 'package:jendela_dbp/hive/models/hivePurchasedBookModel.dart';

class Audiobooks extends StatelessWidget {
  const Audiobooks({super.key, this.book, this.audioFile});

  final HivePurchasedBook? book;
  final String? audioFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Sedang dimainkan'),
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
                                imageUrl: book!.featuredMediaUrl!,
                                height: 200,
                                width: 150,
                                fit: BoxFit.fill,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 100,
                        margin:
                            const EdgeInsets.only(left: 50, right: 50, top: 20),
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 20),
                                    child: TextScroll(
                                      book!.productName!,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                      mode: TextScrollMode.endless,
                                      velocity: const Velocity(
                                        pixelsPerSecond: Offset(30, 0),
                                      ),
                                      selectable: true,
                                      pauseBetween: const Duration(seconds: 5),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 30, left: 20, right: 20),
                        child: SizedBox(
                          height: 200,
                          child: SingleChildScrollView(
                            child: Text(book!.descriptionParent!),
                          ),
                        ),
                      ),
                       Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
                        child: AudioPlayerWidget(audioFile: audioFile),
                      ),
                    ],
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
      ..moveTo(0, size.height * 0.8) // Start point of the curve
      ..quadraticBezierTo(size.width * 0.5, size.height * 1.2, size.width,
          size.height * 0.8) // Control and end points of the curve
      ..lineTo(size.width, 0) // Line to the top right corner
      ..lineTo(1, 1) // Line back to the top left corner
      ..close(); // Close the path
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
