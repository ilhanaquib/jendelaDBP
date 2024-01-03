import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jendela_dbp/controllers/dbp_color.dart';
import 'package:jendela_dbp/hive/models/hive_book_model.dart';
import 'package:jendela_dbp/hive/models/hive_purchased_book_model.dart';
import 'package:jendela_dbp/hive/models/hive_user_book_model.dart';
import 'package:jendela_dbp/stateManagement/states/auth_state.dart';
import 'package:jendela_dbp/view/pages/audiobooks/audiobooks_home.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:window_manager/window_manager.dart';

import 'package:jendela_dbp/components/persistent_bottom_nav_bar.dart';
import 'package:jendela_dbp/stateManagement/cubits/auth_cubit.dart';
import 'package:jendela_dbp/view/authentication/create_new_password.dart';
import 'package:jendela_dbp/view/authentication/forgot_password.dart';
import 'package:jendela_dbp/view/authentication/signin.dart';
import 'package:jendela_dbp/view/authentication/signup.dart';
import 'package:jendela_dbp/view/authentication/verification.dart';
import 'package:jendela_dbp/view/authentication/verification_password.dart';
import 'package:jendela_dbp/view/onboarding/onboard_screen.dart';
import 'package:jendela_dbp/view/pages/savedBooks/liked_books.dart';
import 'package:jendela_dbp/controllers/liked_books_management.dart';
import 'package:jendela_dbp/controllers/global_var.dart';

final ValueNotifier<bool> showHomeNotifier = ValueNotifier<bool>(false);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await registerHive();
  await LikedStatusManager.initLikedStatusBox();
  final prefs = await SharedPreferences.getInstance();
  final showHomeNotifier = prefs.getBool('showHome') ?? false;

  if (Platform.isWindows) {
    await windowManager.ensureInitialized();
    WindowManager.instance.setSize(const Size(1500, 800));
    WindowManager.instance.setMinimumSize(const Size(850, 650));
    await SentryFlutter.init(
      (options) {
        options.dsn =
            'https://73538fe8065b477e985ef1d3eb6aca65@o557568.ingest.sentry.io/5689994';
      },
      appRunner: () {
        runZonedGuarded(() {
          runApp(
            DevicePreview(
              enabled: true,
              builder: (context) =>
                  JendelaDBP(showHomeNotifier: showHomeNotifier),
            ),
          );
        }, (Object exception, StackTrace stackTrace) async {
          await Sentry.captureException(
            exception,
            stackTrace: stackTrace,
          );
        });
      },
    );
  } else {
    await SentryFlutter.init(
      (options) {
        options.dsn =
            'https://73538fe8065b477e985ef1d3eb6aca65@o557568.ingest.sentry.io/5689994';
      },
      appRunner: () {
        runZonedGuarded(() {
          runApp(JendelaDBP(showHomeNotifier: showHomeNotifier));
        }, (Object exception, StackTrace stackTrace) async {
          await Sentry.captureException(
            exception,
            stackTrace: stackTrace,
          );
        });
      },
    );
  }
}

class JendelaDBP extends StatefulWidget {
  const JendelaDBP({Key? key, required this.showHomeNotifier})
      : super(key: key);

  final bool showHomeNotifier;

  @override
  State<JendelaDBP> createState() => _JendelaDBPState();
}

class _JendelaDBPState extends State<JendelaDBP> {
  AuthCubit authCubit = AuthCubit();

  @override
  void initState() {
    super.initState();
    authCubit.getUserLoginOrNot();
    authCubit.getUser();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => authCubit,
      child: BlocConsumer<AuthCubit, AuthState>(
          bloc: authCubit,
          listener: (context, state) {},
          builder: (BuildContext context, AuthState state) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                useMaterial3: true,
                colorScheme: ColorScheme.fromSeed(
                  seedColor: DbpColor().jendelaGray,
                ),
                textTheme: GoogleFonts.interTextTheme(),
                unselectedWidgetColor: DbpColor().jendelaGray,
                dividerColor: Colors.transparent,
              ),
              routes: {
                // bottom nav bar
                '/home': (context) => const MyPersistentBottomNavBar(),
                '/savedBooks': (context) => const LikedBooks(),
                '/audiobooks': (context) => const AudiobooksHome(),

                //authentication
                '/signup': (context) => const Signup(),
                '/signin': (context) => const Signin(),
                '/verification': (context) => const Verification(),
                '/verificationPassword': (context) =>
                    const verificationPassword(),
                '/forgotPassword': (context) => const ForgotPassword(),
                '/createNewPassword': (context) => const CreateNewPassword()
              },
              home: widget.showHomeNotifier
                  ? const MyPersistentBottomNavBar()
                  : const OnboardScreen(),
            );
          }),
    );
  }
}

Future<void> registerHive() async {
  WidgetsFlutterBinding.ensureInitialized();
  final document = await getApplicationDocumentsDirectory();
  Hive.init(document.path);
  Hive.registerAdapter(HiveBookAPIAdapter());
  Hive.registerAdapter(HivePurchasedBookAdapter());
  Hive.registerAdapter(BookUserModelAdapter());
  await Hive.openBox<HiveBookAPI>(GlobalVar.apiBook);
  await Hive.openBox<HivePurchasedBook>(GlobalVar.puchasedBook);
  await Hive.openBox<HiveBookAPI>(GlobalVar.toCartBook);
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
