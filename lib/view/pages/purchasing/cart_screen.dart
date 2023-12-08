import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:msh_checkbox/msh_checkbox.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:jendela_dbp/api_services.dart';
import 'package:jendela_dbp/controllers/dbp_color.dart';
import 'package:jendela_dbp/controllers/global_var.dart';
import 'package:jendela_dbp/hive/models/hive_book_model.dart';
import 'package:jendela_dbp/view/pages/purchasing/checkout_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  Box<HiveBookAPI> toCartBook = Hive.box<HiveBookAPI>(GlobalVar.toCartBook);
  final DbpColor colors = DbpColor();
  List<int> addToCartListkeys = [];
  double subTotalValue = 0.0;
  bool selectAll = false;

  dynamic inCartData;

  void calculateTotal(price) {
    setState(() {
      subTotalValue += double.parse(price);
    });
  }

  Future<void> postToCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var userID = prefs.getString('userID');
    List<Map<String, String>> productMap = [];

    for (int index = 0; index < addToCartListkeys.length; index++) {
      // print(addToCartListkeys.length.toString());
      int key = addToCartListkeys[index];

      HiveBookAPI? specificBook = toCartBook.get(key);
      productMap
          .add({"product_id": specificBook!.id.toString(), "quantity": "1"});

      // print(specificBook.id);
    }
    // print(json.encode(productMap));
    // var queryParameters = {
    //   'user_id': userID,
    //   'products': productMap.toString()
    // };

    var jsonPost = {"user_id": userID, "products": productMap};

    ApiService.addListOfBookToCart(token, jsonPost).then((response) {
      if (response.statusCode == 401) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          width: 200,
          behavior: SnackBarBehavior.floating,
          content: Text('Sesi Tamat Tempoh, Sila Log Masuk'),
          duration: Duration(seconds: 1),
        ));
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/Logout', (Route<dynamic> route) => false);
      }
    });

    // getAllProduct();
  }

  Future<void> getAllProduct() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userID = prefs.getString('userID');
    var token = prefs.getString('token');

    var queryParameters = {'user_id': userID};

    ApiService.getListOfBookInCart(token, queryParameters).then((response) {
      dynamic data;
      if (response.statusCode == 401) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          width: 200,
          behavior: SnackBarBehavior.floating,
          content: Text('Sesi Tamat Tempoh, Sila Log Masuk'),
          duration: Duration(seconds: 1),
        ));
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/Logout', (Route<dynamic> route) => false);
      } else if (response.statusCode == 200) {
        // print(response.body.toString());
        data = json.decode(response.body);
        inCartData = data['value'];
      }
    });
  }

  void checkInternetAccess() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      postToCart();
    } else {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(GlobalVar.tiadaInternet),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    addToCartListkeys = toCartBook.keys.cast<int>().toList();
    checkInternetAccess();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Troli Belian',
            style: TextStyle(color: Colors.black),
          ),
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: colors.bgPrimaryColor,
          // elevation: 0,
        ),
        body: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: toCartBook.listenable(),
                builder: (context, Box<HiveBookAPI> myCart, _) {
                  addToCartListkeys = toCartBook.keys.cast<int>().toList();

                  return Column(
                    children: [
                      Expanded(
                        child: ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          separatorBuilder: (_, index) => const Divider(
                            height: 8,
                          ),
                          itemCount: addToCartListkeys.length,
                          shrinkWrap: true,
                          itemBuilder: (_, index) {
                            // print(
                            //     "Total Data: " + addToCartListkeys.toString());
                            final int key = addToCartListkeys[index];
                            final HiveBookAPI? specificBook = myCart.get(key);

                            return Padding(
                              padding: const EdgeInsets.only(left: 8, right: 8),
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                color: Colors.white,
                                width: double.infinity,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 150,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 18),
                                            child: MSHCheckbox(
                                                style: MSHCheckboxStyle
                                                    .fillScaleCheck,
                                                size: 20,
                                                // ignore: deprecated_member_use
                                                checkedColor:
                                                    DbpColor().jendelaGreen,
                                                // ignore: deprecated_member_use
                                                uncheckedColor:
                                                    DbpColor().jendelaGreen,
                                                value:
                                                    specificBook!.toCheckout ??
                                                        false,
                                                onChanged: (state) {
                                                  if (state == false) {
                                                    setState(() {
                                                      selectAll = false;
                                                    });
                                                  }
                                                  updateBookCheckBox(
                                                      specificBook, key, state);
                                                }),
                                          ),
                                          SizedBox(
                                            height: 150,
                                            child: specificBook.images ==
                                                    "Tiada"
                                                ? ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    child: Image.asset(
                                                      "assets/bookCover2/tiadakulitbuku.png",
                                                      fit: BoxFit.cover,
                                                      // width: 120,
                                                    ),
                                                  )
                                                : ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    child: Image.network(
                                                      specificBook.images ?? '',
                                                      fit: BoxFit.cover,
                                                      // width: 120,
                                                    ),
                                                  ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Flexible(
                                            child: SizedBox(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        specificBook.name ?? '',
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      SizedBox(
                                                        child: Row(
                                                          children: [
                                                            const Text(
                                                              "Format: ",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                            Text(
                                                              specificBook
                                                                      .type ??
                                                                  '',
                                                              style:
                                                                  const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    child: Text(
                                                      "RM${specificBook.regularPrice == "" || specificBook.regularPrice == null ? '0' : specificBook.regularPrice ?? "0"}",
                                                      style: const TextStyle(
                                                          color:
                                                              Color(0xffE06913),
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      InkWell(
                                                        onTap: () {
                                                          decreaseQuantity(
                                                              context,
                                                              specificBook,
                                                              key);
                                                        },
                                                        child: Container(
                                                            height: 22,
                                                            width: 25,
                                                            decoration: BoxDecoration(
                                                                border: Border(
                                                                    top: BorderSide(
                                                                        color: Colors
                                                                            .black
                                                                            .withOpacity(
                                                                                0.2)),
                                                                    bottom: BorderSide(
                                                                        color: Colors
                                                                            .black
                                                                            .withOpacity(
                                                                                0.2)),
                                                                    left: BorderSide(
                                                                        color: Colors
                                                                            .black
                                                                            .withOpacity(0.2)))),
                                                            child: const Icon(
                                                              Icons.remove,
                                                              size: 15,
                                                            )),
                                                      ),
                                                      Container(
                                                        alignment:
                                                            Alignment.center,
                                                        height: 22,
                                                        width: 45,
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.2),
                                                          ),
                                                        ),
                                                        child: Text(
                                                          specificBook.quantity
                                                              .toString(),
                                                        ),
                                                      ),
                                                      InkWell(
                                                        onTap: () {
                                                          addQuantity(
                                                              context,
                                                              specificBook,
                                                              key);
                                                        },
                                                        child: Container(
                                                            height: 22,
                                                            width: 25,
                                                            decoration:
                                                                BoxDecoration(
                                                              border: Border(
                                                                top: BorderSide(
                                                                  color: Colors
                                                                      .black
                                                                      .withOpacity(
                                                                          0.2),
                                                                ),
                                                                bottom:
                                                                    BorderSide(
                                                                  color: Colors
                                                                      .black
                                                                      .withOpacity(
                                                                          0.2),
                                                                ),
                                                                right:
                                                                    BorderSide(
                                                                  color: Colors
                                                                      .black
                                                                      .withOpacity(
                                                                          0.2),
                                                                ),
                                                              ),
                                                            ),
                                                            child: const Icon(
                                                              Icons.add,
                                                              size: 15,
                                                            )),
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Column(
                        children: [
                          // addToCartListkeys.length != 0
                          //     ? Container(
                          //         padding: const EdgeInsets.all(10),
                          //         color: Colors.white,
                          //         child: Column(
                          //           children: [
                          //             Row(
                          //               mainAxisAlignment:
                          //                   MainAxisAlignment.spaceBetween,
                          //               children: [
                          //                 Text('Subtotal',
                          //                     style: TextStyle(
                          //                         fontWeight:
                          //                             FontWeight.bold)),
                          //                 Text(
                          //                   'RM' + subTotalValue.toString(),
                          //                   style: TextStyle(
                          //                       fontWeight: FontWeight.bold),
                          //                 )
                          //               ],
                          //             ),
                          //             SizedBox(
                          //               height: 10,
                          //             ),
                          //             Row(
                          //               mainAxisAlignment:
                          //                   MainAxisAlignment.spaceBetween,
                          //               children: [
                          //                 Container(
                          //                   padding: const EdgeInsets.all(3),
                          //                   width: MediaQuery.of(context)
                          //                           .size
                          //                           .width /
                          //                       2.5,
                          //                   height: 30,
                          //                   decoration: BoxDecoration(
                          //                       border: Border.all(
                          //                           color:
                          //                               Color(0xffE0E0E0))),
                          //                   child: TextField(),
                          //                 ),
                          //                 Row(
                          //                   children: [
                          //                     Text(
                          //                       'Apply Coupon',
                          //                       style: TextStyle(
                          //                           fontWeight:
                          //                               FontWeight.bold,
                          //                           color: Color(0xff2AAC95)),
                          //                     ),
                          //                     SizedBox(
                          //                       width: 20,
                          //                     )
                          //                   ],
                          //                 )
                          //               ],
                          //             )
                          //           ],
                          //         ),
                          //       )
                          //     : Container(),
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            color: Colors.white,
                            height: 70,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 19, right: 10),
                                      child: MSHCheckbox(
                                          style:
                                              MSHCheckboxStyle.fillScaleCheck,
                                          size: 20,
                                          // ignore: deprecated_member_use
                                          checkedColor: DbpColor().jendelaGreen,
                                          // ignore: deprecated_member_use
                                          uncheckedColor:
                                              DbpColor().jendelaGreen,
                                          value: selectAll,
                                          onChanged: (state) {
                                            selectAllProduct(state);
                                            setState(() {
                                              selectAll = state;
                                            });
                                          }),
                                    ),
                                    const Text(
                                      'Semua',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                                ValueListenableBuilder(
                                  valueListenable: toCartBook.listenable(),
                                  builder:
                                      (context, Box<HiveBookAPI> myCart, _) {
                                    dynamic toCheckoutListkeys;
                                    var totalPrice = 0.0;
                                    toCheckoutListkeys = toCartBook.keys
                                        .cast<int>()
                                        .where((key) =>
                                            toCartBook.get(key)!.toCheckout ==
                                            true)
                                        .toList();

                                    for (int index = 0;
                                        index < toCheckoutListkeys.length;
                                        index++) {
                                      final int key = toCheckoutListkeys[index];
                                      final HiveBookAPI? specificBook =
                                          myCart.get(key);

                                      totalPrice += double.parse(specificBook!
                                                          .regularPrice ==
                                                      "" ||
                                                  specificBook.regularPrice ==
                                                      null
                                              ? '0'
                                              : specificBook.regularPrice ??
                                                  '0') *
                                          (specificBook.quantity ?? 1);
                                    }
                                    return Row(
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            const Text('Jumlah'),
                                            Text(
                                              "RM${totalPrice.toStringAsFixed(2)}",
                                              style: TextStyle(
                                                  color:
                                                      DbpColor().jendelaGreen,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          ],
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            if (toCheckoutListkeys.length ==
                                                0) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                behavior:
                                                    SnackBarBehavior.floating,
                                                content: Text(
                                                    GlobalVar.daftarKeluarBuku),
                                                duration:
                                                    const Duration(seconds: 1),
                                              ));
                                            } else {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const CheckoutScreen(),
                                                ),
                                              );
                                            }
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            height: 70,
                                            width: 120,
                                            color: DbpColor().jendelaGreen,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  'Daftar',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                //toCheckoutListkeys.length.toString()
                                                Text(
                                                  'Keluar (${toCheckoutListkeys.length.toString()})',
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    );
                                  },
                                )
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  );
                },
              ),
            ),
          ],
        ));
  }

  Future<void> updateBookCheckBox(specificBook, key, state) async {
    HiveBookAPI updateBookData = HiveBookAPI(
        id: specificBook.id,
        name: specificBook.name,
        images: specificBook.images,
        description: specificBook.description,
        categories: specificBook.categories,
        regularPrice: specificBook.regular_price,
        salePrice: specificBook.sale_price,
        averageRating: specificBook.average_rating,
        quantity: specificBook.quantity,
        type: specificBook.type,
        woocommerceVariations: specificBook.woocommerce_variations,
        toCheckout: state);

    await toCartBook.put(key, updateBookData);
  }

  void addQuantity(context, specificBook, key) {
    HiveBookAPI updateBookData = HiveBookAPI(
        id: specificBook.id,
        name: specificBook.name,
        images: specificBook.images,
        description: specificBook.description,
        categories: specificBook.categories,
        regularPrice: specificBook.regular_price,
        salePrice: specificBook.sale_price,
        averageRating: specificBook.average_rating,
        quantity: specificBook.quantity + 1,
        type: specificBook.type,
        woocommerceVariations: specificBook.woocommerce_variations,
        toCheckout: specificBook.toCheckout);

    toCartBook.put(key, updateBookData);
  }

  void decreaseQuantity(context, specificBook, key) {
    if (specificBook.quantity == 1) {
      showAlertDialog(context, key);
    } else {
      HiveBookAPI updateBookData = HiveBookAPI(
          id: specificBook.id,
          name: specificBook.name,
          images: specificBook.images,
          description: specificBook.description,
          categories: specificBook.categories,
          regularPrice: specificBook.regular_price,
          salePrice: specificBook.sale_price,
          averageRating: specificBook.average_rating,
          quantity: specificBook.quantity - 1,
          type: specificBook.type,
          woocommerceVariations: specificBook.woocommerce_variations,
          toCheckout: specificBook.toCheckout);

      toCartBook.put(key, updateBookData);
    }
  }

  void selectAllProduct(state) {
    for (int index = 0; index < addToCartListkeys.length; index++) {
      final int key = addToCartListkeys[index];
      final HiveBookAPI? specificBook = toCartBook.get(key);

      HiveBookAPI updateBookData = HiveBookAPI(
          id: specificBook!.id,
          name: specificBook.name,
          images: specificBook.images,
          description: specificBook.description,
          categories: specificBook.categories,
          regularPrice: specificBook.regularPrice,
          salePrice: specificBook.salePrice,
          averageRating: specificBook.averageRating,
          quantity: specificBook.quantity,
          type: specificBook.type,
          woocommerceVariations: specificBook.woocommerceVariations,
          toCheckout: state);

      toCartBook.put(key, updateBookData);
    }
  }

  showAlertDialog(BuildContext context, key) async {
    // set up the buttons
    Widget cancelButton = ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xffEBE9EB),
      ),
      child: const Text(
        "Batalkan",
        style: TextStyle(color: Colors.black),
      ),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
    );

    Widget continueButton = ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: DbpColor().jendelaGreen,
      ),
      child: const Text(
        "Teruskan",
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () async {
        // print('here key sekarang:: ' + key.toString());
        Navigator.of(context, rootNavigator: true).pop();
        await toCartBook.delete(key).then((value) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            width: 250,
            behavior: SnackBarBehavior.floating,
            content: Text('Produk dibuang dari senarai troli'),
            duration: Duration(seconds: 1),
          ));
        });
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.white,
      elevation: 0,
      content: const Text(
        "Anda pasti untuk membuang produk ini?",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        continueButton,
        const SizedBox(width: 12),
        cancelButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
