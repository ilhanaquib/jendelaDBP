import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:jendela_dbp/components/audiobook/booksForAudio.dart';
import 'package:jendela_dbp/controllers/getBooksFromApi.dart';
import 'package:jendela_dbp/controllers/globalVar.dart';
import 'package:jendela_dbp/hive/models/hiveBookModel.dart';
import 'package:jendela_dbp/stateManagement/blocs/imagePickerBloc.dart';
import 'package:jendela_dbp/view/pages/userIcon.dart';

class AudiobooksHome extends StatefulWidget {
  const AudiobooksHome({super.key});

  @override
  State<AudiobooksHome> createState() => _AudiobooksHomeState();
}

class _AudiobooksHomeState extends State<AudiobooksHome> {
  Box<HiveBookAPI> APIBook = Hive.box<HiveBookAPI>(GlobalVar.APIBook);
  List<int> kategori1Books = [];
  List<int> kategori2Books = [];
  List<int> kategori3Books = [];
  List<int> kategori4Books = [];
  List<int> kategori5Books = [];
  List<int> kategori6Books = [];
  List<int> kategori7Books = [];
  List<int> kategori8Books = [];
  List<int> kategori9Books = [];
  List<int> kategori10Books = [];
  List<int> kategori11Books = [];
  List<int> kategori12Books = [];
  List<int> kategori13Books = [];
  List<int> kategori14Books = [];
  List<int> kategori15Books = [];
  bool isLoading = true;

  var allProduct;

  @override
  void initState() {
    super.initState();
    allProduct = getAllProduct();
  }

  Future<bool> getAllProduct() async {
    var value = await SharedPreferences.getInstance();
    var token = value.getString('token');

    if (bookAPIBox.isEmpty || bookAPIBox.length == 0) {
      setState(() {
        isLoading = true;
      });

      bookAPIBox.clear();
      await getKategori(context, token, GlobalVar.kategori1);
      await getKategori(context, token, GlobalVar.kategori2);
      await getKategori(context, token, GlobalVar.kategori3);
      await getKategori(context, token, GlobalVar.kategori4);
      await getKategori(context, token, GlobalVar.kategori5);
      await getKategori(context, token, GlobalVar.kategori6);
      await getKategori(context, token, GlobalVar.kategori7);
      await getKategori(context, token, GlobalVar.kategori8);
      await getKategori(context, token, GlobalVar.kategori9);
      await getKategori(context, token, GlobalVar.kategori10);
      await getKategori(context, token, GlobalVar.kategori11);
      await getKategori(context, token, GlobalVar.kategori12);
      await getKategori(context, token, GlobalVar.kategori13);
      await getKategori(context, token, GlobalVar.kategori14);
      await getKategori(context, token, GlobalVar.kategori15);
    }

    getKategoriFromAPI();

    setState(() {
      isLoading = false;
    });
    return true;
  }

