// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jendela_dbp/components/berita/berita_card.dart';
import 'package:jendela_dbp/components/berita/berita_not_found_card.dart';
import 'package:jendela_dbp/controllers/global_var.dart';
import 'package:jendela_dbp/hive/models/hive_berita_model.dart';
import 'package:jendela_dbp/stateManagement/blocs/berita_bloc.dart';
import 'package:jendela_dbp/stateManagement/events/berita_event.dart';
import 'package:jendela_dbp/stateManagement/states/berita_state.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:jendela_dbp/components/cart/cart_icon.dart';
import 'package:jendela_dbp/components/posts/error_card.dart';
import 'package:jendela_dbp/components/ujana/home_drawer.dart';
import 'package:jendela_dbp/controllers/dbp_color.dart';
import 'package:jendela_dbp/controllers/screen_size.dart';
import 'package:jendela_dbp/stateManagement/cubits/connection_cubit.dart';

class CategorizedBerita extends StatefulWidget {
  CategorizedBerita({super.key, required this.i});
  int i;
  @override
  State<CategorizedBerita> createState() => _CategorizedBeritaState();
}

class _CategorizedBeritaState extends State<CategorizedBerita> {
  BeritaBloc beritaBloc = BeritaBloc();
  ConnectionCubit connectionCubit = ConnectionCubit();
  final int _perPage = 25;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  Map<int, String> categoryName = {
    1: 'Dewan Bahasa',
    2: 'Dewan Sastera',
    3: 'Dewan Masyarakat',
    4: 'Dewan Budaya',
    5: 'Dewan Ekonomi',
    6: 'Dewan Kosmik',
    7: 'Dewan Tamadun Islam',
    8: 'Tunas Cipta',
  };

  @override
  void initState() {
    beritaBloc.add(
      BeritaFetch(perPage: _perPage),
    );

    super.initState();
  }

  @override
  void dispose() {
    beritaBloc.close();
    super.dispose();
  }

  bool isFetching = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => beritaBloc,
      child: BlocConsumer<BeritaBloc, BeritaState>(
        bloc: beritaBloc,
        listener: (context, state) {},
        builder: (BuildContext context, BeritaState state) {
          return ScaffoldMessenger(
            key: scaffoldMessengerKey,
            child: Scaffold(
              key: _scaffoldKey,
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Colors.white,
                centerTitle: true,
                title: Text(categoryName[widget.i]!),
                leading: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: GestureDetector(
                      onTap: () {
                        //_scaffoldKey.currentState?.openDrawer();
                        Navigator.pop(context);
                      },
                      child: const Icon(Icons.arrow_back)
                      //Image.asset('assets/images/logo.png')
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
              body: NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  if (!isFetching &&
                      scrollInfo.metrics.pixels >=
                          scrollInfo.metrics.maxScrollExtent - 200.0 &&
                      scrollInfo is ScrollUpdateNotification) {
                    setState(() {
                      isFetching = true;
                    });

                    scaffoldMessengerKey.currentState!.showSnackBar(
                      const SnackBar(
                        content: Text('Sedang mendapatkan berita...'),
                        duration: Duration(
                            days: 1),
                      ),
                    );

                    Future.delayed(const Duration(seconds: 1), () {
                      beritaBloc.add(
                        BeritaFetchMore(perPage: 25),
                      );

                      setState(() {
                        isFetching = false;
                      });

                      scaffoldMessengerKey.currentState!.hideCurrentSnackBar();
                    });
                  }
                  return true;
                },
                child: CustomScrollView(
                  slivers: [
                    const SliverAppBar(
                      floating: true,
                      snap: true,
                      elevation: 0.0,
                      toolbarHeight: 0.01,
                    ),
                    SliverFillRemaining(
                      child: RefreshIndicator(
                          onRefresh: () async {
                            connectionCubit.checkConnection(context);
                            await Future.delayed(
                                const Duration(milliseconds: 100));
                            beritaBloc.add(BeritaFetch());
                          },
                          child: SingleChildScrollView(
                              child: _beritaList(context),),),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _beritaList(BuildContext context) {
    double childAspectRatio;
    if (ResponsiveLayout.isDesktop(context)) {
      childAspectRatio = 1;
    } else if (ResponsiveLayout.isTablet(context)) {
      childAspectRatio = 0.9;
    } else {
      childAspectRatio = 0.62;
    }
    int crossAxisCount;
    if (ResponsiveLayout.isDesktop(context)) {
      crossAxisCount = 3;
    } else if (ResponsiveLayout.isTablet(context)) {
      crossAxisCount = 2;
    } else {
      crossAxisCount = 2;
    }
    Map<int, dynamic> categoryId = {
      1: GlobalVar.dewanBahasaId,
      2: GlobalVar.dewanSasteraId,
      3: GlobalVar.dewanMasyarakatId,
      4: GlobalVar.dewanBudayaId,
      5: GlobalVar.dewanEkonomiId,
      6: GlobalVar.dewanKosmikiId,
      7: GlobalVar.dewanTamadunIslamId,
      8: GlobalVar.tunasCiptaId,
    };
    return Padding(
      padding: const EdgeInsets.only(top: 12, left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 8, bottom: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Berita',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ],
            ),
          ),
          SizedBox(
            child: BlocBuilder<BeritaBloc, BeritaState>(
              bloc: beritaBloc,
              builder: (context, data) {
                if (data is BeritaLoaded) {
                  List<Berita> berita = data.listOfBerita
                          ?.where((e) => e.blogId == categoryId[widget.i])
                          .toList() ??
                      [];
                  if (berita.isEmpty) {
                    return const SizedBox(
                      height: 300,
                      child: Center(
                        child: BeritaNotFoundCard(),
                      ),
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.only(left: 0, right: 0),
                    child: GridView(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          mainAxisSpacing: 0,
                          crossAxisSpacing: 0,
                          childAspectRatio: childAspectRatio),
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      children: List.generate(
                        berita.length,
                        (index) => BeritaCard(
                          berita: berita[index],
                        ),
                      ),
                    ),
                  );
                }
                if (data is BeritaError) {
                  return const ErrorCard(message: 'error');
                }
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 300.0),
                    child: LoadingAnimationWidget.discreteCircle(
                      color: DbpColor().jendelaGray,
                      secondRingColor: DbpColor().jendelaGreen,
                      thirdRingColor: DbpColor().jendelaOrange,
                      size: 70.0,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
