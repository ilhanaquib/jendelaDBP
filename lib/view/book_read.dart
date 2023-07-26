import 'package:flutter/material.dart';

class BookRead extends StatelessWidget {
  const BookRead({super.key});

  @override
  Widget build(BuildContext context) {
    double currentPage = 1;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Reading Book'),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.menu))],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10, left: 20),
        child: Column(
          children: [
            const Row(
              children: [
                Text(
                  'Book Title',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            const Row(
              children: [
                Text(
                  'Chapter 1: Perjuangan Yang Belum Selesai',
                  style: TextStyle(
                    color: Color.fromARGB(255, 123, 123, 123),
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(left: 20, right: 20, top: 20),
              child: Column(
                children: [
                  Text(
                    '''    “Kita teruskan dengan bahagian yang seterusnya, yakni bahagian teknologi siber, Kapten Eng. Silakan.” Komander Zarnoush bergerak ke bahagian seterusnya.

“Baiklah, Komander Zarnoush. Salam sejahtera semua. Di sini saya akan membentangkan maklumat berkenaan teknologi siber.” Kapten Eng memulakan bicaranya dengan kedengaran sedikit loghat cina.

“Setakat hari ini, tidak ada lagi sebarang petanda mengenai ancaman serangan siber mahupun penggodam yang datanganya daripada bahagian dalam stesen angkasa ini. Namun, sensor luar stesen angkasa ini tidak dapat mengesan sebarang tindak balas peranti yang berdekatan. Ini disebabkan kebanyakan stesen angkasa milik negara lain sudah lama meninggalkan orbit bumi.” Kapten Eng menerangkan dengan jelas.

    “Bagaimana pula dengan tanda-tanda radiasi di permukaan bumi?” Bertanya Komander Zarnoush, masih menaruh harapan yang tinggi. ''',
                    style: TextStyle(
                        color: Color.fromARGB(255, 123, 123, 123),
                        fontSize: 15,
                        height: 1.5),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.arrow_left_outlined,
                      color: Color.fromARGB(255, 123, 123, 123),
                      size: 40,
                    )),
                RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: 'Page 22',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.normal),
                      ),
                      TextSpan(
                        text: ' of 240',
                        style: TextStyle(
                            color: Color.fromARGB(255, 123, 123, 123),
                            fontSize: 17,
                            fontWeight: FontWeight.normal),
                      )
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.arrow_right_outlined,
                    color: Color.fromARGB(255, 123, 123, 123),
                    size: 40,
                  ),
                ),
              ],
            ),
            // Slider(
            //   value: currentPage,
            //   min: 1,
            //   max: 240,
            //   onChanged:
            // ),
          ],
        ),
      ),
    );
  }
}
