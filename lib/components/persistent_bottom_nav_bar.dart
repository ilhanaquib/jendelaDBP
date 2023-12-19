
import 'package:flutter/material.dart';
import 'package:jendela_dbp/view/pages/home.dart';

import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import 'package:jendela_dbp/view/pages/ujana.dart';
import 'package:jendela_dbp/view/pages/savedBooks/saved_books_home.dart';
import 'package:jendela_dbp/controllers/dbp_color.dart';
import 'package:jendela_dbp/view/pages/audiobooks/audiobooks_home.dart';


class MyPersistentBottomNavBar extends StatefulWidget {
  const MyPersistentBottomNavBar({
    super.key,
  });

  @override
  State<MyPersistentBottomNavBar> createState() =>
      _MyPersistentBottomNavBarState();
}

enum UniLinksType { string, uri }

class _MyPersistentBottomNavBarState extends State<MyPersistentBottomNavBar> with SingleTickerProviderStateMixin {
  // String? _latestLink = 'Unknown';
  // Uri? _latestUri;
  // final UniLinksType _type = UniLinksType.string;
  // // ignore: unused_field
  // StreamSubscription? _sub;

  @override
  void initState() {
    super.initState();
    //initPlatformState();
  }

  @override
  Widget build(BuildContext context) {
    PersistentTabController controller =
        PersistentTabController(initialIndex: 0);

    List<Widget> buildScreens() {
      return [
        const Home(),
        // const PostAndArticle(),
        const Ujana(),
        const AudiobooksHome(),
        const SavedBooksHome(),
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
        // PersistentBottomNavBarItem(
        //   icon: const Icon(Icons.article_rounded),
        //   title: "Posts",
        //   activeColorPrimary: DbpColor().jendelaOrange,
        //   inactiveColorPrimary: DbpColor().jendelaGray,
        // ),
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

  // initPlatformState() async {
  //   if (_type == UniLinksType.string) {
  //     await initPlatformStateForStringUniLinks();
  //   } else {
  //     await initPlatformStateForUriUniLinks();
  //   }
  //   await handleUniLinks();
  // }

  // /// An implementation using a [String] link
  // initPlatformStateForStringUniLinks() async {
  //   // Attach a listener to the links stream
  //   _sub = linkStream.listen((String? link) {
  //     if (!mounted) return;
  //     setState(() {
  //       _latestLink = link ?? 'Unknown';
  //       _latestUri = null;
  //       try {
  //         if (link != null) _latestUri = Uri.parse(link);
  //       // ignore: empty_catches
  //       } on FormatException {}
  //     });
  //   }, onError: (err) {
  //     if (!mounted) return;
  //     setState(() {
  //       _latestLink = 'Failed to get latest link: $err.';
  //       _latestUri = null;
  //     });
  //   });

  //   // Attach a second listener to the stream
  //   linkStream.listen((String? link) {
  //     // print('got link: $link');
  //   }, onError: (err) {
  //     // print('got err: $err');
  //   });

  //   // Get the latest link
  //   String? initialLink;
  //   Uri? initialUri;
  //   // Platform messages may fail, so we use a try/catch PlatformException.
  //   try {
  //     initialLink = await getInitialLink();
  //     // print('initial link: $initialLink');
  //     if (initialLink != null) initialUri = Uri.parse(initialLink);
  //   } on PlatformException {
  //     initialLink = 'Failed to get initial link.';
  //     initialUri = null;
  //   } on FormatException {
  //     initialLink = 'Failed to parse the initial link as Uri.';
  //     initialUri = null;
  //   }

  //   // If the widget was removed from the tree while the asynchronous platform
  //   // message was in flight, we want to discard the reply rather than calling
  //   // setState to update our non-existent appearance.
  //   if (!mounted) return;

  //   setState(() {
  //     _latestLink = initialLink;
  //     _latestUri = initialUri;
  //   });
  // }

  // /// An implementation using the [Uri] convenience helpers
  // initPlatformStateForUriUniLinks() async {
  //   // Attach a listener to the Uri links stream
  //   _sub = uriLinkStream.listen((Uri? uri) {
  //     if (!mounted) return;
  //     setState(() {
  //       _latestUri = uri;
  //       _latestLink = uri?.toString() ?? 'Unknown';
  //     });
  //   }, onError: (err) {
  //     if (!mounted) return;
  //     setState(() {
  //       _latestUri = null;
  //       _latestLink = 'Failed to get latest link: $err.';
  //     });
  //   });

  //   // Attach a second listener to the stream
  //   uriLinkStream.listen((Uri? uri) {
  //     // print('got uri: ${uri?.path} ${uri?.queryParametersAll}');
  //   }, onError: (err) {
  //     // print('got err: $err');
  //   });

  //   // Get the latest Uri
  //   Uri? initialUri;
  //   String? initialLink;
  //   // Platform messages may fail, so we use a try/catch PlatformException.
  //   try {
  //     initialUri = await getInitialUri();
  //     // print('initial uri: ${initialUri?.path}'
  //     // ' ${initialUri?.queryParametersAll}');
  //     initialLink = initialUri?.toString();
  //   } on PlatformException {
  //     initialUri = null;
  //     initialLink = 'Failed to get initial uri.';
  //   } on FormatException {
  //     initialUri = null;
  //     initialLink = 'Bad parse the initial link as Uri.';
  //   }

  //   // If the widget was removed from the tree while the asynchronous platform
  //   // message was in flight, we want to discard the reply rather than calling
  //   // setState to update our non-existent appearance.
  //   if (!mounted) return;

  //   setState(() {
  //     _latestUri = initialUri;
  //     _latestLink = initialLink;
  //   });
  // }

  // Future<void> handleUniLinks() async {
  //   if (_latestUri != null || _latestLink != null) {
  //     Uri theLink = _latestUri ??
  //         Uri.parse(_latestLink ?? ('https://${GlobalVar.baseURLDomain}'));
  //     String host = theLink.host;
  //     String scheme = theLink.scheme;
  //     String authority = theLink.authority;
  //     if (host == 'callback' || authority == 'callback') {
  //       SharedPreferences prefs = await SharedPreferences.getInstance();
  //       bool isAppleSignin = prefs.getBool('isAppleSignin') ?? false;
  //       if (scheme == 'signinwithapple' && isAppleSignin == true) {
  //         // proceed with signinwithapple
  //         Map<String, List<String>> queryParams = theLink.queryParametersAll;
  //         // get user object
  //         Response userRes =
  //             await ApiService.maklumatPengguna(queryParams['token']?[0]);
  //         if (userRes.statusCode == 200) {
  //           var userRespBody = json.decode(userRes.body);
  //           User user = User.fromJson(userRespBody);
  //           // set is apple signin status to false
  //           SharedPreferences prefs = await SharedPreferences.getInstance();
  //           prefs.setBool('isAppleSignin', false);
  //           // login user with token
  //           if(!context.mounted) return;
  //           await BlocProvider.of<AuthCubit>(context).saveAuthUserToLocal(
  //               username: queryParams['user_email']?[0] ?? '',
  //               user: user,
  //               token: queryParams['token']?[0] ?? '');
  //           setState(() async {
  //             _latestUri = null;
  //             _latestLink = null;
  //             await BlocProvider.of<AuthCubit>(context).getUser();
  //           });
  //         }
  //       }
  //     }
  //   }
  // }
}
