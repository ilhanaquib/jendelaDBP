import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:jendela_dbp/blocs/book_bloc.dart';
import 'package:jendela_dbp/blocs/appearance_button_bloc.dart';
import 'package:jendela_dbp/blocs/font_button_bloc.dart';
import 'package:jendela_dbp/components/read_book/setting.dart';
import 'package:jendela_dbp/view/authentication/create_new_password.dart';
import 'package:jendela_dbp/view/authentication/forgot_password.dart';
import 'package:jendela_dbp/view/authentication/signin.dart';
import 'package:jendela_dbp/view/authentication/signup.dart';
import 'package:jendela_dbp/view/authentication/verification.dart';
import 'package:jendela_dbp/view/authentication/verification_password.dart';
import 'package:jendela_dbp/view/onboarding/onboard_screen.dart';
import 'package:jendela_dbp/view/pages/audiobooks.dart';
import 'package:jendela_dbp/view/pages/book_detail.dart';
import 'package:jendela_dbp/view/pages/book_read.dart';
import 'package:jendela_dbp/view/pages/home.dart';
import 'package:jendela_dbp/view/pages/profile.dart';
import 'package:jendela_dbp/view/pages/saved_books.dart';
import 'package:jendela_dbp/view/pages/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'blocs/bottom_nav_bloc.dart';

import 'blocs/category_bloc.dart';
import 'components/home/book_list.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
        BlocProvider<BookListBloc>(
          create: (context) => BookListBloc()..add(LoadBookListEvent()),
          child: const BookList(),
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
        ),
        routes: {
          // bottom nav bar
          '/home': (context) => const Home(),
          '/savedBooks': (context) => const SavedBooks(),
          '/audiobooks': (context) => const Audiobooks(),
          '/profile': (context) => const Profile(),

          //pages
          '/bookDetail': (context) => const BookDetail(),
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
