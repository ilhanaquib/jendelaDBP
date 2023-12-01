import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jendela_dbp/components/article/article_not_found.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:jendela_dbp/components/article/article_card.dart';
import 'package:jendela_dbp/components/cart/cart_icon.dart';
import 'package:jendela_dbp/components/posts/error_card.dart';
import 'package:jendela_dbp/components/posts/post_card.dart';
import 'package:jendela_dbp/components/posts/post_not_found_card.dart';
import 'package:jendela_dbp/components/ujana/home_drawer.dart';
import 'package:jendela_dbp/controllers/dbp_color.dart';
import 'package:jendela_dbp/controllers/screen_size.dart';
import 'package:jendela_dbp/hive/models/hiveArticleModel.dart';
import 'package:jendela_dbp/hive/models/hivePostModel.dart';
import 'package:jendela_dbp/stateManagement/blocs/article_bloc.dart';
import 'package:jendela_dbp/stateManagement/blocs/post_bloc.dart';
import 'package:jendela_dbp/stateManagement/cubits/connection_cubit.dart';
import 'package:jendela_dbp/stateManagement/events/article_event.dart';
import 'package:jendela_dbp/stateManagement/events/post_event.dart';
import 'package:jendela_dbp/stateManagement/states/article_state.dart';
import 'package:jendela_dbp/stateManagement/states/post_state.dart';

class PostAndArticle extends StatefulWidget {
  const PostAndArticle({super.key});

  @override
  State<PostAndArticle> createState() => _PostAndArticleState();
}

class _PostAndArticleState extends State<PostAndArticle> {
  PostBloc latestPostBloc = PostBloc();
  ArticleBloc latestArticleBloc = ArticleBloc();
  ConnectionCubit connectionCubit = ConnectionCubit();
  final _scrollController = ScrollController();
  final int _perPage = 25;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    latestPostBloc.add(PostFetch());
    latestArticleBloc.add(
      ArticleFetch(perPage: _perPage),
    );
    _scrollController.addListener(
      () {
        if (_scrollController.offset >=
                _scrollController.position.maxScrollExtent &&
            !_scrollController.position.outOfRange) {
          // Reach the bottom.
          latestArticleBloc.add(
            ArticleFetchMore(perPage: 25),
          );
        }
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    latestPostBloc.close();
    latestArticleBloc.close();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text('Sohor Kini'),
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
      drawer: HomeDrawer(updateAppBar: () {
        setState(() {});
      }),
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
                latestPostBloc.add(PostFetch());
                latestArticleBloc.add(ArticleFetch());
              },
              child: ListView(
                children: [
                  _postList(context),
                  ResponsiveLayout.isDesktop(context) ||
                          ResponsiveLayout.isTablet(context)
                      ? _articleListBig(context)
                      : _articleList(context)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _postList(BuildContext context) {
    double childAspectRatio;
    if (ResponsiveLayout.isDesktop(context)) {
      // Increase left and right padding for desktop
      childAspectRatio = 2.5;
    } else if (ResponsiveLayout.isTablet(context)) {
      // Increase left and right padding for tablets
      childAspectRatio = 2.5;
    } else {
      // Use the default padding for phones and other devices
      childAspectRatio = 0.6;
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'Siaran',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        BlocBuilder<PostBloc, PostState>(
          bloc: latestPostBloc,
          builder: (context, data) {
            if (data is PostLoading) {
              return SizedBox(
                child: LoadingAnimationWidget.discreteCircle(
                  color: DbpColor().jendelaGray,
                  secondRingColor: DbpColor().jendelaGreen,
                  thirdRingColor: DbpColor().jendelaOrange,
                  size: 50.0,
                ),
              );
            }
            if (data is PostLoaded) {
              List<Post> posts = data.listOfPost?.toList() ?? [];
              if (posts.isEmpty) {
                return const SizedBox(
                  height: 300,
                  child: Center(
                    child: PostNotFoundCard(),
                  ),
                );
              }
              return ResponsiveLayout.isDesktop(context) ||
                      ResponsiveLayout.isTablet(context)
                  ? GridView(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          mainAxisSpacing: 5,
                          crossAxisSpacing: 5,
                          childAspectRatio: childAspectRatio),
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      children: List.generate(
                        posts.length,
                        (index) => PostCard(
                          post: posts[index],
                        ),
                      ),
                    )
                  : ListView(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      children: List.generate(
                        posts.length,
                        (index) => PostCard(
                          post: posts[index],
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

  Widget _articleList(BuildContext context) {
    Size size = MediaQuery.maybeOf(context)!.size;
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Artikel',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          SizedBox(
            child: BlocBuilder<ArticleBloc, ArticleState>(
              bloc: latestArticleBloc,
              builder: (context, state) {
                if (state is ArticleLoading) {
                  return SizedBox(
                    height: size.height,
                    child: LoadingAnimationWidget.discreteCircle(
                      color: DbpColor().jendelaGray,
                      secondRingColor: DbpColor().jendelaGreen,
                      thirdRingColor: DbpColor().jendelaOrange,
                      size: 50.0,
                    ),
                  );
                }
                if (state is ArticleError) {
                  return ErrorCard(message: state.message ?? '');
                }
                if (state is ArticleLoaded) {
                  List<Widget> listWidget = state.listOfArticle!.map<Widget>(
                    (item) {
                      return ArticleCard(
                        article: item,
                      );
                    },
                  ).toList();
                  return Column(children: listWidget);
                }
                return const ArticleNotFoundCard();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _articleListBig(BuildContext context) {
    double childAspectRatio;
    if (ResponsiveLayout.isDesktop(context)) {
      // Increase left and right padding for desktop
      childAspectRatio = 2.5;
    } else if (ResponsiveLayout.isTablet(context)) {
      // Increase left and right padding for tablets
      childAspectRatio = 2.5;
    } else {
      // Use the default padding for phones and other devices
      childAspectRatio = 0.6;
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Artikel',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          SizedBox(
            child: BlocBuilder<ArticleBloc, ArticleState>(
              bloc: latestArticleBloc,
              builder: (context, data) {
                if (data is ArticleLoaded) {
                  List<Article> articles = data.listOfArticle?.toList() ?? [];
                  if (articles.isEmpty) {
                    return const SizedBox(
                      height: 300,
                      child: Center(
                        child: ArticleNotFoundCard(),
                      ),
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.only(left: 0, right: 0),
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
                        (index) => ArticleCard(
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
          ),
        ],
      ),
    );
  }
}
