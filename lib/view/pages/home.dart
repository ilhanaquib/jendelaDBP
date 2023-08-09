import 'package:flutter/material.dart';
import 'package:jendela_dbp/components/bookshelf/bookshelf.dart';
import 'package:jendela_dbp/components/bottom_nav_bar.dart';
import 'package:jendela_dbp/components/home/category_buttons.dart';
import 'package:jendela_dbp/components/home/top_header_home.dart';
import 'package:jendela_dbp/controllers/globalVar.dart';
import 'package:hive/hive.dart';
import 'package:jendela_dbp/hive/models/hiveBookModel.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:jendela_dbp/view/pages/apitest.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jendela_dbp/controllers/getBooksFromApi.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // ignore: non_constant_identifier_names
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () async {
            // for (var key in APIBook.keys) {
            //   var hiveBookInstance = APIBook.get(key);

            //   if (hiveBookInstance != null) {
            //     print('Title: ${hiveBookInstance.name}');
            //     print('Author: ${hiveBookInstance.product_category}');
            //     // ... and so on for other properties
            //   }
            //   Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context) =>
            //             apentah(bookImage: hiveBookInstance!.images!)),
            //   );
            // }
            // for (var key in APIBook.keys) {
            //   var hiveBookInstance = APIBook.get(key);
            //   if (hiveBookInstance != null) {
            //     print(
            //         'Key: $key, Product Category: ${hiveBookInstance.name}');
            //   }
            // }
            //getKategoriFromAPI();
            // var value = await SharedPreferences.getInstance();
            // var token = value.getString('token');
            // await getKategori(context, token, GlobalVar.kategori1);
            // await getKategori(context, token, GlobalVar.kategori2);
            // await getKategori(context, token, GlobalVar.kategori3);
            // await getKategori(context, token, GlobalVar.kategori4);
            // await getKategori(context, token, GlobalVar.kategori5);
            // await getKategori(context, token, GlobalVar.kategori6);
            // await getKategori(context, token, GlobalVar.kategori7);
            // await getKategori(context, token, GlobalVar.kategori8);
            // await getKategori(context, token, GlobalVar.kategori9);
            // await getKategori(context, token, GlobalVar.kategori10);
            // await getKategori(context, token, GlobalVar.kategori11);
            // await getKategori(context, token, GlobalVar.kategori12);
            // await getKategori(context, token, GlobalVar.kategori13);
            // await getKategori(context, token, GlobalVar.kategori14);
            // await getKategori(context, token, GlobalVar.kategori15);
          },
          icon: const Icon(
            Icons.menu_rounded,
            color: Color.fromARGB(255, 123, 123, 123),
            size: 40,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/user');
            },
            icon: const Icon(
              Icons.account_circle_outlined,
              color: Color.fromARGB(255, 123, 123, 123),
              size: 40,
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(),
      body: CustomScrollView(slivers: [
        const SliverAppBar(
          floating: true,
          snap: true,
          elevation: 0.0,
          toolbarHeight: 0.01,
        ),
        SliverFillRemaining(
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: ListView(
              children: [
                const TopHeader(),
                //search bar
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Search your favourite book...',
                      labelStyle: const TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Color.fromARGB(255, 184, 184, 184),
                      ),
                      prefixIcon: const Icon(Icons.search_rounded),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.mic),
                        onPressed: () {},
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: const Color.fromARGB(255, 244, 244, 244),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                    ),
                  ),
                ),
                // categories
                const Padding(
                  padding: EdgeInsets.only(
                    top: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 20, left: 20),
                        child: Text(
                          'Categories',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                              letterSpacing: 1),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      CategoryButtons()
                    ],
                  ),
                ),
                ValueListenableBuilder(
                  valueListenable: APIBook.listenable(),
                  builder: (context, Box<HiveBookAPI> myAPIBook, _) {
                    return SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: FutureBuilder<bool>(
                        future: allProduct,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return Container(
                              // color: colors.bgTeal50,
                              child: Container(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Column(
                                        children: [
                                          bookShelf(
                                              context,
                                              GlobalVar.kategori1Title,
                                              GlobalVar.kategori1,
                                              kategori1Books,
                                              APIBook),
                                          bookShelf(
                                              context,
                                              GlobalVar.kategori2Title,
                                              GlobalVar.kategori2,
                                              kategori2Books,
                                              APIBook),
                                          bookShelf(
                                              context,
                                              GlobalVar.kategori3Title,
                                              GlobalVar.kategori3,
                                              kategori3Books,
                                              APIBook),
                                          bookShelf(
                                              context,
                                              GlobalVar.kategori4Title,
                                              GlobalVar.kategori4,
                                              kategori4Books,
                                              APIBook),
                                          bookShelf(
                                              context,
                                              GlobalVar.kategori5Title,
                                              GlobalVar.kategori5,
                                              kategori5Books,
                                              APIBook),
                                          bookShelf(
                                              context,
                                              GlobalVar.kategori6Title,
                                              GlobalVar.kategori6,
                                              kategori6Books,
                                              APIBook),
                                          bookShelf(
                                              context,
                                              GlobalVar.kategori7Title,
                                              GlobalVar.kategori7,
                                              kategori7Books,
                                              APIBook),
                                          bookShelf(
                                              context,
                                              GlobalVar.kategori8Title,
                                              GlobalVar.kategori8,
                                              kategori8Books,
                                              APIBook),
                                          bookShelf(
                                              context,
                                              GlobalVar.kategori9Title,
                                              GlobalVar.kategori9,
                                              kategori9Books,
                                              APIBook),
                                          bookShelf(
                                              context,
                                              GlobalVar.kategori10Title,
                                              GlobalVar.kategori10,
                                              kategori10Books,
                                              APIBook),
                                          bookShelf(
                                              context,
                                              GlobalVar.kategori11Title,
                                              GlobalVar.kategori11,
                                              kategori11Books,
                                              APIBook),
                                          bookShelf(
                                              context,
                                              GlobalVar.kategori12Title,
                                              GlobalVar.kategori12,
                                              kategori12Books,
                                              APIBook),
                                          bookShelf(
                                              context,
                                              GlobalVar.kategori13Title,
                                              GlobalVar.kategori13,
                                              kategori13Books,
                                              APIBook),
                                          bookShelf(
                                              context,
                                              GlobalVar.kategori14Title,
                                              GlobalVar.kategori14,
                                              kategori14Books,
                                              APIBook),
                                          bookShelf(
                                              context,
                                              GlobalVar.kategori15Title,
                                              GlobalVar.kategori15,
                                              kategori15Books,
                                              APIBook),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }
                          return Center(
                            child: SpinKitDoubleBounce(
                              color: Colors.grey.shade700,
                              size: 50.0,
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        )
      ]),
    );
  }
}
