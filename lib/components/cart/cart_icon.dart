import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import 'package:jendela_dbp/controllers/dbp_color.dart';
import 'package:jendela_dbp/controllers/global_var.dart';
import 'package:jendela_dbp/hive/models/hive_book_model.dart';
import 'package:jendela_dbp/view/pages/purchasing/cart_screen.dart';

class CartIcon extends StatefulWidget {
  const CartIcon({super.key});

  @override
  State<CartIcon> createState() => _CartIconState();
}

class _CartIconState extends State<CartIcon> {
  Box<HiveBookAPI> toCartBook = Hive.box<HiveBookAPI>(GlobalVar.toCartBook);
  List<int> inCartList = [];
  final DbpColor colors = DbpColor();

  @override
  void initState() {
    super.initState();

    checkInCartList();
  }

  void checkInCartList() {
    setState(() {
      inCartList = toCartBook.keys.cast<int>().toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ValueListenableBuilder(
          valueListenable: toCartBook.listenable(),
          builder: (context, Box<HiveBookAPI> inCartBook, _) {
            inCartList = toCartBook.keys.cast<int>().toList();

            return InkWell(
              onTap: () => PersistentNavBarNavigator.pushNewScreen(
                context,
                withNavBar: false,
                screen: const CartScreen(),
              ),
              child: Center(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(
                      Icons.shopping_cart_outlined,
                      color: Colors.black,
                      size: 36,
                    ),
                    Positioned(
                      left: 20,
                      bottom: 20,
                      child: Container(
                        alignment: Alignment.center,
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                            color: DbpColor().jendelaOrange,
                            shape: BoxShape.circle),
                        child: Text(
                          inCartList.length.toString(),
                          style: const TextStyle(
                              fontSize: 13,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
