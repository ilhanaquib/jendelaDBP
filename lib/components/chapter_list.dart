import 'package:flutter/material.dart';

class ChapterList extends StatelessWidget {
  const ChapterList({super.key});

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 15, left: 15),
          child: Row(
            children: [
              Text(
                'All Chapter',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        ListTile(
          onTap: () {
            Navigator.pushNamed(context, '/bookRead');
          },
          leading: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Chap.',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 13,
                  color: Color.fromARGB(255, 123, 123, 123),
                ),
              ),
              Text(
                '01',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 13,
                  color: Color.fromARGB(255, 123, 123, 123),
                ),
              ),
            ],
          ),
          trailing: Text(
            '38min 45sec',
            style: TextStyle(
              fontSize: 13,
              color: Color.fromARGB(255, 123, 123, 123),
            ),
          ),
          title: Text(
            'Perjuangan Yang Belum Selesai',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}
