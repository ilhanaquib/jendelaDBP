import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:jendela_dbp/hive/models/hive_book_model.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

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
import 'package:jendela_dbp/stateManagement/blocs/article_bloc.dart';
import 'package:jendela_dbp/stateManagement/blocs/poduct_bloc.dart';
import 'package:jendela_dbp/stateManagement/blocs/post_bloc.dart';
import 'package:jendela_dbp/stateManagement/cubits/connection_cubit.dart';
import 'package:jendela_dbp/stateManagement/events/article_event.dart';
import 'package:jendela_dbp/stateManagement/events/post_event.dart';
import 'package:jendela_dbp/stateManagement/states/article_state.dart';
import 'package:jendela_dbp/stateManagement/states/post_state.dart';

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
  ProductBloc bookBloc = ProductBloc();
  Box<HiveBookAPI> bookAPIBox = Hive.box<HiveBookAPI>(GlobalVar.apiBook);
  ConnectionCubit connectionCubit = ConnectionCubit();

  @override
  void initState() {
    connectionCubit.checkConnection(context);
    postBloc.add(PostFetch());
    articleBloc.add(ArticleFetch());
    super.initState();
  }

  @override
  void dispose() {
    postBloc.close();
    articleBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<int> bookList = bookAPIBox.keys.cast<int>().toList();
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
                postBloc.add(PostFetch());
                articleBloc.add(ArticleFetch());
                setState(() {});
              },
              child: ListView(
                children: [
                  _post(context),
                  _article(context),
                  for (int i = 1; i < 9; i++) _articleCategory(context, i),
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
  }

  Widget _post(BuildContext context) {
    double childAspectRatio;
    if (ResponsiveLayout.isDesktop(context)) {
      childAspectRatio = 1.1;
    } else if (ResponsiveLayout.isTablet(context)) {
      childAspectRatio = 1;
    } else {
      childAspectRatio = 0.6;
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
                child: GridView(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: 5,
                      crossAxisSpacing: 5,
                      childAspectRatio: childAspectRatio),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: List.generate(
                    posts.length,
                    (index) => HomePostCard(
                      post: posts[index],
                    ),
                  ),
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

  Widget _article(BuildContext context) {
    double childAspectRatio;
    if (ResponsiveLayout.isDesktop(context)) {
      // Increase left and right padding for desktop
      childAspectRatio = 1;
    } else if (ResponsiveLayout.isTablet(context)) {
      // Increase left and right padding for tablets
      childAspectRatio = 1;
    } else {
      // Use the default padding for phones and other devices
      childAspectRatio = 0.6;
    }
    int crossAxisCount;
    if (ResponsiveLayout.isDesktop(context)) {
      // Increase left and right padding for desktop
      crossAxisCount = 5;
    } else if (ResponsiveLayout.isTablet(context)) {
      // Increase left and right padding for tablets
      crossAxisCount = 3;
    } else {
      // Use the default padding for phones and other devices
      crossAxisCount = 2;
    }
    int numOfPost;
    if (ResponsiveLayout.isDesktop(context)) {
      // Increase left and right padding for desktop
      numOfPost = 10;
    } else if (ResponsiveLayout.isTablet(context)) {
      // Increase left and right padding for tablets
      numOfPost = 6;
    } else {
      // Use the default padding for phones and other devices
      numOfPost = 4;
    }

    return Padding(
      padding: const EdgeInsets.only(top: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 24),
            child: Text(
              'Artikel Terkini',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
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
                  child: GridView(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        mainAxisSpacing: 5,
                        crossAxisSpacing: 5,
                        childAspectRatio: childAspectRatio),
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: List.generate(
                      articles.length,
                      (index) => HomeArticleCard(
                        article: articles[index],
                      ),
                    ),
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

    double childAspectRatio;
    if (ResponsiveLayout.isDesktop(context)) {
      // Increase left and right padding for desktop
      childAspectRatio = 1;
    } else if (ResponsiveLayout.isTablet(context)) {
      // Increase left and right padding for tablets
      childAspectRatio = 1;
    } else {
      // Use the default padding for phones and other devices
      childAspectRatio = 0.6;
    }
    int crossAxisCount;
    if (ResponsiveLayout.isDesktop(context)) {
      // Increase left and right padding for desktop
      crossAxisCount = 5;
    } else if (ResponsiveLayout.isTablet(context)) {
      // Increase left and right padding for tablets
      crossAxisCount = 3;
    } else {
      // Use the default padding for phones and other devices
      crossAxisCount = 2;
    }
    int numOfPost;
    if (ResponsiveLayout.isDesktop(context)) {
      // Increase left and right padding for desktop
      numOfPost = 10;
    } else if (ResponsiveLayout.isTablet(context)) {
      // Increase left and right padding for tablets
      numOfPost = 6;
    } else {
      // Use the default padding for phones and other devices
      numOfPost = 4;
    }

    return Padding(
      padding: const EdgeInsets.only(top: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 24),
            child: Text(
              categoryName[i]!,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
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
                  child: GridView(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        mainAxisSpacing: 5,
                        crossAxisSpacing: 5,
                        childAspectRatio: childAspectRatio),
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: List.generate(
                      articles.length,
                      (index) => HomeArticleCard(
                        article: articles[index],
                      ),
                    ),
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
