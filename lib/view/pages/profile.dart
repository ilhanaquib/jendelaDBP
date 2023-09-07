import 'package:flutter/material.dart';
import 'package:jendela_dbp/components/bookshelf/bookshelf.dart';
import 'package:jendela_dbp/components/persistentBottomNavBar.dart';
import 'package:jendela_dbp/controllers/globalVar.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:jendela_dbp/hive/models/hiveBookModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jendela_dbp/controllers/getBooksFromApi.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Account'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: SizedBox(
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: const CircleAvatar(
                      radius: 50,
                      child: Icon(
                        Icons.person,
                        size: 40,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Username'),
                        Text('email'),
                        Text('phone'),
                        Text('address'),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
            child: SizedBox(
              child: Table(
                border: const TableBorder(
                    top: BorderSide(width: 1),
                    right: BorderSide(width: 1),
                    bottom: BorderSide(width: 1),
                    left: BorderSide(width: 1),
                    horizontalInside: BorderSide(width: 1)),
                children: const <TableRow>[
                  TableRow(
                    children: <Widget>[
                      TableCell(
                        verticalAlignment: TableCellVerticalAlignment.top,
                        child: Text('Order'),
                      ),
                      TableCell(
                        verticalAlignment: TableCellVerticalAlignment.top,
                        child: Text('Date'),
                      ),
                      TableCell(
                        verticalAlignment: TableCellVerticalAlignment.top,
                        child: Text('Status'),
                      ),
                      TableCell(
                        verticalAlignment: TableCellVerticalAlignment.top,
                        child: Text('Total'),
                      ),
                    ],
                  ),
                  TableRow(
                    children: <Widget>[
                      TableCell(
                        verticalAlignment: TableCellVerticalAlignment.top,
                        child: Text('#61148'),
                      ),
                      TableCell(
                        verticalAlignment: TableCellVerticalAlignment.top,
                        child: Text('15/8/2023'),
                      ),
                      TableCell(
                        verticalAlignment: TableCellVerticalAlignment.top,
                        child: Text('Completed'),
                      ),
                      TableCell(
                        verticalAlignment: TableCellVerticalAlignment.top,
                        child: Text('RM0.00 for 1 item'),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: SizedBox(
              child: bookShelf(context, GlobalVar.kategori1Title,
                  GlobalVar.kategori1, kategori1Books, APIBook),
            ),
          ),
        ],
      ),
    );
  }
}
