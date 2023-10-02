import 'package:flutter/material.dart';
import 'package:jendela_dbp/controllers/dbpColor.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.only(left: 20),
      child: SizedBox(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Upload Photo,',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
            Text(
              'User',
              style: TextStyle(
                fontSize: 20,
                color: DbpColor().jendelaGray,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
