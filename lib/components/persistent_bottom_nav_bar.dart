import 'package:flutter/material.dart';
import 'package:jendela_dbp/view/pages/home.dart';
import 'package:jendela_dbp/view/pages/postAndArticles/post_and_article.dart';

import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import 'package:jendela_dbp/view/pages/ujana.dart';
import 'package:jendela_dbp/view/pages/savedBooks/saved_books_home.dart';
import 'package:jendela_dbp/controllers/dbp_color.dart';
import 'package:jendela_dbp/view/pages/audiobooks/audiobooks_home.dart';
import 'package:jendela_dbp/view/pages/profile/profile_screen.dart';

class MyPersistentBottomNavBar extends StatelessWidget {
  const MyPersistentBottomNavBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    PersistentTabController controller =
        PersistentTabController(initialIndex: 0);

    List<Widget> buildScreens() {
      return  [
        const Home(),
        const PostAndArticle(),
        const Ujana(),
        const AudiobooksHome(),
        const SavedBooksHome(),
        const ProfileScreen(),
      ];
    }

    List<PersistentBottomNavBarItem> navBarItems() {
      return [
        PersistentBottomNavBarItem(
          icon: const Icon(
            Icons.home,
          ),
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
          icon: const Icon(
            Icons.local_library_outlined,
          ),
          title: "Ujana",
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
          icon: const Icon(Icons.book_rounded),
          title: "Saved",
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