import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:jendela_dbp/controllers/dbpColor.dart';
import 'package:jendela_dbp/hive/models/hiveBookModel.dart';
import 'package:jendela_dbp/view/pages/userBooks.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class boughtBookBottomSheet extends StatefulWidget {
  boughtBookBottomSheet({
    super.key,
  });

  @override
  State<boughtBookBottomSheet> createState() => _boughtBookBottomSheetState();
}

class _boughtBookBottomSheetState extends State<boughtBookBottomSheet> {
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
            'You have already bought this book, go to My Books to read your books.',
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
                  'Dismiss',
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
                    screen: UserBooks(
                      controller: controller,
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
                  'Go to My Books',
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
