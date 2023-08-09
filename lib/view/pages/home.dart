import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jendela_dbp/components/bookshelf/bookshelf.dart';
import 'package:jendela_dbp/components/bottom_nav_bar.dart';
import 'package:jendela_dbp/components/home/category_buttons.dart';
import 'package:jendela_dbp/components/home/top_header_home.dart';
import 'package:jendela_dbp/controllers/globalVar.dart';
import 'package:jendela_dbp/hive/models/hiveBookModel.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:jendela_dbp/view/pages/book_detail.dart';
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
          onPressed: () {},
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
      body: CustomScrollView(
        slivers: [
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
                    child: TextButton(
                      onPressed: () {
                        showSearch(
                          context: context,
                          delegate: BookSearchDelegate(APIBook),
                        );
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.black, // Text color
                        backgroundColor: const Color.fromARGB(
                            255, 244, 244, 244), // Button background color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                          side: BorderSide.none,
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            Icon(Icons.search_rounded),
                            SizedBox(
                                width: 10), // Add spacing between icon and text
                            Text(
                              'Search your favourite book...',
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Color.fromARGB(255, 184, 184, 184),
                              ),
                            ),
                          ],
                        ),
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

                  // books
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
        ],
      ),
    );
  }
}

// search
class BookSearchDelegate extends SearchDelegate<String> {
  final Box<HiveBookAPI> apiBook;

  BookSearchDelegate(this.apiBook);

  Stream<List<HiveBookAPI>> searchResultsStream(String query) {
    return Stream.fromFuture(
        Future.delayed(const Duration(milliseconds: 300), () {
      return apiBook.values.where((book) {
        final title = book.name;
        return title!.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }));
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return StreamBuilder<List<HiveBookAPI>>(
      stream: searchResultsStream(query),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final searchResults = snapshot.data!;

        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // You can adjust the number of columns as needed
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 10.0,
          ),
          itemCount: searchResults.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookDetail(
                      bookImage: searchResults[index].images!,
                      bookTitle: searchResults[index].name!,
                      bookDesc: searchResults[index].description!,
                    ),
                  ),
                );
              },
              child: Column(
                children: [
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Stack(
                        children: [
                          CachedNetworkImage(
                            imageUrl: searchResults[index].images!,
                            height: 220,
                            width: 150,
                            fit: BoxFit.fill,
                          ),
                        ],
                      ),
                    ),
                  ), // Use your image data
                  Text(searchResults[index].name!),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return StreamBuilder<List<HiveBookAPI>>(
      stream: searchResultsStream(query),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final suggestionList = snapshot.data!;

        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // You can adjust the number of columns as needed
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 10.0,
          ),
          itemCount: 10,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookDetail(
                      bookImage: suggestionList[index].images!,
                      bookTitle: suggestionList[index].name!,
                      bookDesc: suggestionList[index].description!,
                    ),
                  ),
                );
              },
              child: Column(
                children: [
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Stack(
                        children: [
                          CachedNetworkImage(
                            imageUrl: suggestionList[index].images!,
                            height: 150,
                            width: 100,
                            fit: BoxFit.fill,
                          ),
                        ],
                      ),
                    ),
                  ), // Use your image data
                  Text(
                    suggestionList[index].name!,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        onChanged: (value) {
          query = value;
          showSuggestions(context);
        },
        style: TextStyle(color: Colors.black), // Customize text color
        decoration: InputDecoration(
          hintText: 'Search your favourite book...', // Customize hint text
          hintStyle: TextStyle(color: Colors.grey), // Customize hint text color
          prefixIcon: Icon(Icons.search_rounded),
          suffixIcon: IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              query = '';
              showSuggestions(context);
            },
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
          fillColor: Color.fromARGB(255, 244, 244, 244),
          floatingLabelBehavior: FloatingLabelBehavior.never,
        ),
      ),
    );
  }
}
