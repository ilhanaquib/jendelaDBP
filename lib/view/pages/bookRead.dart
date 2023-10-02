import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:jendela_dbp/components/read_book/paragraphs.dart';
import 'package:jendela_dbp/components/read_book/setting.dart';
import 'package:jendela_dbp/components/read_book/slider.dart';
import 'package:jendela_dbp/controllers/dbpColor.dart';

class BookRead extends StatelessWidget {
  const BookRead({super.key});

  void bottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        elevation: 0,
        context: context,
        builder: (BuildContext context) {
          return const Setting();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Reading Book'),
        actions: [
          IconButton(
              onPressed: () {
                bottomSheet(context);
              },
              icon: const Icon(FontAwesomeIcons.ellipsisVertical))
        ],
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
             Row(
              children: [
                Text(
                  'Chapter 1: Perjuangan Yang Belum Selesai',
                  style: TextStyle(
                    color: DbpColor().jendelaGray,
                  ),
                ),
              ],
            ),
            const Paragraph(),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: () {},
                    icon:  Icon(
                      Icons.arrow_left_outlined,
                      color: DbpColor().jendelaGray,
                      size: 40,
                    )),
                RichText(
                  text:  TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Page 22',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.normal),
                      ),
                      TextSpan(
                        text: ' of 240',
                        style: TextStyle(
                            color: DbpColor().jendelaGray,
                            fontSize: 17,
                            fontWeight: FontWeight.normal),
                      )
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon:  Icon(
                    Icons.arrow_right_outlined,
                    color: DbpColor().jendelaGray,
                    size: 40,
                  ),
                ),
              ],
            ),
            const SliderWidget(),
             Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'Chapter 1',
                  style: TextStyle(
                      color: DbpColor().jendelaGray,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  width: 127,
                ),
                Text(
                  'Completed 19%',
                  style: TextStyle(
                      color: DbpColor().jendelaGray,
                      fontWeight: FontWeight.bold),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
