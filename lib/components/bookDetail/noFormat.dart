import 'package:flutter/material.dart';

import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import 'package:jendela_dbp/controllers/dbpColor.dart';
import 'package:jendela_dbp/view/pages/savedBooks/userBooks.dart';

class noFormatSheet extends StatefulWidget {
  noFormatSheet({
    super.key,
  });

  @override
  State<noFormatSheet> createState() => _noFormatSheetState();
}

class _noFormatSheetState extends State<noFormatSheet> {
  final controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 30, left: 30, right: 30),
          child: Text(
            'This book isnt available in audiobook format',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 0,
            ),
            child: ElevatedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: DbpColor().jendelaOrange,
                side: BorderSide(
                  color: DbpColor().jendelaOrange,
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Dismiss',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
