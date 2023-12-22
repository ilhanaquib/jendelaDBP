import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:jendela_dbp/components/article/article_slideshow_card.dart';
import 'package:jendela_dbp/components/berita/berita_not_found_card.dart';
import 'package:jendela_dbp/components/berita/home_berita_card.dart';
import 'package:jendela_dbp/components/radio/radio_card.dart';
import 'package:jendela_dbp/components/radio/radio_not_found_card.dart';
import 'package:jendela_dbp/components/tv/tv_card.dart';
import 'package:jendela_dbp/components/tv/tv_not_found_card.dart';
import 'package:jendela_dbp/hive/models/hive_berita_model.dart';
import 'package:jendela_dbp/hive/models/hive_book_model.dart';
import 'package:jendela_dbp/hive/models/hive_tv_model.dart';
import 'package:jendela_dbp/stateManagement/blocs/berita_bloc.dart';
import 'package:jendela_dbp/stateManagement/blocs/radio_bloc.dart';
import 'package:jendela_dbp/stateManagement/blocs/tv_bloc.dart';
import 'package:jendela_dbp/stateManagement/cubits/liked_status_cubit.dart';
import 'package:jendela_dbp/stateManagement/events/berita_event.dart';
import 'package:jendela_dbp/stateManagement/events/radio_event.dart';
import 'package:jendela_dbp/stateManagement/events/tv_event.dart';
import 'package:jendela_dbp/stateManagement/states/berita_state.dart';
import 'package:jendela_dbp/stateManagement/states/radio_state.dart';
import 'package:jendela_dbp/stateManagement/states/tv_state.dart';
import 'package:jendela_dbp/view/pages/all_radio_screen.dart';
import 'package:jendela_dbp/view/pages/all_tv.dart';
import 'package:jendela_dbp/view/pages/berita/all_berita.dart';
import 'package:jendela_dbp/view/pages/articles/all_articles.dart';
import 'package:jendela_dbp/view/pages/articles/all_articles_categorized.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:jendela_dbp/components/article/article_not_found.dart';
import 'package:jendela_dbp/components/bookshelf/bookshelf.dart';
import 'package:jendela_dbp/components/cart/cart_icon.dart';
import 'package:jendela_dbp/components/home/home_article_card.dart';
import 'package:jendela_dbp/components/home/home_post_card.dart';
import 'package:jendela_dbp/components/posts/error_card.dart';
import 'package:jendela_dbp/components/posts/post_not_found_card.dart';
import 'package:jendela_dbp/components/ujana/home_drawer.dart';
import 'package:jendela_dbp/controllers/dbp_color.dart';
import 'package:jendela_dbp/controllers/global_var.dart';
import 'package:jendela_dbp/controllers/screen_size.dart';
import 'package:jendela_dbp/hive/models/hive_article_model.dart';
import 'package:jendela_dbp/hive/models/hive_post_model.dart';
import 'package:jendela_dbp/hive/models/hive_radio_model.dart' as radio1;
import 'package:jendela_dbp/stateManagement/blocs/article_bloc.dart';
import 'package:jendela_dbp/stateManagement/blocs/poduct_bloc.dart';
import 'package:jendela_dbp/stateManagement/blocs/post_bloc.dart';
import 'package:jendela_dbp/stateManagement/cubits/connection_cubit.dart';
import 'package:jendela_dbp/stateManagement/events/article_event.dart';
import 'package:jendela_dbp/stateManagement/events/post_event.dart';
import 'package:jendela_dbp/stateManagement/states/article_state.dart';
import 'package:jendela_dbp/stateManagement/states/post_state.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey appBarKey = GlobalKey();
  PostBloc postBloc = PostBloc();
  ArticleBloc articleBloc = ArticleBloc();
  BeritaBloc beritaBloc = BeritaBloc();
  TvBloc tvBloc = TvBloc();
  RadioBloc radioBloc = RadioBloc();

  ProductBloc bookBloc = ProductBloc();
  Box<HiveBookAPI> bookAPIBox = Hive.box<HiveBookAPI>(GlobalVar.apiBook);
  ConnectionCubit connectionCubit = ConnectionCubit();
  final PageController pageController = PageController();
  int currentPage = 0;

  @override
  void initState() {
    connectionCubit.checkConnection(context);
    postBloc.add(PostFetch());
    beritaBloc.add(BeritaFetch(perPage: 15));
    articleBloc.add(ArticleFetch());
    tvBloc.add(TvFetch());
    radioBloc.add(RadioFetch());
    super.initState();
  }

  @override
  void dispose() {
    beritaBloc.close();
    postBloc.close();
    articleBloc.close();
    tvBloc.close();
    radioBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<int> bookList = bookAPIBox.keys.cast<int>().toList();
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => postBloc),
        BlocProvider(
          create: (context) => LikedStatusCubit(),
        )
      ],
      child: BlocConsumer<PostBloc, PostState>(
        bloc: postBloc,
        listener: (context, state) {},
        builder: (BuildContext context, PostState state) {
          return Scaffold(
            backgroundColor: Colors.white,
            key: _scaffoldKey,
            appBar: AppBar(
              backgroundColor: Colors.white,
              key: appBarKey,
              centerTitle: true,
              title: const Text('Laman Utama'),
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
                  child: RefreshIndicator(
                    onRefresh: () async {
                      connectionCubit.checkConnection(context);
                      beritaBloc.add(BeritaFetch(perPage: 15));
                      postBloc.add(PostFetch());
                      articleBloc.add(ArticleFetch());
                      tvBloc.add(TvFetch());
                      radioBloc.add(RadioFetch());
                      setState(() {});
                    },
                    child: ListView(
                      children: [
                        _articleSlideshow(context),
                        _post(context),
                        const SizedBox(
                          height: 24,
                        ),
                        _beritaWidget(context),
                        const SizedBox(
                          height: 24,
                        ),
                        _article(context),
                        const SizedBox(
                          height: 24,
                        ),
                        _tvWidget(context),
                        Container(
                          height: 12,
                          color: DbpColor().jendelaGreenBlue,
                        ),
                        Container(
                          height: 12,
                          color: DbpColor().jendelaDarkGreenBlue,
                        ),
                        _radioWidget(context),
                        const SizedBox(
                          height: 24,
                        ),
                        for (int i = 1; i < 9; i++)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 24),
                            child: _articleCategory(context, i),
                          ),
                        const SizedBox(
                          height: 24,
                        ),
                        bookShelf(
                          context,
                          "Buku",
                          0,
                          bookList,
                          bookAPIBox,
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _post(BuildContext context) {
    double childAspectRatio;
    if (ResponsiveLayout.isDesktop(context)) {
      childAspectRatio = 1.1;
    } else if (ResponsiveLayout.isTablet(context)) {
      childAspectRatio = 0.9;
    } else {
      childAspectRatio = 0.8;
    }
    int crossAxisCount;
    if (ResponsiveLayout.isDesktop(context)) {
      crossAxisCount = 5;
    } else if (ResponsiveLayout.isTablet(context)) {
      crossAxisCount = 3;
    } else {
      crossAxisCount = 2;
    }
    int numOfPost;
    if (ResponsiveLayout.isDesktop(context)) {
      numOfPost = 10;
    } else if (ResponsiveLayout.isTablet(context)) {
      numOfPost = 6;
    } else {
      numOfPost = 4;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 24),
          child: Text(
            'Siaran Terkini',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
        BlocBuilder<PostBloc, PostState>(
          bloc: postBloc,
          builder: (context, data) {
            if (data is PostLoaded) {
              List<Post> posts =
                  data.listOfPost?.take(numOfPost).toList() ?? [];
              if (posts.isEmpty) {
                return const SizedBox(
                  height: 300,
                  child: Center(
                    child: PostNotFoundCard(),
                  ),
                );
              }
              return Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 19),
                      child: SizedBox(
                        child: HomePostCard(post: posts[0]),
                      ),
                    ),
                    GridView(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 18,
                          childAspectRatio: childAspectRatio),
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      children: List.generate(
                        posts.length - 1,
                        (index) => HomePostCard(
                          post: posts[index + 1],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            if (data is PostError) {
              return ErrorCard(
                message: data.message ?? '',
              );
            }
            return SizedBox(
              height: 300,
              child: Center(
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
      ],
    );
  }

  Widget _articleSlideshow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 12),
      child: BlocBuilder<ArticleBloc, ArticleState>(
        bloc: articleBloc,
        builder: (context, data) {
          if (data is ArticleLoaded) {
            List<Article> articles = data.listOfArticle?.take(8).toList() ?? [];
            if (articles.isEmpty) {
              return const SizedBox(
                height: 300,
                child: Center(
                  child: ArticleNotFoundCard(),
                ),
              );
            }
            return SizedBox(
              height: 500, // Set your desired height
              child: PageView.builder(
                controller: pageController,
                //itemCount: articles.length,
                itemBuilder: (BuildContext context, int index) {
                  return ArticleSlideshowCard(
                    pageContoller: pageController,
                    article: articles[index % articles.length],
                    textSize: ResponsiveLayout.isDesktop(context)
                        ? 250
                        : ResponsiveLayout.isTablet(context)
                            ? 170
                            : 130,
                  );
                },
              ),
            );
          }
          if (data is ArticleError) {
            return const ErrorCard(message: 'error');
          }
          return SizedBox(
            height: 300,
            child: Center(
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
    );
  }

  Widget _beritaWidget(BuildContext context) {
    int crossAxisCount;
    if (ResponsiveLayout.isDesktop(context)) {
      // Increase left and right padding for desktop
      crossAxisCount = 5;
    } else if (ResponsiveLayout.isTablet(context)) {
      // Increase left and right padding for tablets
      crossAxisCount = 4;
    } else {
      // Use the default padding for phones and other devices
      crossAxisCount = 4;
    }
    return Padding(
      padding: const EdgeInsets.only(top: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 24, bottom: 12, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Berita Terkini',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                TextButton(
                  onPressed: () {
                    PersistentNavBarNavigator.pushNewScreen(
                      context,
                      // change to all berita
                      screen: const AllBerita(),
                    );
                  },
                  child: Text(
                    'Lihat Semua',
                    style: TextStyle(color: DbpColor().jendelaGray),
                  ),
                )
              ],
            ),
          ),
          BlocBuilder<BeritaBloc, BeritaState>(
            bloc: beritaBloc,
            builder: (context, data) {
              if (data is BeritaLoaded) {
                List<Berita> beritaList =
                    data.listOfBerita?.take(9).toList() ?? [];
                if (beritaList.isEmpty) {
                  return const SizedBox(
                    height: 300,
                    child: Center(
                      child: BeritaNotFoundCard(),
                    ),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: StaggeredGrid.count(
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: ResponsiveLayout.isDesktop(context)
                        ? 5
                        : ResponsiveLayout.isTablet(context)
                            ? 8
                            : 10,
                    crossAxisSpacing: ResponsiveLayout.isDesktop(context)
                        ? 5
                        : ResponsiveLayout.isTablet(context)
                            ? 8
                            : 8,
                    children: beritaList.map((berita) {
                      int index = beritaList.indexOf(berita);
                      int crossAxisCellCount = 4;
                      int mainAxisCellCount = 3;

                      if (index != 0) {
                        crossAxisCellCount = 2;
                        mainAxisCellCount = 3;
                      }

                      return StaggeredGridTile.count(
                        crossAxisCellCount: crossAxisCellCount,
                        mainAxisCellCount: mainAxisCellCount,
                        child: HomeBeritaCard(
                          berita: berita,
                          textSize: ResponsiveLayout.isDesktop(context)
                              ? 250
                              : ResponsiveLayout.isTablet(context)
                                  ? 170
                                  : 130,
                        ),
                      );
                    }).toList(),
                  ),
                );
              }
              if (data is ArticleError) {
                return const ErrorCard(message: 'error');
              }
              return SizedBox(
                height: 300,
                child: Center(
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
        ],
      ),
    );
  }

  Widget _article(BuildContext context) {
    int crossAxisCount;
    if (ResponsiveLayout.isDesktop(context)) {
      // Increase left and right padding for desktop
      crossAxisCount = 5;
    } else if (ResponsiveLayout.isTablet(context)) {
      // Increase left and right padding for tablets
      crossAxisCount = 4;
    } else {
      // Use the default padding for phones and other devices
      crossAxisCount = 4;
    }
    int numOfPost;
    if (ResponsiveLayout.isDesktop(context)) {
      // Increase left and right padding for desktop
      numOfPost = 11;
    } else if (ResponsiveLayout.isTablet(context)) {
      // Increase left and right padding for tablets
      numOfPost = 9;
    } else {
      // Use the default padding for phones and other devices
      numOfPost = 5;
    }

    return Padding(
      padding: const EdgeInsets.only(top: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 24, bottom: 12, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Artikel Terkini',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                TextButton(
                  onPressed: () {
                    PersistentNavBarNavigator.pushNewScreen(
                      context,
                      screen: const AllArticle(),
                    );
                  },
                  child: Text(
                    'Lihat Semua',
                    style: TextStyle(color: DbpColor().jendelaGray),
                  ),
                )
              ],
            ),
          ),
          BlocBuilder<ArticleBloc, ArticleState>(
            bloc: articleBloc,
            builder: (context, data) {
              if (data is ArticleLoaded) {
                List<Article> articles =
                    data.listOfArticle?.take(numOfPost).toList() ?? [];
                if (articles.isEmpty) {
                  return const SizedBox(
                    height: 300,
                    child: Center(
                      child: ArticleNotFoundCard(),
                    ),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: StaggeredGrid.count(
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: ResponsiveLayout.isDesktop(context)
                        ? 5
                        : ResponsiveLayout.isTablet(context)
                            ? 8
                            : 10,
                    crossAxisSpacing: ResponsiveLayout.isDesktop(context)
                        ? 5
                        : ResponsiveLayout.isTablet(context)
                            ? 8
                            : 8,
                    children: articles.map((article) {
                      int index = articles
                          .indexOf(article); // Index of the current article
                      int crossAxisCellCount = 4;
                      int mainAxisCellCount = 3;

                      if (index != 0) {
                        crossAxisCellCount = 2;
                        mainAxisCellCount = 3;
                      }

                      return StaggeredGridTile.count(
                        crossAxisCellCount: crossAxisCellCount,
                        mainAxisCellCount: mainAxisCellCount,
                        child: HomeArticleCard(
                          article: article,
                          textSize: ResponsiveLayout.isDesktop(context)
                              ? 250
                              : ResponsiveLayout.isTablet(context)
                                  ? 170
                                  : 130,
                        ),
                      );
                    }).toList(),
                  ),
                );
              }
              if (data is ArticleError) {
                return const ErrorCard(message: 'error');
              }
              return SizedBox(
                height: 300,
                child: Center(
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
        ],
      ),
    );
  }

  Widget _tvWidget(BuildContext context) {
    int crossAxisCount;
    if (ResponsiveLayout.isDesktop(context)) {
      // Increase left and right padding for desktop
      crossAxisCount = 5;
    } else if (ResponsiveLayout.isTablet(context)) {
      // Increase left and right padding for tablets
      crossAxisCount = 4;
    } else {
      // Use the default padding for phones and other devices
      crossAxisCount = 4;
    }
    return Container(
      color: DbpColor().jendelaGreenBlue,
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 24, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'TV DBP',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white),
                  ),
                  TextButton(
                    onPressed: () {
                      PersistentNavBarNavigator.pushNewScreen(
                        context,
                        screen: const AllTvScreen(),
                      );
                    },
                    child: const Text(
                      'Lihat Semua',
                      style:
                          TextStyle(color: Color.fromARGB(255, 205, 204, 204)),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              child: BlocBuilder<TvBloc, TvState>(
                bloc: tvBloc,
                builder: (context, data) {
                  if (data is TvError) {
                    return ErrorCard(message: data.message);
                  }
                  if (data is TvLoaded) {
                    List<Tv> tvList = data.tv?.take(9).toList() ?? [];
                    if (tvList.isEmpty) {
                      return const SizedBox(height: 300, child: TvNotFoundCard());
                    }
                    return StaggeredGrid.count(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: ResponsiveLayout.isDesktop(context)
                          ? 5
                          : ResponsiveLayout.isTablet(context)
                              ? 8
                              : 1,
                      crossAxisSpacing: ResponsiveLayout.isDesktop(context)
                          ? 5
                          : ResponsiveLayout.isTablet(context)
                              ? 8
                              : 1,
                      children: tvList.map((tv) {
                        int index =
                            tvList.indexOf(tv); // Index of the current article
                        int crossAxisCellCount = 4;
                        int mainAxisCellCount = 3;

                        if (index != 0) {
                          crossAxisCellCount = 2;
                          mainAxisCellCount = 2;
                        }

                        return StaggeredGridTile.count(
                          crossAxisCellCount: crossAxisCellCount,
                          mainAxisCellCount: mainAxisCellCount,
                          child: TvCard(
                            tv: tv,
                          ),
                        );
                      }).toList(),
                    );
                  }
                  return Center(
                    child: LoadingAnimationWidget.discreteCircle(
                      color: DbpColor().jendelaGray,
                      secondRingColor: DbpColor().jendelaGreen,
                      thirdRingColor: DbpColor().jendelaOrange,
                      size: 70.0,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _radioWidget(BuildContext context) {
    int crossAxisCount;
    if (ResponsiveLayout.isDesktop(context)) {
      // Increase left and right padding for desktop
      crossAxisCount = 5;
    } else if (ResponsiveLayout.isTablet(context)) {
      // Increase left and right padding for tablets
      crossAxisCount = 4;
    } else {
      // Use the default padding for phones and other devices
      crossAxisCount = 4;
    }
    return Container(
      color: DbpColor().jendelaDarkGreenBlue,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 24, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'RADIO DBP',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white),
                  ),
                  TextButton(
                    onPressed: () {
                      PersistentNavBarNavigator.pushNewScreen(
                        context,
                        screen: const AllRadioScreen(),
                      );
                    },
                    child: const Text(
                      'Lihat Semua',
                      style:
                          TextStyle(color: Color.fromARGB(255, 205, 204, 204)),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              child: BlocBuilder<RadioBloc, RadioState>(
                bloc: radioBloc,
                builder: (context, data) {
                  if (data is RadioError) {
                    return ErrorCard(message: data.message);
                  }
                  if (data is RadioLoaded) {
                    List<radio1.Radio> radios =
                        data.radios?.take(9).toList() ?? [];
                    if (radios.isEmpty) {
                      return const SizedBox(height: 300, child: RadioNotFoundCard());
                    }
                    return StaggeredGrid.count(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: ResponsiveLayout.isDesktop(context)
                          ? 5
                          : ResponsiveLayout.isTablet(context)
                              ? 8
                              : 1,
                      crossAxisSpacing: ResponsiveLayout.isDesktop(context)
                          ? 5
                          : ResponsiveLayout.isTablet(context)
                              ? 8
                              : 1,
                      children: radios.map((radio) {
                        int index = radios
                            .indexOf(radio); // Index of the current article
                        int crossAxisCellCount = 4;
                        int mainAxisCellCount = 3;

                        if (index != 0) {
                          crossAxisCellCount = 2;
                          mainAxisCellCount = 2;
                        }

                        return StaggeredGridTile.count(
                          crossAxisCellCount: crossAxisCellCount,
                          mainAxisCellCount: mainAxisCellCount,
                          child: RadioCard(
                            radio: radio,
                          ),
                        );
                      }).toList(),
                    );
                  }
                  return Center(
                    child: LoadingAnimationWidget.discreteCircle(
                      color: DbpColor().jendelaGray,
                      secondRingColor: DbpColor().jendelaGreen,
                      thirdRingColor: DbpColor().jendelaOrange,
                      size: 70.0,
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _articleCategory(BuildContext context, int i) {
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

    int crossAxisCount;
    if (ResponsiveLayout.isDesktop(context)) {
      // Increase left and right padding for desktop
      crossAxisCount = 5;
    } else if (ResponsiveLayout.isTablet(context)) {
      // Increase left and right padding for tablets
      crossAxisCount = 4;
    } else {
      // Use the default padding for phones and other devices
      crossAxisCount = 4;
    }
    int numOfPost;
    if (ResponsiveLayout.isDesktop(context)) {
      // Increase left and right padding for desktop
      numOfPost = 11;
    } else if (ResponsiveLayout.isTablet(context)) {
      // Increase left and right padding for tablets
      numOfPost = 9;
    } else {
      // Use the default padding for phones and other devices
      numOfPost = 5;
    }

    return Padding(
      padding: const EdgeInsets.only(top: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(),
          Padding(
            padding: const EdgeInsets.only(left: 20, bottom: 12, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  categoryName[i]!,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20),
                ),
                TextButton(
                  onPressed: () {
                    PersistentNavBarNavigator.pushNewScreen(
                      context,
                      screen: CategorizedArticles(i: i),
                    );
                  },
                  child: Text(
                    'Lihat Semua',
                    style: TextStyle(color: DbpColor().jendelaGray),
                  ),
                )
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 0, bottom: 8, left: 20, right: 20),
            child: Text('Berita',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          ),
          BlocBuilder<BeritaBloc, BeritaState>(
            bloc: beritaBloc,
            builder: (context, data) {
              if (data is BeritaLoaded) {
                List<Berita> beritaList = data.listOfBerita
                        ?.where((e) => e.blogId == categoryId[i])
                        .take(numOfPost)
                        .toList() ??
                    [];
                if (beritaList.isEmpty) {
                  return const SizedBox(
                    height: 300,
                    child: Center(
                      child: BeritaNotFoundCard(),
                    ),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: StaggeredGrid.count(
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: ResponsiveLayout.isDesktop(context)
                        ? 5
                        : ResponsiveLayout.isTablet(context)
                            ? 8
                            : 10,
                    crossAxisSpacing: ResponsiveLayout.isDesktop(context)
                        ? 5
                        : ResponsiveLayout.isTablet(context)
                            ? 8
                            : 8,
                    children: beritaList.map((berita) {
                      int index = beritaList
                          .indexOf(berita); // Index of the current article
                      int crossAxisCellCount = 4;
                      int mainAxisCellCount = 3;

                      if (index != 0) {
                        crossAxisCellCount = 2;
                        mainAxisCellCount = 3;
                      }

                      return StaggeredGridTile.count(
                        crossAxisCellCount: crossAxisCellCount,
                        mainAxisCellCount: mainAxisCellCount,
                        child: HomeBeritaCard(
                          berita: berita,
                          textSize: ResponsiveLayout.isDesktop(context)
                              ? 250
                              : ResponsiveLayout.isTablet(context)
                                  ? 170
                                  : 130,
                        ),
                      );
                    }).toList(),
                  ),
                );
              }

              if (data is ArticleError) {
                return const ErrorCard(message: 'error');
              }
              return SizedBox(
                height: 300,
                child: Center(
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
          const Padding(
            padding: EdgeInsets.only(top: 40, bottom: 8, left: 20, right: 20),
            child: Text('Artikel',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          ),
          BlocBuilder<ArticleBloc, ArticleState>(
            bloc: articleBloc,
            builder: (context, data) {
              if (data is ArticleLoaded) {
                List<Article> articles = data.listOfArticle
                        ?.where((e) => e.blogId == categoryId[i])
                        .take(numOfPost)
                        .toList() ??
                    [];
                if (articles.isEmpty) {
                  return const SizedBox(
                    height: 300,
                    child: Center(
                      child: ArticleNotFoundCard(),
                    ),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: StaggeredGrid.count(
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: ResponsiveLayout.isDesktop(context)
                        ? 5
                        : ResponsiveLayout.isTablet(context)
                            ? 8
                            : 10,
                    crossAxisSpacing: ResponsiveLayout.isDesktop(context)
                        ? 5
                        : ResponsiveLayout.isTablet(context)
                            ? 8
                            : 8,
                    children: articles.map((article) {
                      int index = articles
                          .indexOf(article); // Index of the current article
                      int crossAxisCellCount = 4;
                      int mainAxisCellCount = 3;

                      if (index != 0) {
                        crossAxisCellCount = 2;
                        mainAxisCellCount = 3;
                      }

                      return StaggeredGridTile.count(
                        crossAxisCellCount: crossAxisCellCount,
                        mainAxisCellCount: mainAxisCellCount,
                        child: HomeArticleCard(
                          article: article,
                          textSize: ResponsiveLayout.isDesktop(context)
                              ? 250
                              : ResponsiveLayout.isTablet(context)
                                  ? 170
                                  : 130,
                        ),
                      );
                    }).toList(),
                  ),
                );
              }

              if (data is ArticleError) {
                return const ErrorCard(message: 'error');
              }
              return SizedBox(
                height: 300,
                child: Center(
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
        ],
      ),
    );
  }
}
