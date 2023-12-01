import 'package:flutter/material.dart';

import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import 'package:jendela_dbp/controllers/dbp_color.dart';
import 'package:jendela_dbp/view/pages/savedBooks/user_books.dart';

class BoughtBookBottomSheet extends StatefulWidget {
  const BoughtBookBottomSheet({
    super.key,
  });

  @override
  State<BoughtBookBottomSheet> createState() => _BoughtBookBottomSheetState();
}

class _BoughtBookBottomSheetState extends State<BoughtBookBottomSheet> {
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
            'Anda telah membeli buku ini. Sila ke halaman Buku Anda untuk membacanya',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
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
            Padding(
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
                  PersistentNavBarNavigator.pushNewScreen(
                    context,
                    withNavBar: true,
                    screen: const UserBooks(
                    ),
                  );
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) => UserBooks(
                  //             controller: controller,
                  //           )),
                  // );
                },
                child: const Text(
                  'Pergi ke Buku Anda',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
