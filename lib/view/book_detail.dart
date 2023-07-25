import 'package:flutter/material.dart';

class BookDetail extends StatelessWidget {
  const BookDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 246, 239),
        centerTitle: true,
        title: const Text('Details Book'),
      ),
      body: Stack(
        children: [
          CurvedBackground(),
          Center(
            child: Column(
              children: [
                Image.asset(
                  'assets/images/book 1.jpg',
                  height: 200,
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text('Book Title',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                const Text(
                  'Book Author',
                  style: TextStyle(color: Color.fromARGB(255, 123, 123, 123)),
                ),
                Container(
                  height: 100,
                  margin: const EdgeInsets.only(left: 50, right: 50, top: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 2,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        mainAxisAlignment:  MainAxisAlignment.center,
                        children: [
                          Text(
                            'Page',
                            style: TextStyle(
                                color: Color.fromARGB(255, 123, 123, 123)),
                          ),
                          Text(
                            '244',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 123, 123, 123)),
                          )
                        ],
                      ),
                      Column(
                        mainAxisAlignment:  MainAxisAlignment.center,
                        children: [
                          Text(
                            'language',
                            style: TextStyle(
                                color: Color.fromARGB(255, 123, 123, 123)),
                          ),
                          Text(
                            'Malay',
                            
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 123, 123, 123)),
                          )
                        ],
                      ),
                      Column(
                        mainAxisAlignment:  MainAxisAlignment.center,
                        children: [
                          Text(
                            'Audio',
                            style: TextStyle(
                                color: Color.fromARGB(255, 123, 123, 123)),
                          ),
                          Text(
                            '3hr',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 123, 123, 123)),
                          )
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class CurvedBackground extends StatelessWidget {
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
