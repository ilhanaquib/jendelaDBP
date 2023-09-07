import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jendela_dbp/components/audiobook/audioPlayer.dart';
import 'package:jendela_dbp/components/audiobook/paragraph.dart';
import 'package:jendela_dbp/components/persistentBottomNavBar.dart';

class Audiobooks extends StatelessWidget {
  const Audiobooks({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Now Playing'),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(FontAwesomeIcons.ellipsisVertical))
        ],
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
                              Image.asset(
                                "assets/images/tiadakulitbuku.png",
                                height: 250,
                                width: 180,
                                fit: BoxFit.fill,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text('Book Title',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20)),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'Page : 78/266',
                        style: TextStyle(
                            color: Color.fromARGB(255, 123, 123, 123)),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(
                            top: 50, left: 20, right: 20, bottom: 20),
                        child: SizedBox(
                          height: 200,
                          child: SingleChildScrollView(
                            child: Paragraph(),
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: Column(
                          children: [AudioPlayerWidget()],
                        ),
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
