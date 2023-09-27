import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:jendela_dbp/hive/models/hiveBookModel.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class readBottomSheet extends StatefulWidget {
  readBottomSheet({
    super.key,
    this.book,
    this.toJSonVariation,
    this.formatType,
  });

  final HiveBookAPI? book;
  final List? toJSonVariation;
  var formatType;

  @override
  State<readBottomSheet> createState() => _readBottomSheetState();
}

class _readBottomSheetState extends State<readBottomSheet> {
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
        return Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: 24, left: 24, right: 24, bottom: 24),
                  child: SizedBox(
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
                                  (context, url, downloadProgress) => Container(
                                alignment: Alignment.center,
                                child: LoadingAnimationWidget.discreteCircle(
                                  color:
                                      const Color.fromARGB(255, 123, 123, 123),
                                  secondRingColor:
                                      const Color.fromARGB(255, 144, 191, 63),
                                  thirdRingColor:
                                      const Color.fromARGB(255, 235, 127, 35),
                                  size: 50.0,
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('RM ${widget.book!.price!}'),
                  ],
                ),
              ],
            ),
            const Divider(
              indent: 12,
              endIndent: 12,
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children:
                        List.generate(widget.toJSonVariation!.length, (index) {
                      widget.formatType = '';

                      widget.formatType = widget.toJSonVariation![index]
                              ['attributes']!["pa_pilihan-format"] is String
                          ? "Pilihan Format: " +
                              widget.toJSonVariation![index]
                                  ['attributes']!["pa_pilihan-format"]
                          : "Pilihan Format: Buku Cetak";

                      widget.formatType = widget.formatType.split(":")[1];
                      if (widget.formatType.toLowerCase().contains('cetak')) {
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
                          elevation: 0, // Set elevation to 0 to remove shadow
                        ),
                        onPressed: () {
                          setState(() {
                            productPrice =
                                widget.toJSonVariation![index]['price'];
                            activeNow = index;
                          });
                        },
                        child: Text(
                          widget.formatType,
                          style: TextStyle(
                              color: activeNow == index
                                  ? textActive
                                  : textDeactive),
                        ),
                      );
                    }),
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
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                            alignment: Alignment.center,
                            width: (MediaQuery.of(context).size.width / 2) - 20,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.red),
                            ),
                            child: const Text(
                              'Batal',
                              style: TextStyle(color: Colors.red),
                            )),
                      ),
                      InkWell(
                        onTap: () async {
                          var connectivityResult =
                              await (Connectivity().checkConnectivity());
                          if (connectivityResult == ConnectivityResult.mobile ||
                              connectivityResult == ConnectivityResult.wifi) {
                            // print("URL is: " +
                            //     toJSonVariation[activeNow]
                            //         ['external_url']);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              behavior: SnackBarBehavior.floating,
                              content: Text('Memerlukan penggunaan internet'),
                              duration: Duration(seconds: 3),
                            ));
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: (MediaQuery.of(context).size.width / 2) - 20,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 144, 191, 63),
                            border: Border.all(
                              color: const Color.fromARGB(255, 144, 191, 63),
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
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            'Batal',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 144, 191, 63),
                            elevation: 0, // Set elevation to 0 to remove shadow
                          ),
                          child: const Text(
                            'Tambah ke Troli',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () async {
                            var connectivityResult =
                                await (Connectivity().checkConnectivity());
                            if (connectivityResult ==
                                    ConnectivityResult.mobile ||
                                connectivityResult ==
                                    ConnectivityResult.wifi) {}
                          },
                        ),
                      ],
                    ),
                  ),
          ],
        );
      },
    );
  }
}
