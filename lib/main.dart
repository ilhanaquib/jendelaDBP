import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jendela_dbp/controllers/likedBooksManagement.dart';
import 'package:jendela_dbp/stateManagement/blocs/imagePickerBloc.dart';
import 'package:jendela_dbp/stateManagement/blocs/notUsed/appearanceButtonBloc.dart';
import 'package:jendela_dbp/stateManagement/blocs/notUsed/fontButtonBloc.dart';
import 'package:jendela_dbp/components/read_book/setting.dart';
import 'package:jendela_dbp/stateManagement/cubits/AuthCubit.dart';
import 'package:jendela_dbp/hive/models/hivePurchasedBookModel.dart';
import 'package:jendela_dbp/stateManagement/cubits/likedStatusCubit.dart';
import 'package:jendela_dbp/view/authentication/createNewPassword.dart';
import 'package:jendela_dbp/view/authentication/forgotPassword.dart';
import 'package:jendela_dbp/view/authentication/signin.dart';
import 'package:jendela_dbp/view/authentication/signup.dart';
import 'package:jendela_dbp/view/authentication/verification.dart';
import 'package:jendela_dbp/view/authentication/verificationPassword.dart';
import 'package:jendela_dbp/view/onboarding/onboardScreen.dart';
import 'package:jendela_dbp/view/pages/audiobooks.dart';
import 'package:jendela_dbp/view/pages/bookRead.dart';
import 'package:jendela_dbp/view/pages/home.dart';
import 'package:jendela_dbp/view/pages/profile.dart';
import 'package:jendela_dbp/view/pages/savedBooks.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:convert';
import 'package:jendela_dbp/controllers/globalVar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'hive/models/hiveBookModel.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

final ValueNotifier<bool> showHomeNotifier = ValueNotifier<bool>(false);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await registerHive();
  await LikedStatusManager.initLikedStatusBox();
  final prefs = await SharedPreferences.getInstance();
  final showHomeNotifier = prefs.getBool('showHome') ?? false;
  runApp(JendelaDBP(showHomeNotifier: showHomeNotifier)
      // DevicePreview(
      //   enabled: true,
      //   builder: (context) => JendelaDBP(showHomeNotifier: showHomeNotifier),
      // ),
      );
}

class JendelaDBP extends StatelessWidget {
  JendelaDBP({Key? key, required this.showHomeNotifier}) : super(key: key);
  final bool showHomeNotifier;
  final _controller = PersistentTabController(initialIndex: 0);

  List<PersistentBottomNavBarItem> _navBarItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.home),
        title: "Home",
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

  List<Widget> _buildScreens(context) {
    return [
      const Home(),
      const SavedBooks(),
      const Audiobooks(),
      const Profile(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AppearanceBloc>(
          create: (context) => AppearanceBloc(),
          child: const Setting(),
        ),
        BlocProvider<FontBloc>(
          create: (context) => FontBloc(),
          child: const Setting(),
        ),
        BlocProvider<AuthCubit>(
          create: (BuildContext context) => AuthCubit(),
        ),
        BlocProvider<ImageBloc>(
          create: (BuildContext context) => ImageBloc(),
        ),
        BlocProvider(
          create: (context) => LikedStatusCubit(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 123, 123, 123),
            ),
            textTheme: GoogleFonts.interTextTheme(),
            unselectedWidgetColor: const Color.fromARGB(255, 123, 123, 123),
            checkboxTheme: CheckboxThemeData(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
              ),
            ),
            dividerColor: Colors.transparent),
        routes: {
          // bottom nav bar
          '/home': (context) => const Home(),
          '/savedBooks': (context) => const SavedBooks(),
          '/audiobooks': (context) => const Audiobooks(),
          '/profile': (context) => const Profile(),

          //pages
          '/bookRead': (context) => const BookRead(),

          //authentication
          '/signup': (context) => const Signup(),
          '/signin': (context) => const Signin(),
          '/verification': (context) => const Verification(),
          '/verificationPassword': (context) => const verificationPassword(),
          '/forgotPassword': (context) => const ForgotPassword(),
          '/createNewPassword': (context) => const CreateNewPassword()
        },
        home:
            //Signin()
            showHomeNotifier
                ? PersistentTabView(
                    context,
                    controller: PersistentTabController(
                        initialIndex: showHomeNotifier ? 0 : 4),
                    screens: _buildScreens(context),
                    items: _navBarItems(),
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
                  )
                : const OnboardScreen(),
      ),
    );
  }
}

Future<void> registerHive() async {
  WidgetsFlutterBinding.ensureInitialized();
  final document = await getApplicationDocumentsDirectory();
  Hive.init(document.path);
  Hive.registerAdapter(HiveBookAPIAdapter());
  await Hive.openBox<HiveBookAPI>(GlobalVar.APIBook);
  await Hive.openBox<HivePurchasedBook>(GlobalVar.PuchasedBook);
  await Hive.openBox<bool>('liked_status');
  await Hive.openBox<HiveBookAPI>('liked_books');
  FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  var containsEncryptionKey = await secureStorage.containsKey(key: 'key');
  if (!containsEncryptionKey) {
    var key = Hive.generateSecureKey();
    await secureStorage.write(key: 'key', value: base64UrlEncode(key));
  }
  var encryptionKey =
      base64Url.decode((await secureStorage.read(key: 'key')) ?? '');
  await Hive.openBox(GlobalVar.localFile,
      encryptionCipher: HiveAesCipher(encryptionKey));
}
