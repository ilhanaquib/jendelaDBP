import 'package:flutter/material.dart';

class BottomNavModel {
  final IconData iconData;
  final String label;

  BottomNavModel({
    required this.iconData,
    required this.label,
  });

  static final List<BottomNavModel> items = [
    BottomNavModel(iconData: Icons.home_rounded, label: '.'),
    BottomNavModel(iconData: Icons.import_contacts_rounded, label: '.'),
    BottomNavModel(iconData: Icons.headphones_rounded, label: '.'),
    BottomNavModel(iconData: Icons.person_rounded, label: '.'),
    // Add the rest of the BottomNavItems as required
  ];
}
