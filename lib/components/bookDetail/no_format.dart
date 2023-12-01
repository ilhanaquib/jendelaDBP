import 'package:flutter/material.dart';

import 'package:jendela_dbp/controllers/dbp_color.dart';

class NoFormatSheet extends StatefulWidget {
  const NoFormatSheet({
    super.key,
  });

  @override
  State<NoFormatSheet> createState() => _NoFormatSheetState();
}

class _NoFormatSheetState extends State<NoFormatSheet> {
  final controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 30, left: 30, right: 30),
          child: Center(
            child: Text(
              'Buku ini tiada di dalam format Audio',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
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
                'Baik',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
