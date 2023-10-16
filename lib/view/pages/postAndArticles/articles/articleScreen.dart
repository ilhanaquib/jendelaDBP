import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jendela_dbp/components/DBPImportedWidgets/notFoundCard.dart';
import 'package:jendela_dbp/components/articleCard.dart';
import 'package:jendela_dbp/components/posts/errorCard.dart';
import 'package:jendela_dbp/controllers/dbpColor.dart';
import 'package:jendela_dbp/stateManagement/blocs/articleBloc.dart';
import 'package:jendela_dbp/stateManagement/events/articleEvent.dart';
import 'package:jendela_dbp/stateManagement/states/articleState.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ArticleScreen extends StatefulWidget {
  ArticleScreen({Key? key}) : super(key: key);

  @override
  _ArticleScreen createState() => _ArticleScreen();
}

class _ArticleScreen extends State<ArticleScreen> {
  ArticleBloc _articleBloc = ArticleBloc();
  final _scrollController = ScrollController();
  final int _perPage = 25;
  @override
  void initState() {
    super.initState();
    _articleBloc.add(ArticleFetch(perPage: _perPage));
    _scrollController.addListener(() {
      if (_scrollController.offset >=
              _scrollController.position.maxScrollExtent &&
          !_scrollController.position.outOfRange) {
        // Reach the bottom.
        _articleBloc.add(ArticleFetchMore(perPage: 25));
      }
    });
  }

  @override
  void dispose() {
    _articleBloc.close();
    _scrollController.dispose();
    super.dispose();
  }

  DbpColor colors = DbpColor();
  @override
  Widget build(BuildContext context) {
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
              bloc: _articleBloc,
              builder: (context, state) {
                if (state is ArticleLoading) {
                  return Container(
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
}
