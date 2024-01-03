// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:jendela_dbp/components/audiobook/audios_inside_shelf.dart';
import 'package:jendela_dbp/components/cart/cart_icon.dart';
import 'package:jendela_dbp/components/ujana/home_drawer.dart';
import 'package:jendela_dbp/stateManagement/cubits/liked_status_cubit.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';

import 'package:jendela_dbp/controllers/get_books_from_api.dart';
import 'package:jendela_dbp/controllers/global_var.dart';
import 'package:jendela_dbp/hive/models/hive_book_model.dart';
import 'package:jendela_dbp/controllers/dbp_color.dart';

class AudiobooksHome extends StatefulWidget {
  const AudiobooksHome({super.key});

  @override
  State<AudiobooksHome> createState() => _AudiobooksHomeState();
}

class _AudiobooksHomeState extends State<AudiobooksHome>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  //-----custom refresh indicator----

  static const _circleSize = 70.0;

  double _progress = 0.0;

  late AnimationController _controller;

  //-----custom refresh indicator----

  Box<HiveBookAPI> apiBook = Hive.box<HiveBookAPI>(GlobalVar.apiBook);
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
  List allKategoriBooks = [];
  bool isLoading = true;

  dynamic allProduct;
  

  @override
  void initState() {
    super.initState();
    allProduct = getAllProduct();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
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
    kategori1Books = apiBook.keys
        .cast<int>()
        .where(
            (key) => apiBook.get(key)!.productCategory == GlobalVar.kategori1)
        .toList();
    kategori2Books = apiBook.keys
        .cast<int>()
        .where(
            (key) => apiBook.get(key)!.productCategory == GlobalVar.kategori2)
        .toList();

    kategori3Books = apiBook.keys
        .cast<int>()
        .where(
            (key) => apiBook.get(key)!.productCategory == GlobalVar.kategori3)
        .toList();
    kategori4Books = apiBook.keys
        .cast<int>()
        .where(
            (key) => apiBook.get(key)!.productCategory == GlobalVar.kategori4)
        .toList();
    kategori5Books = apiBook.keys
        .cast<int>()
        .where(
            (key) => apiBook.get(key)!.productCategory == GlobalVar.kategori5)
        .toList();
    kategori6Books = apiBook.keys
        .cast<int>()
        .where(
            (key) => apiBook.get(key)!.productCategory == GlobalVar.kategori6)
        .toList();
    kategori7Books = apiBook.keys
        .cast<int>()
        .where(
            (key) => apiBook.get(key)!.productCategory == GlobalVar.kategori7)
        .toList();
    kategori8Books = apiBook.keys
        .cast<int>()
        .where(
            (key) => apiBook.get(key)!.productCategory == GlobalVar.kategori8)
        .toList();
    kategori9Books = apiBook.keys
        .cast<int>()
        .where(
            (key) => apiBook.get(key)!.productCategory == GlobalVar.kategori9)
        .toList();
    kategori10Books = apiBook.keys
        .cast<int>()
        .where(
            (key) => apiBook.get(key)!.productCategory == GlobalVar.kategori10)
        .toList();
    kategori11Books = apiBook.keys
        .cast<int>()
        .where(
            (key) => apiBook.get(key)!.productCategory == GlobalVar.kategori11)
        .toList();
    kategori12Books = apiBook.keys
        .cast<int>()
        .where(
            (key) => apiBook.get(key)!.productCategory == GlobalVar.kategori12)
        .toList();
    kategori13Books = apiBook.keys
        .cast<int>()
        .where(
            (key) => apiBook.get(key)!.productCategory == GlobalVar.kategori13)
        .toList();
    kategori14Books = apiBook.keys
        .cast<int>()
        .where(
            (key) => apiBook.get(key)!.productCategory == GlobalVar.kategori14)
        .toList();
    kategori15Books = apiBook.keys
        .cast<int>()
        .where(
            (key) => apiBook.get(key)!.productCategory == GlobalVar.kategori15)
        .toList();
    allKategoriBooks = [
      ...kategori1Books,
      ...kategori2Books,
      ...kategori3Books,
      ...kategori4Books,
      ...kategori5Books,
      ...kategori6Books,
      ...kategori7Books,
      ...kategori8Books,
      ...kategori9Books,
      ...kategori10Books,
      ...kategori11Books,
      ...kategori12Books,
      ...kategori13Books,
      ...kategori14Books,
      ...kategori15Books
    ];
  }

  // void _updateAppBar() {
  //   setState(() {
  //     // Rebuild the app bar to reflect the changes
  //   });
  // }

  Future<void> _handleRefresh() async {
    setState(() {
      isLoading = true;
    });
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      try {
        final result = await InternetAddress.lookup('google.com')
            .timeout(const Duration(seconds: 3));
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          var token = prefs.getString('token');
          //bookAPIBox.clear();
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
      } catch (exception) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(exception.toString()),
          duration: const Duration(seconds: 3),
        ));
      }
    } else {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text('Internet access required'),
        duration: Duration(seconds: 3),
      ));
    }

    getKategoriFromAPI();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Map<int, List<int>> categoryToBookMap = {
    //   1: kategori1Books,
    //   2: kategori2Books,
    //   3: kategori3Books,
    //   4: kategori4Books,
    //   5: kategori5Books,
    //   6: kategori6Books,
    //   7: kategori7Books,
    //   8: kategori8Books,
    //   9: kategori9Books,
    //   10: kategori10Books,
    //   11: kategori11Books,
    //   12: kategori12Books,
    //   13: kategori13Books,
    //   14: kategori14Books,
    //   15: kategori15Books,
    // };
    return BlocProvider(
      create: (context) => LikedStatusCubit(),
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: const Text('Buku Audio'),
          //  const Column(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [
          //     Text('Let\'s read something'),
          //     Text(
          //       'We collected and distilled the knowledge',
          //       style: TextStyle(
          //         fontSize: 14,
          //         color: Color.fromARGB(255, 123, 123, 123),
          //       ),
          //     )
          //   ],
          // ),
          leading: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: GestureDetector(
                onTap: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
                child: Image.asset('assets/images/logo.png')
                // CircleAvatar(
                //   backgroundImage:
                //       context.watch<ImageBloc>().selectedImageProvider ??
                //           const AssetImage('assets/images/logo.png'),
                // ),
                ),
          ),
          actions: const [
            Padding(
              padding: EdgeInsets.only(right: 10),
              child: CartIcon(),
            ),
          ],
        ),
        drawer: const HomeDrawer(),
        body: CustomScrollView(
          slivers: [
            const SliverAppBar(
              floating: true,
              snap: true,
              elevation: 0.0,
              toolbarHeight: 0.01,
            ),
            SliverFillRemaining(
              child: CustomRefreshIndicator(
                builder: (context, child, controller) => LayoutBuilder(
                  builder: (context, constraints) {
                    _progress = _controller.value;
                    final widgetWidth = constraints.maxWidth;
                    final widgetHeight = constraints.maxHeight;
                    final letterTopHeight = (widgetHeight / 2) + 50;
                    final topValue = (widgetHeight -
                            (letterTopHeight * controller.value / 1))
                        .clamp(letterTopHeight - 100, double.infinity);

                    final bottomValue =
                        (widgetHeight - (widgetHeight * controller.value / 1))
                            .clamp(0.0, double.infinity);

                    final opacity = (controller.value - 1).clamp(0, 0.5) / 0.5;

                    return Stack(
                      children: <Widget>[
                        Transform.scale(
                          scale: 1 - 0.1 * controller.value.clamp(0.0, 1.0),
                          child: child,
                        ),
                        Positioned(
                          bottom:
                              bottomValue,
                          child: Container(
                            width: widgetWidth,
                            height: widgetHeight,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Positioned(
                          top: topValue,
                          child: CustomPaint(
                            painter: BookPainter(
                              strokeColor: Colors.white,
                              progress: _progress,
                            ),
                            child: SizedBox(
                              width:
                                  widgetWidth,
                              height: letterTopHeight,
                            ),
                          ),
                        ),
                        if (controller.value >= 1)
                          Container(
                            padding: const EdgeInsets.only(),
                            child: Transform.scale(
                              scale: controller.value,
                              child: Opacity(
                                opacity: controller.isLoading ? 1 : opacity,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    width: _circleSize,
                                    height: _circleSize,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                    ),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: <Widget>[
                                        SizedBox(
                                          height: double.infinity,
                                          width: double.infinity,
                                          child: Padding(
                                            padding: const EdgeInsets.only(),
                                            child: Center(
                                              child: LoadingAnimationWidget
                                                  .discreteCircle(
                                                color: DbpColor().jendelaGray,
                                                secondRingColor:
                                                    DbpColor().jendelaGreen,
                                                thirdRingColor:
                                                    DbpColor().jendelaOrange,
                                                size: 70.0,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Image.asset(
                                          'assets/images/logonobg.png',
                                          height: 50,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                      ],
                    );
                  },
                ),
                onRefresh: _handleRefresh,
                child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: AudiosInsideShelf(
                        dataBooks: allKategoriBooks, bookBox: apiBook)),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class BookPainter extends CustomPainter {
  final Color strokeColor;
  final double progress;

  BookPainter({
    required this.strokeColor,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.transparent
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    const double maxAngle = pi / 6; 
    final double angle = maxAngle * progress;
    final double offsetX = 20.0 * progress;

    final Path path = Path()
      ..moveTo(offsetX, size.height)
      ..lineTo(offsetX, 0)
      ..quadraticBezierTo(size.width * 0.5, -40, size.width - offsetX, 0)
      ..lineTo(size.width - offsetX, size.height)
      ..close();

    final Matrix4 matrix = Matrix4.identity()
      ..setEntry(3, 2, 0.001)
      ..rotateX(angle);
    path.transform(matrix.storage);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
