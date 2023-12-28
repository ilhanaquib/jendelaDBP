import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jendela_dbp/api_services.dart';
import 'package:jendela_dbp/hive/models/hive_article_model.dart';
import 'package:jendela_dbp/stateManagement/events/article_event.dart';
import 'package:jendela_dbp/stateManagement/states/article_state.dart';

class ArticleBloc extends Bloc<ArticleEvent, ArticleState> {
  // News Bloc
  ArticleBloc() : super(ArticleInit());
  int _pageCount = 1;
  @override
  Stream<ArticleState> mapEventToState(ArticleEvent event) async* {
    if (event is ArticleInit) {
      _pageCount = 1;
    }
    if (event is ArticleFetch) {
      // Berita berita = Berita();
      yield ArticleLoading();
      _pageCount = 1;
      try {
        List<Article> listOfArtikel = await fetchArtikel();
        yield ArticleLoaded(listOfArticle: listOfArtikel);
      } catch (e) {
        // print(e.toString());
        yield ArticleError(message: e.toString());
      }
    }
    if (event is ArticleFetchMore) {
      try {
        List<Article> respData =
            await fetchArtikel(page: _pageCount + 1, perPage: event.perPage);
        if (respData.isNotEmpty) {
          _pageCount++;
        }
        List<Article> combinedList = [];
        combinedList.addAll(state.listOfArticle ?? []);
        combinedList.addAll(respData);
        yield ArticleLoading();
        yield ArticleLoaded(listOfArticle: combinedList);
      } catch (err) {
        // print(err.toString());
        yield ArticleError(message: err.toString());
      }
    }
  }

  Future<List<Article>> fetchArtikel({int perPage = 25, int page = 1}) async {
    dynamic artikels = await ApiService.getArticle(
        '', {"per_page": perPage.toString(), "page": page.toString()});
    if (artikels == null) {
      return [];
    }
    List<dynamic> listOfData = json.decode(artikels.body) as List<dynamic>;
    if (listOfData.isEmpty) {
      return [];
    }
    return listOfData.map((rawBlog) {
      return Article.fromJson(rawBlog);
    }).toList();
  }
}
