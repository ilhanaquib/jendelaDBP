import 'package:flutter/material.dart';

import 'package:jendela_dbp/controllers/dbpColor.dart';

class TopHeader extends StatelessWidget {
  TopHeader({super.key});

  @override
  DateTime currentTime = DateTime.now();
  String _getGreeting(int hour) {
    if (hour > 5 && hour < 12) {
      return 'Selamat Pagi';
    } else if (hour < 13) {
      return 'Selamat Tengah Hari';
    } else if (hour < 19) {
      return 'Selamat Petang';
    } else {
      return 'Selamat Malam';
    }
  }

  Widget build(BuildContext context) {
    String greeting = _getGreeting(currentTime.hour);

    return Padding(
      padding:
          const EdgeInsets.only(top: 10.0, left: 15, right: 15, bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            greeting,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400,
              color: DbpColor().jendelaGray,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            'Kami mempunyai pelbagai jenis buku untuk anda hari ini',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: DbpColor().jendelaBlack,
            ),
          )
        ],
      ),
    );
  }
}
