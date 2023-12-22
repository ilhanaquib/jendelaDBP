import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jendela_dbp/components/article/article_not_found.dart';
import 'package:jendela_dbp/components/berita/berita_card.dart';
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

class AllBerita extends StatefulWidget {
  const AllBerita({super.key});

  @override
  State<AllBerita> createState() => _AllBeritaState();
}

class _AllBeritaState extends State<AllBerita> {
  BeritaBloc beritaBloc = BeritaBloc();
  ConnectionCubit connectionCubit = ConnectionCubit();
  final scrollController = ScrollController();
  final int _perPage = 25;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    beritaBloc.add(
      BeritaFetch(perPage: _perPage),
    );
    scrollController.addListener(
      () {
        if (scrollController.offset >=
                scrollController.position.maxScrollExtent &&
            !scrollController.position.outOfRange) {
          // Reach the bottom.
          beritaBloc.add(
            BeritaFetchMore(perPage: 25),
          );
        }
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    beritaBloc.close();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => beritaBloc,
      child: BlocConsumer<BeritaBloc, BeritaState>(
        bloc: beritaBloc,
        listener: (context, state) {},
        builder: (BuildContext context, BeritaState state) {
          return Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              centerTitle: true,
              title: const Text('Berita Terkini'),
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
            body: CustomScrollView(
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
                        await Future.delayed(const Duration(milliseconds: 100));
                        beritaBloc.add(BeritaFetch());
                      },
                      child: SingleChildScrollView(
                          controller: scrollController,
                          child: _beritaList(context))),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _beritaList(BuildContext context) {
    double childAspectRatio;
    if (ResponsiveLayout.isDesktop(context)) {
      // Increase left and right padding for desktop
      childAspectRatio = 1;
    } else if (ResponsiveLayout.isTablet(context)) {
      // Increase left and right padding for tablets
      childAspectRatio = 1.05;
    } else {
      // Use the default padding for phones and other devices
      childAspectRatio = 0.85;
    }
    int crossAxisCount;
    if (ResponsiveLayout.isDesktop(context)) {
      // Increase left and right padding for desktop
      crossAxisCount = 3;
    } else if (ResponsiveLayout.isTablet(context)) {
      // Increase left and right padding for tablets
      crossAxisCount = 2;
    } else {
      // Use the default padding for phones and other devices
      crossAxisCount = 2;
    }
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: SizedBox(
        child: BlocBuilder<BeritaBloc, BeritaState>(
          bloc: beritaBloc,
          builder: (context, data) {
            if (data is BeritaLoaded) {
              List<Berita> berita = data.listOfBerita?.toList() ?? [];
              if (berita.isEmpty) {
                return const SizedBox(
                  height: 300,
                  child: Center(
                    //change card
                    child: ArticleNotFoundCard(),
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
    );
  }
}
