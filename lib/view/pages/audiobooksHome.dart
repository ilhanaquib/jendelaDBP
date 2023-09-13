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
import 'package:jendela_dbp/view/pages/user.dart';


class AudiobooksHome extends StatefulWidget {
  const AudiobooksHome({super.key});

  @override
  State<AudiobooksHome> createState() => _AudiobooksHomeState();
}

class _AudiobooksHomeState extends State<AudiobooksHome> {
  Box<HiveBookAPI> APIBook = Hive.box<HiveBookAPI>(GlobalVar.APIBook);
  List<int> kategori1Books = [];
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
  }

  void _updateAppBar() {
    setState(() {
      // Rebuild the app bar to reflect the changes
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
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: CustomScrollView(
          slivers: [
            const SliverAppBar(
              floating: true,
              snap: true,
              elevation: 0.0,
              toolbarHeight: 0.01,
            ),
            SliverFillRemaining(
              child: AudioBookshelf(context, GlobalVar.kategori1Title,
                  GlobalVar.kategori1, kategori1Books, APIBook),
            ),
          ],
        ),
      ),
    );
  }
}
