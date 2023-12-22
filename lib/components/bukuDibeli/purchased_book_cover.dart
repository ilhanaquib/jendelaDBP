import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:jendela_dbp/components/bookReader/new_pdf_viewer.dart';
import 'package:jendela_dbp/components/bookReader/pdf_viewer.dart';

import 'package:jendela_dbp/components/bukuDibeli/book_information.dart';
import 'package:jendela_dbp/components/bukuDibeli/download_button.dart';
import 'package:jendela_dbp/controllers/constants.dart';
import 'package:jendela_dbp/controllers/dbp_color.dart';
import 'package:jendela_dbp/controllers/encrypt_file.dart';
import 'package:jendela_dbp/controllers/global_var.dart';
import 'package:jendela_dbp/hive/api/api_book_model.dart';
import 'package:jendela_dbp/hive/models/hive_book_model.dart';
import 'package:jendela_dbp/hive/models/hive_purchased_book_model.dart';
import 'package:jendela_dbp/model/category_model.dart';
import 'package:jendela_dbp/stateManagement/blocs/poduct_bloc.dart';
import 'package:jendela_dbp/view/pages/audiobooks/audiobooks.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vocsy_epub_viewer/epub_viewer.dart';

class BookPurchasedCoverCard extends StatefulWidget {
  const BookPurchasedCoverCard(
    this.context, {
    Key? key,
    required this.purchasedBook,
  }) : super(key: key);
  final HivePurchasedBook purchasedBook;
  final BuildContext context;
  @override
  State<BookPurchasedCoverCard> createState() => _BookPurchasedCoverCard();
}

class _BookPurchasedCoverCard extends State<BookPurchasedCoverCard> {
  ProductBloc productBloc = ProductBloc();
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
        .where(
            (key) => bookFromAPI.get(key)!.id == widget.purchasedBook.parentID)
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
            purchasedBook.get(key)!.productId == widget.purchasedBook.productId)
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

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  BookInformation(bookIdentification: widget.purchasedBook),
            ),
          );
        },
        child: widget.purchasedBook.featuredMediaUrl == null
            ? Container(
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.black)),
                child: Image.asset('assets/images/tiadakulitbuku.png'))
            : Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
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
                      width: 120,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          alignment: Alignment.bottomCenter,
                          fit: BoxFit
                              .cover, // Use BoxFit.cover for maintaining aspect ratio within rounded corners
                          imageUrl: widget.purchasedBook.featuredMediaUrl ?? '',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 150,
                            child: Text(
                              widget.purchasedBook.productName ?? '',
                              maxLines: 5,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          isLoadingBook
                              ? LoadingAnimationWidget.discreteCircle(
                                  color: DbpColor().jendelaGray,
                                  secondRingColor: DbpColor().jendelaGreen,
                                  thirdRingColor: DbpColor().jendelaOrange,
                                  size: 50.0,
                                )
                              : bookOpenButton(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
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
                      side: MaterialStateProperty.all<BorderSide>(
                        BorderSide(color: DbpColor().jendelaGreen, width: 2),
                      ), // Green border
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
                        PersistentNavBarNavigator.pushNewScreen(
                          context,
                          withNavBar: false,
                          screen: 
                          NewPdfViewerPage(
                            pdfPath: decryptedFile,
                            bookName: widget.purchasedBook.productName!,
                          ),
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
                : OutlinedButton(
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
                      if (!context.mounted) return;
                      PersistentNavBarNavigator.pushNewScreen(
                        context,
                        withNavBar: false,
                        screen: Audiobooks(
                          book: widget.purchasedBook,
                          audioFile: decryptedFile!.path,
                        ),
                      );

                      // Navigator.of(context)
                      //     .pushNamed('/AudioPlayer', arguments: {
                      //   'title': widget.purchasedBook.productName,
                      //   'path': decryptedFile!.path,
                      //   'coverImage': widget.purchasedBook.featuredMediaUrl
                      // }).then((value) {
                      //   // if (decryptedFile!.existsSync()) {
                      //   //   decryptedFile.deleteSync();
                      //   // }
                      // });
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
                        if (!context.mounted) return;
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
}
