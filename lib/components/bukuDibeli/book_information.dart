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
import 'package:jendela_dbp/hive/models/hive_book_model.dart';
import 'package:jendela_dbp/hive/models/hive_purchased_book_model.dart';
import 'package:jendela_dbp/model/category_model.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:dio/dio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vocsy_epub_viewer/epub_viewer.dart';
import 'package:jendela_dbp/view/pages/audiobooks/audiobooks.dart';

// const String localBook = "LocalBook";

// ignore: must_be_immutable
class BookInformation extends StatefulWidget {
  HivePurchasedBook bookIdentification;

  BookInformation({super.key, required this.bookIdentification});
  @override
  State <BookInformation> createState() => _BookInformationState();
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
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text('Expired session. Please login again'),
        duration: Duration(seconds: 3),
      ));

      Future.delayed(const Duration(seconds: 2)).then((value) =>
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/Logout', (Route<dynamic> route) => false));
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
            if (!context.mounted) return;
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
            if (!context.mounted) return;
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
        centerTitle: true,
        title: const Text('Informasi Buku'),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: DbpColor().jendelaGreen,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: DbpColor().jendelaGreen,
                                  ),
                                ),
                                width: 150,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: CachedNetworkImage(
                                    alignment: Alignment.bottomCenter,
                                    fit: BoxFit
                                        .cover, // Use BoxFit.cover for maintaining aspect ratio within rounded corners
                                    imageUrl: widget.bookIdentification
                                            .featuredMediaUrl ??
                                        '',
                                  ),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 150,
                                    child: Text(
                                      widget.bookIdentification.productName ??
                                          '',
                                      //overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  bookOpenButton(),
                                ],
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Sinopsis Buku',
                                    style: TextStyle(
                                        color: DbpColor().jendelaOrange,
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
                                      'Tiada maklumat untuk buku ini',
                                  textAlign: TextAlign.justify,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
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
        if (!context.mounted) return;
        await startDownload(
            context, myDetailsBook, currentUser, purchasedBook, myBook);
        getBookDetails();
      } else {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Akses storan ditolak'),
          duration: Duration(seconds: 3),
        ));
      }
    } else {
      if (!context.mounted) return;
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
        themeColor: DbpColor().jendelaGreen,
        identifier: "iosBook",
        scrollDirection: EpubScrollDirection.HORIZONTAL,
        allowSharing: false,
        enableTts: false);

    // Decrypt file
    File decryptFile = await EncryptFile.decryptFile(File(localPathPermanent));

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
    var epubHistory = prefs
        .getString("${myDetailsBook!.productId}USER${currentUserID ?? ''}");

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
    if (!context.mounted) return;
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
                ? OutlinedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          DbpColor().jendelaGreen), // Green background
                      overlayColor: MaterialStateProperty.all<Color>(
                          Colors.transparent), // No overlay color
                      side: MaterialStateProperty.all<BorderSide>(BorderSide(
                          color: DbpColor().jendelaGreen,
                          width: 2)), // Green border
                    ),
                    child: const Row(
                      children: [
                        Text(
                          'Baca',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        Icon(Icons.book_rounded, color: Colors.white),
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
                  )
                : OutlinedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          DbpColor().jendelaGreen), // Green background
                      overlayColor: MaterialStateProperty.all<Color>(
                          Colors.transparent), // No overlay color
                      side: MaterialStateProperty.all<BorderSide>(BorderSide(
                          color: DbpColor().jendelaGreen,
                          width: 2)), // Green border
                    ),
                    child: const Row(
                      children: [
                        Text(
                          'Muat Turun',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        Icon(Icons.download, color: Colors.white),
                      ],
                    ),
                    onPressed: () async {
                      var connectivityResult =
                          await (Connectivity().checkConnectivity());
                      if (connectivityResult == ConnectivityResult.mobile ||
                          connectivityResult == ConnectivityResult.wifi) {
                        downloadBook();
                      } else {
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          behavior: SnackBarBehavior.floating,
                          content: Text('Memerlukan penggunaan internet'),
                          duration: Duration(seconds: 3),
                        ));
                      }
                    },
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
                ? OutlinedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          DbpColor().jendelaGreen), // Green background
                      overlayColor: MaterialStateProperty.all<Color>(
                          Colors.transparent), // No overlay color
                      side: MaterialStateProperty.all<BorderSide>(BorderSide(
                          color: DbpColor().jendelaGreen,
                          width: 2)), // Green border
                    ),
                    child: const Row(
                      children: [
                        Text(
                          'Baca',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        Icon(Icons.book_rounded, color: Colors.white),
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
                        if (!context.mounted) return;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PdfViewerPage(
                                    pdfPath: decryptedFile,
                                    bookName:
                                        widget.bookIdentification.productName!,
                                  )),
                        );
                        // Navigator.of(context)
                        //     .push()
                        //     .then((value) {
                        //   // if (decryptedFile.existsSync()) {
                        //   //   decryptedFile.deleteSync();
                        //   // }
                        // });
                      } else {
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
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
                  )
                : SizedBox(
                    width: 150,
                    child: OutlinedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            DbpColor().jendelaGreen), // Green background
                        overlayColor: MaterialStateProperty.all<Color>(
                            Colors.transparent), // No overlay color
                        side: MaterialStateProperty.all<BorderSide>(
                          BorderSide(color: DbpColor().jendelaGreen, width: 2),
                        ), // Green border
                      ),
                      child: const Row(
                        children: [
                          Text(
                            'Muat Turun',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          Icon(Icons.download, color: Colors.white),
                        ],
                      ),
                      onPressed: () async {
                        var connectivityResult =
                            await (Connectivity().checkConnectivity());
                        if (connectivityResult == ConnectivityResult.mobile ||
                            connectivityResult == ConnectivityResult.wifi) {
                          downloadBook();
                        } else {
                          if(!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              behavior: SnackBarBehavior.floating,
                              content: Text('Memerlukan penggunaan internet'),
                              duration: Duration(seconds: 3),
                            ),
                          );
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
                ? OutlinedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          DbpColor().jendelaGreen), // Green background
                      overlayColor: MaterialStateProperty.all<Color>(
                          Colors.transparent), // No overlay color
                      side: MaterialStateProperty.all<BorderSide>(BorderSide(
                          color: DbpColor().jendelaGreen,
                          width: 2)), // Green border
                    ),
                    child: const Row(
                      children: [
                        Text(
                          'Buka',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        Icon(Icons.play_arrow, color: Colors.white),
                      ],
                    ),
                    onPressed: () async {
                      File file = File(localPathPermanent);
                      File? decryptedFile;
                      if (file.existsSync()) {
                        // Decrypt file
                        decryptedFile = await EncryptFile.decryptFile(file);
                      }
                      if(!context.mounted) return;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Audiobooks(
                                  book: widget.bookIdentification,
                                  audioFile: decryptedFile!.path,
                                )),
                      );
                    },
                  )
                : OutlinedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          DbpColor().jendelaGreen), // Green background
                      overlayColor: MaterialStateProperty.all<Color>(
                          Colors.transparent), // No overlay color
                      side: MaterialStateProperty.all<BorderSide>(BorderSide(
                          color: DbpColor().jendelaGreen,
                          width: 2)), // Green border
                    ),
                    child: const Row(
                      children: [
                        Text(
                          'Muat Turun',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        Icon(Icons.download, color: Colors.white),
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
                        if(!context.mounted) return;
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
        if(!context.mounted) return;
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
