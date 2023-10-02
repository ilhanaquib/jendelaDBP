import 'package:flutter/material.dart';
import 'package:jendela_dbp/controllers/dbpColor.dart';

class TopHeader extends StatelessWidget {
  const TopHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.only(top: 10.0, left: 15, right: 15, bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            'Hello Guest!',
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
            'We have some awesome books for you',
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: DbpColor().jendelaBlack,),
          )
        ],
      ),
    );
  }
}
