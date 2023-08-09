import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jendela_dbp/blocs/appearance_button_bloc.dart';
import 'package:jendela_dbp/blocs/font_button_bloc.dart';
import 'package:jendela_dbp/components/read_book/setting.dart';
import 'package:jendela_dbp/controllers/getBooksFromApi.dart';
import 'package:jendela_dbp/hive/models/hivePurchasedBookModel.dart';
import 'package:jendela_dbp/view/authentication/create_new_password.dart';
import 'package:jendela_dbp/view/authentication/forgot_password.dart';
import 'package:jendela_dbp/view/authentication/signin.dart';
import 'package:jendela_dbp/view/authentication/signup.dart';
import 'package:jendela_dbp/view/authentication/verification.dart';
import 'package:jendela_dbp/view/authentication/verification_password.dart';
import 'package:jendela_dbp/view/onboarding/onboard_screen.dart';
import 'package:jendela_dbp/view/pages/audiobooks.dart';
import 'package:jendela_dbp/view/pages/book_read.dart';
import 'package:jendela_dbp/view/pages/home.dart';
import 'package:jendela_dbp/view/pages/profile.dart';
import 'package:jendela_dbp/view/pages/saved_books.dart';
import 'package:jendela_dbp/view/pages/user.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'blocs/bottom_nav_bloc.dart';
import 'blocs/category_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:convert';
import 'package:jendela_dbp/controllers/globalVar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'hive/models/hiveBookModel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await registerHive();
  final prefs = await SharedPreferences.getInstance();
  final showHome = prefs.getBool('showHome') ?? false;
  runApp(JendelaDBP(showHome: showHome));
}

class JendelaDBP extends StatelessWidget {
  const JendelaDBP({Key? key, required this.showHome}) : super(key: key);
  final bool showHome;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<BottomNavBloc>(
          create: (context) => BottomNavBloc(),
        ),
        BlocProvider<CategoryBloc>(
          create: (context) => CategoryBloc(),
        ),
        BlocProvider<AppearanceBloc>(
          create: (context) => AppearanceBloc(),
          child: const Setting(),
        ),
        BlocProvider<FontBloc>(
          create: (context) => FontBloc(),
          child: const Setting(),
        ),
      ],
      child: MaterialApp(
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
          '/savedBooks': (context) => SavedBooks(),
          '/audiobooks': (context) => const Audiobooks(),
          '/profile': (context) => const Profile(),

          //pages
          '/bookRead': (context) => const BookRead(),
          '/user': (context) => const User(),

          //authentication
          '/signup': (context) => const Signup(),
          '/signin': (context) => const Signin(),
          '/verification': (context) => const Verification(),
          '/verificationPassword': (context) => const verificationPassword(),
          '/forgotPassword': (context) => const ForgotPassword(),
          '/createNewPassword': (context) => const CreateNewPassword()
        },
        home: showHome ? const Home() : const OnboardScreen(),
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
  final likedStatusBox = await Hive.openBox<bool>('liked_status');
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
