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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Page',
                            style: TextStyle(
                                color: Color.fromARGB(255, 123, 123, 123)),
                          ),
                          Text(
                            '244',
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 123, 123, 123)),
                          )
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Language',
                            style: TextStyle(
                                color: Color.fromARGB(255, 123, 123, 123)),
                          ),
                          Text(
                            'Malay',
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 123, 123, 123)),
                          )
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Audio',
                            style: TextStyle(
                                color: Color.fromARGB(255, 123, 123, 123)),
                          ),
                          Text(
                            '3hr',
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 123, 123, 123)),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 20, left: 25),
                  child: Row(
                    children: [
                      Text('What\'s it about?',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 17)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                  child: Container(
                    child: const Text(
                      'Sekumpulan angkawasan maut tatkala Stesen Angkasa Antarabangsa Ceres meletup. Namun, kematian itu amat janggal sifatnya. Mereka mendapati diri mereka hidup semula terawang-awang di angkasa lepas dengan perubahan ketara pada jasad mereka, iaitu mereka menjadi sejenis makhluk bercahaya. Apakah pengakhiran kehidupan mereka?',
                      style: TextStyle(
                          fontSize: 15,
                          color: Color.fromARGB(255, 123, 123, 123),
                          height: 1.5),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 7.5, top: 15),
                  child: Row(
                    children: [
                      TextButton(
                          onPressed: () {},
                          child: const Text(
                            'Chapter >',
                            style: TextStyle(
                                color: Color.fromARGB(255, 235, 127, 35),
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          )),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                                color: Color.fromARGB(255, 235, 127, 35))),
                        onPressed: () {},
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: Row(
                            children: [
                              Icon(
                                Icons.import_contacts_rounded,
                                color: Color.fromARGB(255, 235, 127, 35),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Read Book',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 235, 127, 35)),
                              )
                            ],
                          ),
                        )),
                    OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 235, 127, 35),
                          side: const BorderSide(
                            color: Color.fromARGB(255, 235, 127, 35),
                          ),
                        ),
                        onPressed: () {},
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
                        )),
                  ],
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
