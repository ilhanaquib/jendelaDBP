import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jendela_dbp/blocs/appearanceButtonBloc.dart';
import 'package:jendela_dbp/blocs/fontButtonBloc.dart';
import 'package:jendela_dbp/components/read_book/setting.dart';
import 'package:jendela_dbp/cubits/AuthCubit.dart';
import 'package:jendela_dbp/hive/models/hivePurchasedBookModel.dart';
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
import 'package:jendela_dbp/view/pages/user.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'blocs/bottomNavBloc.dart';
import 'blocs/categoryBloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:convert';
import 'package:jendela_dbp/controllers/globalVar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'hive/models/hiveBookModel.dart';
import 'package:device_preview/device_preview.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await registerHive();
  final prefs = await SharedPreferences.getInstance();
  final showHome = prefs.getBool('showHome') ?? false;
  runApp(JendelaDBP(showHome: showHome));
}

//JendelaDBP(showHome: showHome)

// DevicePreview(
//       enabled: true,
//       builder: (context) => JendelaDBP(showHome: showHome),
//     ),

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
        BlocProvider<AuthCubit>(
          create: (BuildContext context) => AuthCubit(),
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
