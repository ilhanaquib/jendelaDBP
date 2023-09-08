import 'package:flutter/material.dart';

import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import 'package:jendela_dbp/view/pages/audiobooks.dart';
import 'package:jendela_dbp/view/pages/home.dart';
import 'package:jendela_dbp/view/pages/posts.dart';
import 'package:jendela_dbp/view/pages/profile.dart';
import 'package:jendela_dbp/view/pages/savedBooks.dart';

class MyPersistentBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;

  MyPersistentBottomNavBar({
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: PersistentTabController(initialIndex: selectedIndex),
      screens:  [
        const Home(),
        Posts(),
        const SavedBooks(),
        const Audiobooks(),
        const Profile(),
      ],
      items: [
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.home),
          title: "Home",
          activeColorPrimary: const Color.fromARGB(255, 235, 127, 35),
          inactiveColorPrimary: const Color.fromARGB(255, 123, 123, 123),
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.article_rounded),
          title: "Posts",
          activeColorPrimary: const Color.fromARGB(255, 235, 127, 35),
          inactiveColorPrimary: const Color.fromARGB(255, 123, 123, 123),
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.book_rounded),
          title: "Saved",
          activeColorPrimary: const Color.fromARGB(255, 235, 127, 35),
          inactiveColorPrimary: const Color.fromARGB(255, 123, 123, 123),
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.headphones_rounded),
          title: "Audio",
          activeColorPrimary: const Color.fromARGB(255, 235, 127, 35),
          inactiveColorPrimary: const Color.fromARGB(255, 123, 123, 123),
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.person_rounded),
          title: "Profile",
          activeColorPrimary: const Color.fromARGB(255, 235, 127, 35),
          inactiveColorPrimary: const Color.fromARGB(255, 123, 123, 123),
        ),
      ],
      confineInSafeArea: true,
      backgroundColor: Colors.white,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      hideNavigationBarWhenKeyboardShows: true,
      decoration: const NavBarDecoration(
        colorBehindNavBar: Colors.white,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      navBarStyle: NavBarStyle.style12,
      // ... other configuration settings ...
    );
  }
}
