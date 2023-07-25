import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:jendela_dbp/model/bottom_bar_item.dart';

class HomeController extends GetxController {
  final List<BottomNavItem> bottomNavItems = [
    BottomNavItem(iconData: Icons.home, label: '.', iconSize: 35),
    BottomNavItem(iconData: Icons.import_contacts_rounded, label: '.', iconSize: 35),
    BottomNavItem(iconData: Icons.headphones_rounded, label: '.', iconSize: 35),
    BottomNavItem(iconData: Icons.person_rounded, label: '.', iconSize: 35),
  ];

  final selectedIndex = 0.obs;

  void selectTab(int index) {
    selectedIndex.value = index;
  }
}
