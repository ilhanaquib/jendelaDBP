import 'package:flutter/material.dart';
import 'package:jendela_dbp/view/pages/audiobooksHome.dart';
import 'package:jendela_dbp/view/pages/profileScreen.dart';

import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import 'package:jendela_dbp/view/pages/audiobooks.dart';
import 'package:jendela_dbp/view/pages/home.dart';
import 'package:jendela_dbp/view/pages/posts.dart';
import 'package:jendela_dbp/view/pages/profile.dart';
import 'package:jendela_dbp/view/pages/savedBooks.dart';

class MyPersistentBottomNavBar extends StatelessWidget {
  const MyPersistentBottomNavBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    PersistentTabController controller =
        PersistentTabController(initialIndex: 0);

    List<Widget> buildScreens() {
      return const [Home(), Posts(), SavedBooks(), AudiobooksHome(), ProfileScreen()];
    }

    List<PersistentBottomNavBarItem> navBarItems() {
      return [
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
      ];
    }

    return PersistentTabView(
      context,
      controller: controller,
      screens: buildScreens(),
      items: navBarItems(),
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
    );
  }
}
