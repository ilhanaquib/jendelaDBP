import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jendela_dbp/components/article/article_card.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:jendela_dbp/components/article/article_not_found.dart';
import 'package:jendela_dbp/components/cart/cart_icon.dart';
import 'package:jendela_dbp/components/posts/error_card.dart';
import 'package:jendela_dbp/components/ujana/home_drawer.dart';
import 'package:jendela_dbp/controllers/dbp_color.dart';
import 'package:jendela_dbp/controllers/global_var.dart';
import 'package:jendela_dbp/controllers/screen_size.dart';
import 'package:jendela_dbp/hive/models/hive_article_model.dart';
import 'package:jendela_dbp/stateManagement/blocs/article_bloc.dart';
import 'package:jendela_dbp/stateManagement/blocs/poduct_bloc.dart';
import 'package:jendela_dbp/stateManagement/events/article_event.dart';
import 'package:jendela_dbp/stateManagement/states/article_state.dart';

class CategorizedArticles extends StatefulWidget {
  CategorizedArticles({super.key, required this.i});

  int i;

  @override
  State<CategorizedArticles> createState() => _CategorizedArticlesState();
}

class _CategorizedArticlesState extends State<CategorizedArticles> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ArticleBloc articleBloc = ArticleBloc();
  ProductBloc bookBloc = ProductBloc();
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
    articleBloc.add(ArticleFetch());
    super.initState();
  }

  @override
  void dispose() {
    articleBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(categoryName[widget.i]!),
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
                // _scaffoldKey.currentState?.openDrawer();
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
                articleBloc.add(ArticleFetch());
                setState(() {});
              },
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: //_articleCategory(context, widget.i),
                    _articleListBig(context, widget.i)
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _articleListBig(BuildContext context, int i) {
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
    double childAspectRatio;
    if (ResponsiveLayout.isDesktop(context)) {
      // Increase left and right padding for desktop
      childAspectRatio = 1;
    } else if (ResponsiveLayout.isTablet(context)) {
      // Increase left and right padding for tablets
      childAspectRatio = 1.05;
    } else {
      // Use the default padding for phones and other devices
      childAspectRatio = 0.70;
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
        child: BlocBuilder<ArticleBloc, ArticleState>(
          bloc: articleBloc,
          builder: (context, data) {
            if (data is ArticleLoaded) {
              List<Article> articles = data.listOfArticle
                      ?.where((e) => e.blogId == categoryId[i])
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
    );
  }
}
