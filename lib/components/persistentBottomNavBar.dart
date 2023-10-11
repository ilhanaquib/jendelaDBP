import 'package:flutter/material.dart';

import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import 'package:jendela_dbp/view/pages/home.dart';
import 'package:jendela_dbp/view/pages/posts.dart';
import 'package:jendela_dbp/view/pages/savedBooks/savedBooksHome.dart';
import 'package:jendela_dbp/controllers/dbpColor.dart';
import 'package:jendela_dbp/view/pages/audiobooks/audiobooksHome.dart';
import 'package:jendela_dbp/view/pages/profile/profileScreen.dart';

class MyPersistentBottomNavBar extends StatelessWidget {
  const MyPersistentBottomNavBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    PersistentTabController controller =
        PersistentTabController(initialIndex: 0);

    List<Widget> buildScreens() {
      return const [
        Home(),
        Posts(),
        SavedBooksHome(),
        AudiobooksHome(),
        ProfileScreen(),
      ];
    }

    List<PersistentBottomNavBarItem> navBarItems() {
      return [
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.home),
          title: "Home",
          activeColorPrimary: DbpColor().jendelaOrange,
          inactiveColorPrimary: DbpColor().jendelaGray,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.article_rounded),
          title: "Posts",
          activeColorPrimary: DbpColor().jendelaOrange,
          inactiveColorPrimary: DbpColor().jendelaGray,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.book_rounded),
          title: "Saved",
          activeColorPrimary: DbpColor().jendelaOrange,
          inactiveColorPrimary: DbpColor().jendelaGray,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.headphones_rounded),
          title: "Audio",
          activeColorPrimary: DbpColor().jendelaOrange,
          inactiveColorPrimary: DbpColor().jendelaGray,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.person_rounded),
          title: "Profile",
          activeColorPrimary: DbpColor().jendelaOrange,
          inactiveColorPrimary: DbpColor().jendelaGray,
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
      popAllScreensOnTapAnyTabs: true,
      screenTransitionAnimation: const ScreenTransitionAnimation(
        // Screen transition animation on change of selected tab.
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 500),
      ),
      navBarStyle: NavBarStyle.style12,
    );
  }
}
