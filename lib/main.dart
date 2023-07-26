import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:jendela_dbp/blocs/book_bloc.dart';
import 'package:jendela_dbp/components/bottom_nav_bar.dart';
import 'package:jendela_dbp/view/audiobooks.dart';
import 'package:jendela_dbp/view/book_detail.dart';
import 'package:jendela_dbp/view/home.dart';
import 'package:jendela_dbp/view/profile.dart';
import 'package:jendela_dbp/view/saved_books.dart';

import 'blocs/bottom_nav_bloc.dart';


import 'blocs/category_bloc.dart';
import 'components/book_list.dart';

void main() {
  runApp(const JendelaDBP());
}

class JendelaDBP extends StatelessWidget {
  const JendelaDBP({Key? key}) : super(key: key);

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
      ],
      child: MaterialApp(
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 123, 123, 123),
          ),
          textTheme: GoogleFonts.interTextTheme(),
        ),
        routes: {
          // bottom nav bar
          '/home': (context) => const Home(),
          '/savedBooks': (context) => const SavedBooks(),
          '/audiobooks': (context) => const Audiobooks(),
          '/profile': (context) => const Profile(),

          //pages
          '/bookDetail': (context) => const BookDetail()
        },
        home: const Home(),
      ),
    );
  }
}
