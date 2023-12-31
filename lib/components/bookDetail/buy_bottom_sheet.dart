import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hive/hive.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:jendela_dbp/controllers/dbp_color.dart';
import 'package:jendela_dbp/hive/models/hive_book_model.dart';

// ignore: must_be_immutable
class BuyBottomSheet extends StatefulWidget {
  BuyBottomSheet({
    super.key,
    this.book,
    this.toJSonVariation,
    this.formatType,
    this.toCartBook,
  });

  final HiveBookAPI? book;
  final List? toJSonVariation;
  dynamic formatType;
  final Box<HiveBookAPI>? toCartBook;

  @override
  State<BuyBottomSheet> createState() => _BuyBottomSheetState();
}

class _BuyBottomSheetState extends State<BuyBottomSheet> {
  var productPrice = '0';
  var activeNow = 0;
  Color buttonActive = const Color.fromARGB(255, 235, 127, 35);
  Color buttonDeactive = Colors.transparent;
  Color textActive = Colors.white;
  Color textDeactive = Colors.black;

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        if (widget.toJSonVariation!.isNotEmpty) {
          return Column(
            children: [
              Row(
                children: [
                  // book image
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 24, left: 24, right: 24, bottom: 24),
                    child: SizedBox(
                      height: 120,
                      width: 100,
                      child: widget.book!.images == "Tiada"
                          ? Image.asset(
                              "assets/bookCover2/tiadakulitbuku.png",
                              fit: BoxFit.fill,
                              // width: 120,
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: CachedNetworkImage(
                                imageUrl: widget.book!.images ?? '',
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) =>
                                        Container(
                                  alignment: Alignment.center,
                                  child: LoadingAnimationWidget.discreteCircle(
                                    color: DbpColor().jendelaGray,
                                    secondRingColor: DbpColor().jendelaGreen,
                                    thirdRingColor: DbpColor().jendelaOrange,
                                    size: 50.0,
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                            ),
                    ),
                  ),
                  // book price
                  Text('RM ${widget.book!.price!}'),
                ],
              ),
              const Divider(
                indent: 12,
                endIndent: 12,
              ),
              // book format
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: List.generate(
                        widget.toJSonVariation!.length,
                        (index) {
                          widget.formatType = '';

                          widget.formatType = widget.toJSonVariation![index]
                                  ['attributes']!["pa_pilihan-format"] is String
                              ? "Pilihan Format: ${widget.toJSonVariation![index]['attributes']!["pa_pilihan-format"]}"
                              : "Pilihan Format: Buku Cetak";

                          widget.formatType = widget.formatType.split(":")[1];
                          if (widget.formatType
                              .toLowerCase()
                              .contains('cetak')) {
                            widget.formatType = widget.formatType
                                .toUpperCase()
                                .replaceAll(RegExp(r'(_|-)+'), ' ');
                          } else if (widget.formatType
                              .toLowerCase()
                              .contains('pdf')) {
                            widget.formatType = "PDF";
                          } else if (widget.formatType
                              .toLowerCase()
                              .contains('epub')) {
                            widget.formatType = "EPUB";
                          } else if (widget.formatType
                                  .toLowerCase()
                                  .contains('audio') ||
                              widget.formatType.toLowerCase().contains('MP3')) {
                            widget.formatType = "Audio";
                          }

                          return ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: activeNow == index
                                  ? buttonActive
                                  : buttonDeactive,
                              foregroundColor: activeNow == index
                                  ? buttonActive
                                  : buttonDeactive,
                              elevation:
                                  0, // Set elevation to 0 to remove shadow
                            ),
                            onPressed: () {
                              setState(
                                () {
                                  productPrice =
                                      widget.toJSonVariation![index]['price'];
                                  activeNow = index;
                                },
                              );
                            },
                            child: Text(
                              widget.formatType,
                              style: TextStyle(
                                  color: activeNow == index
                                      ? textActive
                                      : textDeactive),
                            ),
                          );
                        },
                      ),
                    ),
                  )
                ],
              ),
              const Divider(
                indent: 12,
                endIndent: 12,
              ),
              widget.toJSonVariation![activeNow]['attribute_summary']
                      .replaceAll(RegExp(r"\s+"), "")
                      .split(":")[1]
                      .contains('cetak')
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        OutlinedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              side: const BorderSide(color: Colors.red),
                              elevation: 0),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            'Cancel',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            var connectivityResult =
                                await (Connectivity().checkConnectivity());
                            if (connectivityResult ==
                                    ConnectivityResult.mobile ||
                                connectivityResult == ConnectivityResult.wifi) {
                              // print("URL is: " +
                              //     toJSonVariation[activeNow]
                              //         ['external_url']);
                            } else {
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  content: Text('Internet Acccess Needed'),
                                  duration: Duration(seconds: 3),
                                ),
                              );
                            }
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: (MediaQuery.of(context).size.width / 2) - 20,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: DbpColor().jendelaGreen,
                              border: Border.all(
                                color: DbpColor().jendelaGreen,
                              ),
                            ),
                            child: const Text(
                              'Beli Sekarang',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          OutlinedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                side: const BorderSide(color: Colors.red),
                                elevation: 0),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              'Batal',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              backgroundColor: DbpColor().jendelaGreen,
                              side: BorderSide(color: DbpColor().jendelaGreen),
                              elevation:
                                  0, // Set elevation to 0 to remove shadow
                            ),
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.shopping_cart_rounded,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  'Tambah ke troli',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            onPressed: () async {
                              var connectivityResult =
                                  await (Connectivity().checkConnectivity());
                              if (connectivityResult ==
                                      ConnectivityResult.mobile ||
                                  connectivityResult ==
                                      ConnectivityResult.wifi) {
                                HiveBookAPI addToCart = HiveBookAPI(
                                    id: widget.toJSonVariation![activeNow]
                                        ['id'],
                                    name: widget.toJSonVariation![activeNow]
                                        ['name'],
                                    images: widget.book!.images,
                                    description:
                                        widget.toJSonVariation![activeNow]
                                            ['description'],
                                    categories: widget.book!.categories,
                                    regularPrice: widget
                                        .toJSonVariation![activeNow]['price'],
                                    salePrice:
                                        widget.toJSonVariation![activeNow]
                                            ['sale_price'],
                                    price: widget.toJSonVariation![activeNow]
                                        ['price'],
                                    averageRating: widget.book!.averageRating,
                                    quantity: 1,
                                    type: widget.toJSonVariation![activeNow]
                                                ['attributes']!["pa_pilihan-format"]
                                            is String
                                        ? widget.toJSonVariation![activeNow]
                                            ['attributes']!["pa_pilihan-format"]
                                        : "Buku Cetak",
                                    woocommerceVariations:
                                        widget.book!.woocommerceVariations,
                                    toCheckout: false);

                                await widget.toCartBook!.add(addToCart).then(
                                  (value) {
                                    Navigator.of(context).pop();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        width: 200,
                                        behavior: SnackBarBehavior.floating,
                                        content: Text('Ditambah ke troli'),
                                        duration: Duration(seconds: 1),
                                      ),
                                    );
                                  },
                                );
                              } else {
                                if (!context.mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    behavior: SnackBarBehavior.floating,
                                    content:
                                        Text('Memerlukan penggunaan internet'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
            ],
          );
        }
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: double
                  .infinity,
              alignment:
                  Alignment.center,
              child: const Text(
                'Maaf, buku ini tiada stok buat masa sekarang.',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 50,
              ),
              child: ElevatedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: DbpColor().jendelaOrange,
                  side: BorderSide(
                    color: DbpColor().jendelaOrange,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Baik',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
