import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:jendela_dbp/api_services.dart';
import 'package:jendela_dbp/controllers/dbp_color.dart';
import 'package:jendela_dbp/controllers/global_var.dart';
import 'package:jendela_dbp/hive/models/hive_book_model.dart';
import 'package:jendela_dbp/view/pages/purchasing/customer_detail.dart';



class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  Box<HiveBookAPI> toCartBook = Hive.box<HiveBookAPI>(GlobalVar.toCartBook);
  final DbpColor colors = DbpColor();
  List<int> addToCartListkeys = [];
  double subTotalValue = 0.0;
  late Future<bool> cusDetail;
  bool fieldStatusOK = false;

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController companyController = TextEditingController();
  TextEditingController emailControlelr = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController postalCodeController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  bool isToPay = false;
  dynamic userData;
  dynamic userSavedBillingDetails;

  void calculateTotal(price) {
    setState(() {
      subTotalValue += double.parse(price);
    });
  }

  Future<bool> getAndSetCustomerDetails() async {
    dynamic checkSavedDataIfExist;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    userData = json.decode(prefs.getString('userData') ?? '');
    checkSavedDataIfExist = prefs.getString('BillingDetails');

    if (checkSavedDataIfExist != null) {
      userSavedBillingDetails = json.decode(checkSavedDataIfExist);
      // print("hre habe data");
      // print(userSavedBillingDetails);
      if (userSavedBillingDetails['id'] == userData['id']) {
        setCustomerDetails(userSavedBillingDetails);
      }
    } else {
      setCustomerDetails(userData);
    }
    checkTextFieldStatus();
    return true;
  }

  void setCustomerDetails(billingDetails) {
    firstNameController.text = billingDetails['name'] ?? '';
    lastNameController.text = billingDetails['last_name'] ?? '';
    companyController.text = billingDetails['company'] ?? '';
    emailControlelr.text = billingDetails['email'] ?? '';
    phoneController.text = billingDetails['phone'] ?? '';
    addressController.text = billingDetails['address_1'] ?? '';
    cityController.text = billingDetails['city'] ?? '';
    stateController.text = billingDetails['state'] ?? '';
    postalCodeController.text = billingDetails['postcode'] ?? '';
    countryController.text = billingDetails['country'] ?? '';
  }

  Future<void> postToCreateOrder(context) async {
    setState(() {
      isToPay = true;
    });
    checkTextFieldStatus();
    // fieldStatusOK = true; //for testing purposes only
    if (fieldStatusOK) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      var userID = prefs.getString('userID');
      List<Map<String, String>> productMap = [];

      addToCartListkeys = toCartBook.keys
          .cast<int>()
          .where((key) => toCartBook.get(key)!.toCheckout == true)
          .toList();

      // print("here valuee : " + addToCartListkeys.toString());
      for (int index = 0; index < addToCartListkeys.length; index++) {
        // print(addToCartListkeys.length.toString());
        int key = addToCartListkeys[index];

        HiveBookAPI? specificBook = toCartBook.get(key);
        productMap.add({
          "product_id": specificBook!.id.toString(),
          "quantity": specificBook.quantity.toString()
        });
      }

      var customerDetails = {
        "first_name": firstNameController.text,
        "last_name": lastNameController.text,
        "company": companyController.text,
        "email": emailControlelr.text,
        "phone": phoneController.text,
        "address": addressController.text,
        "city": cityController.text,
        "state": stateController.text,
        "postalcode": postalCodeController.text,
        "country": countryController.text
      };
      var jsonPost = {
        "payment_method": "toyyibPay",
        "payment_method_title": "Bayar dengan selamat menggunakan toyyibPay.",
        "set_paid": false,
        "line_items": productMap,
        "customer_id": userID,
        "shipping_lines": [
          {
            "method_id": "flat_rate",
            "method_title": "Flat Rate",
            "total": "0.00"
          }
        ],
        "billing": customerDetails,
        "shipping": customerDetails
      };
      final response = await ApiService.checkoutWc(token, jsonPost);
      if (response == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          width: 200,
          behavior: SnackBarBehavior.floating,
          content: Text("Ralat, sila cuba sebentar lagi"),
          duration: Duration(seconds: 1),
        ));
      } else if (response.statusCode >= 200 && response.statusCode < 300) {
        var dataOrder = json.decode(response.body);
        // print(response.body);

        createPayment(dataOrder['id']);
      } else if (response.statusCode == 401) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          width: 200,
          behavior: SnackBarBehavior.floating,
          content: Text('Session Expired. Please login again'),
          duration: Duration(seconds: 1),
        ));
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/Logout', (Route<dynamic> route) => false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          width: 200,
          behavior: SnackBarBehavior.floating,
          content: Text(response.reasonPhrase),
          duration: const Duration(seconds: 1),
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        width: 200,
        behavior: SnackBarBehavior.floating,
        content: Text('Sila lengkapkan maklumat pembeli'),
        duration: Duration(seconds: 1),
      ));
    }
    setState(() {
      isToPay = false;
    });
  }

  Future<void> createPayment(orderID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //var userID = prefs.getString('userID');
    var token = prefs.getString('token');
    // print('after create order');
    // print(orderID);

    var jsonPost = {
      "payment_method": "toyyibPay",
      "order_id": orderID.toString(),
      "payment_token": ""
    };

    ApiService.createPayment(token, jsonPost).then((response) {
      dynamic data;
      if (response.statusCode == 401) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          width: 200,
          behavior: SnackBarBehavior.floating,
          content: Text('Session Expired. Please login again'),
          duration: Duration(seconds: 1),
        ));
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/Logout', (Route<dynamic> route) => false);
      } else if (response.statusCode >= 200 && response.statusCode < 300) {
        data = json.decode(response.body);

        Navigator.of(context)
            .pushNamed('/PaymentGateway', arguments: data['data']['redirect']);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    cusDetail = getAndSetCustomerDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Daftar Keluar',
            style: TextStyle(color: Colors.black),
          ),
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: colors.bgPrimaryColor,
          // elevation: 0,
        ),
        body: FutureBuilder<bool>(
          future: cusDetail,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    color: Colors.white,
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () => Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (builder) => CustomerDetails(
                                          firstName: firstNameController,
                                          lastName: lastNameController,
                                          company: companyController,
                                          email: emailControlelr,
                                          phone: phoneController,
                                          address: addressController,
                                          city: cityController,
                                          state: stateController,
                                          postalcode: postalCodeController,
                                          country: countryController)))
                              .then((value) {
                            checkTextFieldStatus();
                          }),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.person_pin_outlined,
                                    color: DbpColor().jendelaGreen,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  fieldStatusOK
                                      ? SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              90,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                'Perincian Bil',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              const SizedBox(
                                                height: 12,
                                              ),
                                              Text(
                                                  "${firstNameController.text} ${lastNameController.text}"),
                                              companyController.text == ""
                                                  ? Container()
                                                  : Text(
                                                      companyController.text),
                                              Text(
                                                  "${emailControlelr.text} | ${phoneController.text}"),
                                              Text(
                                                  "${addressController.text}, ${cityController.text}, ${postalCodeController.text} ${stateController.text}, ${countryController.text}")
                                            ],
                                          ),
                                        )
                                      : const Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                'Maklumat pembeli tidak lengkap'),
                                            Text(
                                                'Tekan untuk mengisi maklumat anda'),
                                          ],
                                        )
                                ],
                              ),
                              const Icon(
                                Icons.arrow_forward_ios,
                                size: 20,
                              )
                            ],
                          ),
                        )),
                  ),
                  const Divider(),
                  Expanded(
                    child: ValueListenableBuilder(
                        valueListenable: toCartBook.listenable(),
                        builder: (context, Box<HiveBookAPI> myCart, _) {
                          addToCartListkeys = toCartBook.keys
                              .cast<int>()
                              .where((key) =>
                                  toCartBook.get(key)!.toCheckout == true)
                              .toList();

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
                                    final int key = addToCartListkeys[index];
                                    final HiveBookAPI? specificBook =
                                        myCart.get(key);

                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8, right: 8),
                                      child: Container(
                                          padding: const EdgeInsets.all(10),
                                          color: Colors.white,
                                          width: double.infinity,
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          color: Colors.red,
                                                          border: Border.all(
                                                              color: Colors
                                                                  .black)),
                                                      height: 70,
                                                      child: specificBook!
                                                                  .images ==
                                                              "Tiada"
                                                          ? Image.asset(
                                                              "assets/bookCover2/tiadakulitbuku.png",
                                                              // width: 120,
                                                            )
                                                          : Image.network(
                                                              specificBook
                                                                      .images ??
                                                                  '',
                                                              // width: 120,
                                                            ),
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Flexible(
                                                      child: SizedBox(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
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
                                                                  specificBook
                                                                          .name ??
                                                                      '',
                                                                  style:
                                                                      const TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                  height: 5,
                                                                ),
                                                                Text(
                                                                  "Variasi: ${specificBook.type ?? ''}",
                                                                  style:
                                                                      const TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                  height: 10,
                                                                ),
                                                                SizedBox(
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Text(
                                                                        "RM${specificBook.regularPrice == '' || specificBook.regularPrice == null ? '0' : specificBook.regularPrice.toString()}",
                                                                        style: const TextStyle(
                                                                            color:
                                                                                Color(0xffE06913),
                                                                            fontWeight: FontWeight.bold),
                                                                      ),
                                                                      Text(
                                                                        "x${specificBook.quantity}",
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                14),
                                                                      )
                                                                    ],
                                                                  ),
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
                                          )),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(),
                                        ValueListenableBuilder(
                                          valueListenable:
                                              toCartBook.listenable(),
                                          builder: (context,
                                              Box<HiveBookAPI> myCart, _) {
                                            var totalPrice = 0.0;
                                            addToCartListkeys = toCartBook.keys
                                                .cast<int>()
                                                .where((key) =>
                                                    toCartBook
                                                        .get(key)!
                                                        .toCheckout ==
                                                    true)
                                                .toList();

                                            for (int index = 0;
                                                index <
                                                    addToCartListkeys.length;
                                                index++) {
                                              final int key =
                                                  addToCartListkeys[index];
                                              final HiveBookAPI? specificBook =
                                                  myCart.get(key);

                                              totalPrice += double.parse(
                                                      specificBook!.regularPrice ==
                                                                  '' ||
                                                              specificBook
                                                                      .regularPrice ==
                                                                  null
                                                          ? '0'
                                                          : specificBook
                                                              .regularPrice
                                                              .toString()) *
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
                                                      "RM $totalPrice",
                                                      style: TextStyle(
                                                          color: DbpColor()
                                                              .jendelaGreen,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )
                                                  ],
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    postToCreateOrder(context);
                                                  },
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    height: 70,
                                                    width: 120,
                                                    color:
                                                        DbpColor().jendelaGreen,
                                                    child: const Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          'Teruskan',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        Text(
                                                          'Pembayaran',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ],
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              )
                            ],
                          );
                        }),
                  ),
                ],
              );
            }
            return Center(
              child: LoadingAnimationWidget.discreteCircle(
                color: DbpColor().jendelaGray,
                secondRingColor: DbpColor().jendelaGreen,
                thirdRingColor: DbpColor().jendelaOrange,
                size: 50.0,
              ),
            );
          },
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

  showAlertDialog(BuildContext context, key) async {
    // set up the buttons

    Widget cancelButton = ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
      ),
      child: const Text(
        "Batalkan",
        style: TextStyle(color: Colors.black),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: DbpColor().jendelaGreen,
        ),
        child: const Text("Teruskan"),
        onPressed: () async {
          // print('here key sekarang:: ' + key.toString());
          await toCartBook.delete(key).then((value) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              width: 250,
              behavior: SnackBarBehavior.floating,
              content: Text('Produk dibuang dari senarai troli'),
              duration: Duration(seconds: 1),
            ));
          });
        });

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: const Text("Anda pasti untuk membuang produk ini?"),
      actions: [
        continueButton,
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

  void checkTextFieldStatus() {
    bool status = true;
    if (firstNameController.text == "") {
      status = false;
    }

    if (firstNameController.text == "") {
      status = false;
    }

    if (lastNameController.text == "") {
      status = false;
    }

    if (phoneController.text == "") {
      status = false;
    }
    if (addressController.text == "") {
      status = false;
    }
    if (cityController.text == "") {
      status = false;
    }
    if (stateController.text == "") {
      status = false;
    }
    if (postalCodeController.text == "") {
      status = false;
    }
    if (countryController.text == "") {
      status = false;
    }

    setState(() {
      fieldStatusOK = status;
    });
  }
}