  void getKategoriFromAPI() {
    print('object');
    kategori1Books = APIBook.keys
        .cast<int>()
        .where(
            (key) => APIBook.get(key)!.product_category == GlobalVar.kategori1)
        .toList();
    kategori2Books = APIBook.keys
        .cast<int>()
        .where(
            (key) => APIBook.get(key)!.product_category == GlobalVar.kategori2)
        .toList();

    kategori3Books = APIBook.keys
        .cast<int>()
        .where(
            (key) => APIBook.get(key)!.product_category == GlobalVar.kategori3)
        .toList();
    kategori4Books = APIBook.keys
        .cast<int>()
        .where(
            (key) => APIBook.get(key)!.product_category == GlobalVar.kategori4)
        .toList();
    kategori5Books = APIBook.keys
        .cast<int>()
        .where(
            (key) => APIBook.get(key)!.product_category == GlobalVar.kategori5)
        .toList();
    kategori6Books = APIBook.keys
        .cast<int>()
        .where(
            (key) => APIBook.get(key)!.product_category == GlobalVar.kategori6)
        .toList();
    kategori7Books = APIBook.keys
        .cast<int>()
        .where(
            (key) => APIBook.get(key)!.product_category == GlobalVar.kategori7)
        .toList();
    kategori8Books = APIBook.keys
        .cast<int>()
        .where(
            (key) => APIBook.get(key)!.product_category == GlobalVar.kategori8)
        .toList();
    kategori9Books = APIBook.keys
        .cast<int>()
        .where(
            (key) => APIBook.get(key)!.product_category == GlobalVar.kategori9)
        .toList();
    kategori10Books = APIBook.keys
        .cast<int>()
        .where(
            (key) => APIBook.get(key)!.product_category == GlobalVar.kategori10)
        .toList();
    kategori11Books = APIBook.keys
        .cast<int>()
        .where(
            (key) => APIBook.get(key)!.product_category == GlobalVar.kategori11)
        .toList();
    kategori12Books = APIBook.keys
        .cast<int>()
        .where(
            (key) => APIBook.get(key)!.product_category == GlobalVar.kategori12)
        .toList();
    kategori13Books = APIBook.keys
        .cast<int>()
        .where(
            (key) => APIBook.get(key)!.product_category == GlobalVar.kategori13)
        .toList();
    kategori14Books = APIBook.keys
        .cast<int>()
        .where(
            (key) => APIBook.get(key)!.product_category == GlobalVar.kategori14)
        .toList();
    kategori15Books = APIBook.keys
        .cast<int>()
        .where(
            (key) => APIBook.get(key)!.product_category == GlobalVar.kategori15)
        .toList();
  }

  void _updateAppBar() {
    setState(() {
      // Rebuild the app bar to reflect the changes
    });
  }

  Future<void> _handleRefresh() async {

    setState(() {
      isLoading = true;
    });
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      try {
        final result = await InternetAddress.lookup('google.com')
            .timeout(const Duration(seconds: 3));
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          var token = prefs.getString('token');
          bookAPIBox.clear();
          await getKategori(context, token, GlobalVar.kategori1);
          await getKategori(context, token, GlobalVar.kategori2);
          await getKategori(context, token, GlobalVar.kategori3);
          await getKategori(context, token, GlobalVar.kategori4);
          await getKategori(context, token, GlobalVar.kategori5);
          await getKategori(context, token, GlobalVar.kategori6);
          await getKategori(context, token, GlobalVar.kategori7);
          await getKategori(context, token, GlobalVar.kategori8);
          await getKategori(context, token, GlobalVar.kategori9);
          await getKategori(context, token, GlobalVar.kategori10);
          await getKategori(context, token, GlobalVar.kategori11);
          await getKategori(context, token, GlobalVar.kategori12);
          await getKategori(context, token, GlobalVar.kategori13);
          await getKategori(context, token, GlobalVar.kategori14);
          await getKategori(context, token, GlobalVar.kategori15);
        }
      } catch (exception, stackTrace) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(exception.toString()),
          duration: Duration(seconds: 3),
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text('Internet access required'),
        duration: Duration(seconds: 3),
      ));
    }

    getKategoriFromAPI();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Let\'s read something'),
            Text(
              'We collected and distilled the knowledge',
              style: TextStyle(
                fontSize: 14,
                color: Color.fromARGB(255, 123, 123, 123),
              ),
            )
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () {
                PersistentNavBarNavigator.pushNewScreen(
                  context,
                  withNavBar: false,
                  screen: BlocProvider.value(
                    value: context.read<ImageBloc>(),
                    child: UserHomeScreen(
                      updateAppBar: _updateAppBar,
                    ),
                  ),
                );
              },
              child: CircleAvatar(
                backgroundImage:
                    context.watch<ImageBloc>().selectedImageProvider ??
                        const AssetImage('assets/images/tiadakulitbuku.png'),
              ),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              const SliverAppBar(
                floating: true,
                snap: true,
                elevation: 0.0,
                toolbarHeight: 0.01,
              ),
              SliverFillRemaining(
                child: AudioBookshelf(context, GlobalVar.kategori11Title,
                    GlobalVar.kategori11, kategori11Books, APIBook),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
