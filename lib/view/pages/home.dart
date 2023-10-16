import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:jendela_dbp/components/DBPImportedWidgets/notFoundCard.dart';
import 'package:jendela_dbp/components/bookshelf/bookshelf.dart';
import 'package:jendela_dbp/components/cart/cartIcon.dart';
import 'package:jendela_dbp/components/home/homeArticleCard.dart';
import 'package:jendela_dbp/components/home/homePostCard.dart';
import 'package:jendela_dbp/components/posts/errorCard.dart';
import 'package:jendela_dbp/components/posts/postNotFoundCard.dart';
import 'package:jendela_dbp/components/ujana/homeDrawer.dart';
import 'package:jendela_dbp/controllers/dbpColor.dart';
import 'package:jendela_dbp/controllers/globalVar.dart';
import 'package:jendela_dbp/controllers/screenSize.dart';
import 'package:jendela_dbp/hive/models/hiveArticleModel.dart';
import 'package:jendela_dbp/hive/models/hiveBookModel.dart';
import 'package:jendela_dbp/hive/models/hivePostModel.dart';
import 'package:jendela_dbp/stateManagement/blocs/articleBloc.dart';
import 'package:jendela_dbp/stateManagement/blocs/imagePickerBloc.dart';
import 'package:jendela_dbp/stateManagement/blocs/poductBloc.dart';
import 'package:jendela_dbp/stateManagement/blocs/postBloc.dart';
import 'package:jendela_dbp/stateManagement/cubits/connectionCubit.dart';
import 'package:jendela_dbp/stateManagement/events/articleEvent.dart';
import 'package:jendela_dbp/stateManagement/events/postEvent.dart';
import 'package:jendela_dbp/stateManagement/states/articleState.dart';
import 'package:jendela_dbp/stateManagement/states/postState.dart';
import 'package:jendela_dbp/stateManagement/states/productState.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey appBarKey = GlobalKey();
  PostBloc latestPostBloc = PostBloc();
  ArticleBloc latestArticleBloc = ArticleBloc();
  ProductBloc latestBookBloc = ProductBloc();

  Box<HiveBookAPI> bookAPIBox = Hive.box<HiveBookAPI>(GlobalVar.APIBook);
  ConnectionCubit connectionCubit = ConnectionCubit();

  void _updateAppBar() {
    setState(() {
      // Rebuild the app bar to reflect the changes
    });
  }

  @override
  void initState() {
    connectionCubit.checkConnection(context);
    latestPostBloc.add(PostFetch());
    latestArticleBloc.add(ArticleFetch());
    super.initState();
  }

  @override
  void dispose() {
    latestPostBloc.close();
    latestArticleBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<int> bookList = bookAPIBox.keys.cast<int>().toList();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        key: appBarKey,
        centerTitle: true,
        title: const Text('Home'),
        leading: Padding(
          padding: const EdgeInsets.only(right: 10),
          child: GestureDetector(
            onTap: () {
              _scaffoldKey.currentState?.openDrawer();
            },
            child: CircleAvatar(
              backgroundImage:
                  context.watch<ImageBloc>().selectedImageProvider ??
                      const AssetImage('assets/images/logo.png'),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: CartIcon(),
          )
        ],
      ),
      drawer: HomeDrawer(
        updateAppBar: _updateAppBar,
      ),
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
                latestPostBloc.add(PostFetch());
                latestArticleBloc.add(ArticleFetch());
              },
              child: ListView(
                children: [
                  _postWidget(context),
                  _articleWidget(context),
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

  Widget _postWidget(BuildContext context) {
    double childAspectRatio;
    if (ResponsiveLayout.isDesktop(context)) {
      // Increase left and right padding for desktop
      childAspectRatio = 1.1;
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'Posts',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        BlocBuilder<PostBloc, PostState>(
          bloc: latestPostBloc,
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

  Widget _articleWidget(BuildContext context) {
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
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Articles',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          BlocBuilder<ArticleBloc, ArticleState>(
            bloc: latestArticleBloc,
            builder: (context, data) {
              if (data is ArticleLoaded) {
                List<Article> articles =
                    data.listOfArticle?.take(numOfPost).toList() ?? [];
                if (articles.isEmpty) {
                  return const SizedBox(
                    height: 300,
                    child: Center(
                      child: NotFoundCard(),
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
                return ErrorCard(message: 'error');
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

  Widget _bookWidget(BuildContext context) {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              height: 300,
              child: BlocBuilder<ProductBloc, ProductState>(
                bloc: latestBookBloc,
                builder: (context, data) {
                  if (data is ProductError) {
                    return ErrorCard(message: data.message);
                  }
                  if (data is ProductLoaded) {
                    List<int> majalahList =
                        bookAPIBox.keys.cast<int>().toList();
                    return bookShelf(
                      context,
                      "Buku",
                      0,
                      majalahList,
                      bookAPIBox,
                    );
                  }
                  return Container(
                    height: 300,
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
            SizedBox(
              height: 5.0,
            ),
            //Padding(
            // padding: const EdgeInsets.symmetric(horizontal: 10.0),
            // child: Divider(
            //color: colors.btnPrimaryColor,
            //thickness: 0.2,
            // height: 10,
            // ),
            // ),
          ],
        ),
      ),
    );
  }
}
