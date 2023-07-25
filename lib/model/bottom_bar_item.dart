import 'package:flutter/material.dart';

class BottomNavItem {
  final IconData iconData;
  final String label;
  final double iconSize;

  BottomNavItem({
    required this.iconData,
    required this.label,
    this.iconSize = 35
  });
}
