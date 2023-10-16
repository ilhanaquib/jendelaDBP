import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jendela_dbp/components/DBPImportedWidgets/notFoundCard.dart';
import 'package:jendela_dbp/components/articleCard.dart';
import 'package:jendela_dbp/components/posts/errorCard.dart';
import 'package:jendela_dbp/components/posts/postCard.dart';
import 'package:jendela_dbp/components/posts/postNotFoundCard.dart';
import 'package:jendela_dbp/controllers/dbpColor.dart';
import 'package:jendela_dbp/controllers/screenSize.dart';
import 'package:jendela_dbp/hive/models/hiveArticleModel.dart';
import 'package:jendela_dbp/hive/models/hivePostModel.dart';
import 'package:jendela_dbp/stateManagement/blocs/articleBloc.dart';
import 'package:jendela_dbp/stateManagement/blocs/postBloc.dart';
import 'package:jendela_dbp/stateManagement/cubits/connectionCubit.dart';
import 'package:jendela_dbp/stateManagement/events/articleEvent.dart';
import 'package:jendela_dbp/stateManagement/events/postEvent.dart';
import 'package:jendela_dbp/stateManagement/states/articleState.dart';
import 'package:jendela_dbp/stateManagement/states/postState.dart';
import 'package:jendela_dbp/view/pages/postAndArticles/articles/articleScreen.dart';
import 'package:jendela_dbp/view/pages/postAndArticles/posts/posts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

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

  @override
  void initState() {
    latestPostBloc.add(PostFetch());
    latestArticleBloc.add(ArticleFetch(perPage: _perPage));
    _scrollController.addListener(() {
      if (_scrollController.offset >=
              _scrollController.position.maxScrollExtent &&
          !_scrollController.position.outOfRange) {
        // Reach the bottom.
        latestArticleBloc.add(ArticleFetchMore(perPage: 25));
      }
    });
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Post And Article'),
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
                await Future.delayed(Duration(milliseconds: 100));
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
          'Posts',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        BlocBuilder<PostBloc, PostState>(
          bloc: latestPostBloc,
          builder: (context, data) {
            if (data is PostLoading) {
              print('post is loading');
              // return SizedBox(
              //   height: size.height,
              //   child: LoadingAnimationWidget.discreteCircle(
              //     color: DbpColor().jendelaGray,
              //     secondRingColor: DbpColor().jendelaGreen,
              //     thirdRingColor: DbpColor().jendelaOrange,
              //     size: 50.0,
              //   ),
              // );
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
              return ResponsiveLayout.isDesktop(context)
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
                  : ResponsiveLayout.isTablet(context)
                      ? GridView(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
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
                      : ResponsiveLayout.isPhone(context)
                          ? ListView(
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
            'Articles',
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
                return NotFoundCard();
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
            'Articles',
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
                        child: NotFoundCard(),
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
          ),
        ],
      ),
    );
  }
}