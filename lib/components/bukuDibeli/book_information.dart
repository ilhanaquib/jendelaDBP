import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jendela_dbp/components/bookReader/pdf_viewer.dart';
import 'package:jendela_dbp/components/bukuDibeli/book_buttons.dart';
import 'package:jendela_dbp/components/bukuDibeli/download_button.dart';
import 'package:jendela_dbp/controllers/constants.dart';
import 'package:jendela_dbp/controllers/dbp_color.dart';
import 'package:jendela_dbp/controllers/encrypt_file.dart';
import 'package:jendela_dbp/controllers/global_var.dart';
import 'package:jendela_dbp/hive/api/api_book_model.dart';
import 'package:jendela_dbp/hive/models/hiveBookModel.dart';
import 'package:jendela_dbp/hive/models/hivePurchasedBookModel.dart';
import 'package:jendela_dbp/model/categoryModel.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:dio/dio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vocsy_epub_viewer/epub_viewer.dart';

// const String localBook = "LocalBook";

// ignore: must_be_immutable
class BookInformation extends StatefulWidget {
  HivePurchasedBook bookIdentification;

  BookInformation({super.key, required this.bookIdentification});
  @override
  // ignore: library_private_types_in_public_api
  _BookInformationState createState() => _BookInformationState();
}

class _BookInformationState extends State<BookInformation> {
  Dio dio = Dio();
  int received = 0;
  String progress = '0';
  int total = 0;

  List<Book> allBooks = [];
  List<Categoryy> allCategory = [];
  int maxTextLine = 3;
  bool isOpenMaxTextLine = false;
  List<int> dataBookLocal = [];
  List<int> dataBookAPI = [];
  HiveBookAPI? parentDetailsBook;
  HivePurchasedBook? myDetailsBook;
  String? currentUserID;

  String localPathPermanent = "Tiada";

  Box<HiveBookAPI> bookFromAPI = Hive.box<HiveBookAPI>(GlobalVar.apiBook);
  Box<HivePurchasedBook> purchasedBook =
      Hive.box<HivePurchasedBook>(GlobalVar.puchasedBook);

  String currentUser = "";

  int pages = 0;
  bool isMyFavorite = false;

  bool isDownloadFile = false;

  bool isDownloadingFile = false;
  SharedPreferences? prefs;

  List<int> parentBook = [];
  List<int> myBook = [];
  bool isLoadingBook = true;
  dynamic myEpub;
  dynamic myPdf;

  // final Completer<PdfViewerController> _controller =
  //     Completer<PdfViewerController>();

  //final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isCompleteLoading = false;
  final DbpColor colors = DbpColor();

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // print("Data di sini: " +
    // (widget.bookIdentification.featured_media_url ?? ''));
    allCategory = Categoryy.getAllCategory();
    identifyUser();

