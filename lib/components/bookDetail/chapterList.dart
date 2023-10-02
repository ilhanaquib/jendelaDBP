import 'package:flutter/material.dart';
import 'package:jendela_dbp/controllers/dbpColor.dart';

class ChapterList extends StatelessWidget {
  const ChapterList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
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
          leading: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Chap.',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 13,
                  color: DbpColor().jendelaGray,
                ),
              ),
              Text(
                '01',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 13,
                  color: DbpColor().jendelaGray,
                ),
              ),
            ],
          ),
          trailing: Text(
            '38min 45sec',
            style: TextStyle(
              fontSize: 13,
              color: DbpColor().jendelaGray,
            ),
          ),
          title: const Text(
            'Perjuangan Yang Belum Selesai',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}