    getBookDetailFromParent();
  }

  void identifyUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      currentUser = prefs.getString('currentUser') ?? '';
      currentUserID = prefs.getString('userID') ?? '';
    });

    // print('user iss:  ' + currentUser);
    if (currentUser == "") {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text('Expired session. Please login again'),
        duration: Duration(seconds: 3),
      ));

      Future.delayed(const Duration(seconds: 2)).then((value) => Navigator.of(context)
          .pushNamedAndRemoveUntil('/Logout', (Route<dynamic> route) => false));
    } else {
      setState(() {
        isLoadingBook = true;
      });
      setState(() {
        isLoadingBook = false;
      });

      getBookDetails();
    }
  }

  void getBookDetailFromParent() {
    //keys will be in integer (auto increment)
    parentBook = bookFromAPI.keys
        .cast<int>()
        .where((key) =>
            bookFromAPI.get(key)!.id == widget.bookIdentification.parentID)
        //.where((key) => bookFromAPI.get(key).id == widget.bookID)
        .toList();

    if (parentBook.isNotEmpty) {
      // print("parent::Details found: " + parentBook.length.toString());
      parentDetailsBook = bookFromAPI.get(parentBook[0]);
    } else {
      // print("parent:: book not exist or user not purchase yet");
    }
  }

  Future<void> getBookDetails() async {
    //keys will be in integer (auto increment)
    myBook = purchasedBook.keys
        .cast<int>()
        // .where((key) => PurchasedBook.get(key).product_id == widget.bookID)

        .where((key) =>
            purchasedBook.get(key)!.productId ==
            widget.bookIdentification.productId)
        .toList();

    if (myBook.isNotEmpty) {
      myDetailsBook = purchasedBook.get(myBook[0]);
      Directory appDocDir = await getApplicationDocumentsDirectory();
      if (Platform.isAndroid) {
        Directory('${appDocDir.path.split('Android')[0]}${Constants.epubPath}')
            .createSync();
      }

      String path = Platform.isIOS
          ? '${appDocDir.path}/${myDetailsBook!.productId}$currentUser${myDetailsBook!.typeFile!.toLowerCase()}'
          : '${appDocDir.path.split('Android')[0]}${Constants.epubPath}/${myDetailsBook!.productId}$currentUser${myDetailsBook!.typeFile!.toLowerCase()}';

      // Get encrypted file
      File file = File('$path.dbp');
      if (await file.exists()) {
        // print('Path if file exist: ' + myDetailsBook!.localPath.toString());
        // print('History if exist: ' + myDetailsBook!.bookHistory.toString());

        setState(() {
          isDownloadFile = true;
          localPathPermanent = file.path;
        });
      } else {
        setState(() {
          isDownloadFile = false;
        });
      }

      setState(() {
        isDownloadingFile = false;
      });

      // print("Type File: " + (myDetailsBook!.typeFile ?? ''));
    } else {
      // print("book not exist or user not purchase yet");
    }

    setState(() {
      isCompleteLoading = true;
    });
  }

  showAlertDialog(BuildContext context) async {
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
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xff2AAC95),
        ),
        child: const Text("Teruskan"),
        onPressed: () async {
          Navigator.of(context).pop();
          var connectivityResult = await (Connectivity().checkConnectivity());
          if (connectivityResult == ConnectivityResult.mobile ||
              connectivityResult == ConnectivityResult.wifi) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              width: 250,
              behavior: SnackBarBehavior.floating,
              content: Text('Dalam proses muat turun'),
              duration: Duration(seconds: 1),
            ));

            // if (myDetailsBook.typeFile.toLowerCase() == ".pdf") {
            //   PdfDownload();
            // }
            // if (myDetailsBook.typeFile.toLowerCase() == ".epub") {
            //   EpubDownload();
            // }
            downloadBook();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text('Memerlukan penggunaan internet'),
              duration: Duration(seconds: 3),
            ));
          }
        });

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: const Text("Memulihkan kembali produk?"),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: colors.bgPrimaryColor,
        elevation: 0,
        actions: [
          InkWell(
              onTap: () => showAlertDialog(context),
              child: const Icon(Icons.restore)),
          const SizedBox(
            width: 10,
          )
        ],
      ),
      body: isCompleteLoading
          ? ValueListenableBuilder(
              valueListenable: bookFromAPI.listenable(),
              builder: (context, Box<HiveBookAPI> todos, _) {
                return Stack(
                  children: [
                    isLoadingBook
                        ? LoadingAnimationWidget.discreteCircle(
                            color: DbpColor().jendelaGray,
                            secondRingColor: DbpColor().jendelaGreen,
                            thirdRingColor: DbpColor().jendelaOrange,
                            size: 50.0,
                          )
                        : const SizedBox(),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width:
                                    (MediaQuery.of(context).size.width / 1000) *
                                        350,
                                child: widget.bookIdentification
                                            .featuredMediaUrl ==
                                        null
                                    ? Image.asset(
                                        "assets/bookCover2/tiadakulitbuku.png",
                                        fit: BoxFit.fitWidth)
                                    : CachedNetworkImage(
                                        alignment: Alignment.bottomCenter,
                                        fit: BoxFit.fitWidth,
                                        imageUrl: widget.bookIdentification
                                                .featuredMediaUrl ??
                                            '',
                                        progressIndicatorBuilder:
                                            (context, url, downloadProgress) =>
                                                Container(
                                          // alignment: Alignment.center,
                                          child: LoadingAnimationWidget
                                              .discreteCircle(
                                            color: DbpColor().jendelaGray,
                                            secondRingColor:
                                                DbpColor().jendelaGreen,
                                            thirdRingColor:
                                                DbpColor().jendelaOrange,
                                            size: 50.0,
                                          ),
                                        ),
                                      ),
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              SizedBox(
                                width:
                                    (MediaQuery.of(context).size.width / 1000) *
                                        540,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width:
                                          (MediaQuery.of(context).size.width /
                                                  1000) *
                                              540,
                                      child: Text(
                                        widget.bookIdentification
                                                .productName ??
                                            '',
                                        // overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          1.9,
                                      child: bookOpenButton(),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 12, right: 12),
                          child: Column(
                            children: [
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Sinopsis Buku',
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: Text(
                                  widget.bookIdentification.descriptionParent ??
                                      '',
                                  textAlign: TextAlign.justify,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: maxTextLine,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  SizedBox(
                                    width: double.infinity,
                                    child: Text(
                                      widget.bookIdentification
                                              .descriptionParent ??
                                          '',
                                      textAlign: TextAlign.justify,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: maxTextLine,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      if (isOpenMaxTextLine == false) {
                                        setState(() {
                                          maxTextLine = 90;
                                          isOpenMaxTextLine = true;
                                        });
                                      } else {
                                        setState(() {
                                          maxTextLine = 3;
                                          isOpenMaxTextLine = false;
                                        });
                                      }
                                    },
                                    child: isOpenMaxTextLine
                                        ? const Padding(
                                            padding:  EdgeInsets.only(
                                                right: 15),
                                            child: Text(
                                              "Tutup",
                                              style: TextStyle(
                                                color: Colors.blue,
                                              ),
                                            ),
                                          )
                                        : widget.bookIdentification
                                                    .descriptionParent ==
                                                ""
                                            ? Container()
                                            : const Padding(
                                                padding:  EdgeInsets.only(
                                                    right: 15),
                                                child: Text("Lagi",
                                                    style: TextStyle(
                                                      color: Colors.blue,
                                                    ),),
                                              ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height:
                              widget.bookIdentification.descriptionParent == ""
                                  ? 0
                                  : 20,
                        ),
                      ],
                    ),
                  ],
                );
              },
            )
          : Center(
              child: LoadingAnimationWidget.discreteCircle(
                color: DbpColor().jendelaGray,
                secondRingColor: DbpColor().jendelaGreen,
                thirdRingColor: DbpColor().jendelaOrange,
                size: 50.0,
              ),
            ),
    );
  }

  Widget openPdfReader() {
    return PdfViewerPage(
      book: parentDetailsBook,
      pdfFile: localPathPermanent,
    );
    // PDFView(
    //   filePath: localPathPermanent,
    //   enableSwipe: true,
    //   swipeHorizontal: true,
    //   autoSpacing: false,
    //   pageFling: true,
    //   onRender: (_pages) {
    //     setState(() {
    //       pages = _pages ?? 1;
    //     });
    //   },
    //   onError: (error) {
    //     // print(error.toString());
    //   },
    //   onPageError: (page, error) {
    //     // print('$page: ${error.toString()}');
    //   },
    //   onViewCreated: (PDFViewController pdfViewController) {
    //     _controller.complete(pdfViewController);
    //   },
    //   onPageChanged: (int? page, int? total) {
    //     // print('page change: $page/$total');
    //   },
    // );
  }

  Future<void> downloadBook() async {
    setState(() {
      isDownloadingFile = true;
    });
    Permission permission = Permission.storage;
    // PermissionStatus permission = await PermissionHandler()
    //     .checkPermissionStatus(PermissionGroup.storage);

    if (await permission.isDenied) {
      bool isGranted = await Permission.storage.request().isGranted;
      if (isGranted) {
        await startDownload(
            context, myDetailsBook, currentUser, purchasedBook, myBook);
        getBookDetails();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Akses storan ditolak'),
          duration: Duration(seconds: 3),
        ));
      }
    } else {
      await startDownload(
          context, myDetailsBook, currentUser, purchasedBook, myBook);
      getBookDetails();
    }
  }

  Future<void> openEpubReader() async {
    // print('ini data history: ' + (myDetailsBook!.bookHistory ?? ''));
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    // var epubHistory = prefs
    //     .getString("${myDetailsBook!.product_id}USER${currentUserID ?? ''}");

    // Map<dynamic, dynamic> myyy = Map();

    VocsyEpub.setConfig(
        themeColor: Theme.of(context).primaryColor,
        identifier: "iosBook",
        scrollDirection: EpubScrollDirection.ALLDIRECTIONS,
        allowSharing: false,
        enableTts: false);

    // Decrypt file
    File decryptFile =
        await EncryptFile.decryptFile(File(localPathPermanent));

    if (!decryptFile.existsSync()) {
      // Notification
      return;
    }

    // if (epubHistory != null) {
    //   // print('ni history shared: ' + epubHistory);

    //   setState(() {
    //     myyy = json.decode(epubHistory);
    //   });
    //   // print('masuk if history');
    //   EpubViewer.open(decryptFile.path,
    //       lastLocation: EpubLocator.fromJson(Map<String, dynamic>.from(myyy)));
    // } else {
    //   try {
    VocsyEpub.open(decryptFile.path);
    //   } catch (e) {}
    // }

    VocsyEpub.locatorStream.listen((locator) {
      // print('LOCATOR: ${EpubLocator.fromJson(jsonDecode(locator))}');
    });
    VocsyEpub.locatorStream.listen((event) async {
      // Get locator here
      //Map json = convert.jsonDecode(event);
      // print('data event');
      // print(event.toString());
      // print('data here');
      // print(json.toString());
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("${myDetailsBook!.productId}USER${currentUserID ?? ''}",
          event.toString());
    }, onDone: () {
      // print(decryptFile.path);
      // print('onDone');
    });
  }

  Future<void> openEpubReaderForIOS() async {
    // print('ini data history: ' + (myDetailsBook!.bookHistory ?? ''));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var epubHistory = prefs.getString(
        "${myDetailsBook!.productId}USER${currentUserID ?? ''}");

    //Map<dynamic, dynamic?> myyy = Map();

    // EpubViewer.setConfig(
    //     themeColor: Theme.of(context).primaryColor,
    //     identifier: "iosBook",
    //     scrollDirection: EpubScrollDirection.ALLDIRECTIONS,
    //     allowSharing: false,
    //     enableTts: false);

    // Decrypt file
    File decryptFile = await EncryptFile.decryptFile(File(localPathPermanent));

    if (!decryptFile.existsSync()) {
      // Notification
      return;
    }
    Navigator.of(context).pushNamed('/EpubReader',
        arguments: Map<String, dynamic>.from({
          'file': decryptFile,
          'epubCfi': epubHistory,
          'epubTextSize': 12.0,
          'productId': myDetailsBook!.productId ?? 0,
          'userId': int.parse(currentUserID ?? '0')
        }));
    // if (epubHistory != null) {
    //   // print('ni history shared: ' + epubHistory);

    //   setState(() {
    //     myyy = json.decode(epubHistory);
    //   });
    //   // print('masuk if history');
    //   // EpubViewer.open(decryptFile.path,
    //   //     lastLocation: EpubLocator.fromJson(Map<String, dynamic>.from(myyy)));

    // } else {
    //   try {
    //     EpubViewer.open(decryptFile.path);
    //   } catch (e) {}
    // }

    // EpubViewer.locatorStream.listen((locator) {
    //   // print('LOCATOR: ${EpubLocator.fromJson(jsonDecode(locator))}');
    // });
    // EpubViewer.locatorStream.listen((event) async {
    //   // Get locator here
    //   Map json = jsonDecode(event);
    //   // print('data event');
    //   // print(event.toString());
    //   // print('data here');
    //   // print(json.toString());
    //   SharedPreferences prefs = await SharedPreferences.getInstance();
    //   prefs.setString(
    //       myDetailsBook!.product_id.toString() + "USER" + (currentUserID ?? ''),
    //       event.toString());
    // }, onDone: () {
    //   // print(decryptFile.path);
    //   // print('onDone');
    // });
  }

  Widget bookOpenButton() {
    String fileExt = myDetailsBook!.typeFile!.toLowerCase();
    List<Widget> listOfWidget = [];
    if ('.epub' == fileExt.toLowerCase()) {
      listOfWidget.add(
        isDownloadingFile
            ? LoadingAnimationWidget.discreteCircle(
                color: DbpColor().jendelaGray,
                secondRingColor: DbpColor().jendelaGreen,
                thirdRingColor: DbpColor().jendelaOrange,
                size: 50.0,
              )
            : isDownloadFile
                ? SizedBox(
                    width: 100,
                    child: OutlinedButton(
                      child: const Row(
                        children: [
                          Text('Baca'),
                          Icon(Icons.book_rounded, color: Colors.white70),
                        ],
                      ),
                      onPressed: () async {
                        setState(() {
                          isLoadingBook = true;
                        });
                        if (Platform.isIOS) {
                          await openEpubReader();
                          // OpenEpubReaderForIOS();
                        } else {
                          await openEpubReader();
                        }
                        setState(() {
                          isLoadingBook = false;
                        });
                      },
                    ),
                  )
                : SizedBox(
                    width: 150,
                    child: OutlinedButton(
                      child: const Row(
                        children: [
                          Text('Muat Turun'),
                          Icon(Icons.download, color: Colors.white70),
                        ],
                      ),
                      onPressed: () async {
                        var connectivityResult =
                            await (Connectivity().checkConnectivity());
                        if (connectivityResult == ConnectivityResult.mobile ||
                            connectivityResult == ConnectivityResult.wifi) {
                          downloadBook();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            behavior: SnackBarBehavior.floating,
                            content: Text('Memerlukan penggunaan internet'),
                            duration: Duration(seconds: 3),
                          ));
                        }
                      },
                    ),
                  ),
      );
    } else if ('.pdf' == fileExt.toLowerCase()) {
      listOfWidget.add(
        isDownloadingFile
            ? LoadingAnimationWidget.discreteCircle(
                color: DbpColor().jendelaGray,
                secondRingColor: DbpColor().jendelaGreen,
                thirdRingColor: DbpColor().jendelaOrange,
                size: 50.0,
              )
            : isDownloadFile
                ? SizedBox(
                    width: 100,
                    child: OutlinedButton(
                      child: const Row(
                        children: [
                          Text('Baca'),
                          Icon(Icons.book_rounded, color: Colors.white70),
                        ],
                      ),
                      onPressed: () async {
                        // decrypt file
                        File file = File(localPathPermanent);
                        setState(() {
                          isLoadingBook = true;
                        });
                        if (await file.exists()) {
                          // Decrypt file
                          File decryptedFile =
                              await EncryptFile.decryptFile(file);
                          Navigator.of(context)
                              .pushNamed('/PdfViewer',
                                  arguments: decryptedFile.path)
                              .then((value) {
                            // if (decryptedFile.existsSync()) {
                            //   decryptedFile.deleteSync();
                            // }
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            behavior: SnackBarBehavior.floating,
                            content: Text('Error'),
                            duration: Duration(seconds: 3),
                          ));
                        }
                        setState(() {
                          isLoadingBook = false;
                        });
                        // OpenPdfReader();
                        return;
                      },
                    ),
                  )
                : SizedBox(
                    width: 150,
                    child: OutlinedButton(
                      child: const Row(
                        children: [
                          Text('Muat Turun'),
                          Icon(Icons.download, color: Colors.white70),
                        ],
                      ),
                      onPressed: () async {
                        var connectivityResult =
                            await (Connectivity().checkConnectivity());
                        if (connectivityResult == ConnectivityResult.mobile ||
                            connectivityResult == ConnectivityResult.wifi) {
                          downloadBook();
                        } else {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            behavior: SnackBarBehavior.floating,
                            content: Text('Memerlukan penggunaan internet'),
                            duration: Duration(seconds: 3),
                          ));
                        }
                      },
                    ),
                  ),
      );
    } else if (".mp3" == fileExt.toLowerCase()) {
      // Audio

      listOfWidget.add(
        isDownloadingFile
            ? LoadingAnimationWidget.discreteCircle(
                color: DbpColor().jendelaGray,
                secondRingColor: DbpColor().jendelaGreen,
                thirdRingColor: DbpColor().jendelaOrange,
                size: 50.0,
              )
            : isDownloadFile
                ? SizedBox(
                    width: 150,
                    child: OutlinedButton(
                      child: const Row(
                        children: [
                          Text('Buka'),
                          Icon(Icons.play_arrow, color: Colors.white70),
                        ],
                      ),
                      onPressed: () async {
                        File file = File(localPathPermanent);
                        File? decryptedFile;
                        if (file.existsSync()) {
                          // Decrypt file
                          decryptedFile = await EncryptFile.decryptFile(file);
                        }
                        Navigator.of(context)
                            .pushNamed('/AudioPlayer', arguments: {
                          'title': widget.bookIdentification.productName,
                          'path': decryptedFile!.path,
                          'coverImage':
                              widget.bookIdentification.featuredMediaUrl
                        }).then((value) {
                          // if (decryptedFile!.existsSync()) {
                          //   decryptedFile.deleteSync();
                          // }
                        });
                      },
                    ),
                  )
                : SizedBox(
                    width: 150,
                    child: OutlinedButton(
                      child: const Row(
                        children: [
                          Text('Muat Turun'),
                          Icon(Icons.download, color: Colors.white70),
                        ],
                      ),
                      onPressed: () async {
                        setState(() {
                          isLoadingBook = true;
                        });
                        var connectivityResult =
                            await (Connectivity().checkConnectivity());
                        if (connectivityResult == ConnectivityResult.mobile ||
                            connectivityResult == ConnectivityResult.wifi) {
                          downloadBook();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              behavior: SnackBarBehavior.floating,
                              content: Text('Memerlukan penggunaan internet'),
                              duration: Duration(seconds: 3),
                            ),
                          );
                        }
                        setState(() {
                          isLoadingBook = false;
                        });
                      },
                    ),
                  ),
      );
    }
    return SizedBox(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: listOfWidget,
    ));
  }

  Widget openAudioButton() {
    return InkWell(
      onTap: () async {
        File file = File(localPathPermanent);
        File? decryptedFile;
        if (file.existsSync()) {
          // Decrypt file
          decryptedFile = await EncryptFile.decryptFile(file);
        }
        Navigator.of(context).pushNamed('/AudioPlayer', arguments: {
          'title': widget.bookIdentification.productName,
          'path': decryptedFile!.path,
          'coverImage': widget.bookIdentification.featuredMediaUrl
        }).then((value) {
          // if (decryptedFile!.existsSync()) {
          //   decryptedFile.deleteSync();
          // }
        });
      },
      child: audioButton(),
    );
  }
}
