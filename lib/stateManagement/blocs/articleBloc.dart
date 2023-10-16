import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jendela_dbp/api-services.dart';
import 'package:jendela_dbp/hive/models/hiveArticleModel.dart';
import 'package:jendela_dbp/stateManagement/events/articleEvent.dart';
import 'package:jendela_dbp/stateManagement/states/articleState.dart';

class ArticleBloc extends Bloc<ArticleEvent, ArticleState> {
  ArticleBloc() : super(ArticleInit());
  int _pageCount = 1;

  @override
  Stream<ArticleState> mapEventToState(ArticleEvent event) async* {
    if (event is ArticleInit) {
      _pageCount = 1;
      if (await hasCachedArticles()) {
        final cachedArticles = await loadCachedArticles();
        yield ArticleLoaded(listOfArticle: cachedArticles);
      }
    }

    if (event is ArticleFetch) {
      yield ArticleLoading();
      _pageCount = 1;
      try {
        List<Article> listOfArticle = await fetchArticle();
        yield ArticleLoaded(listOfArticle: listOfArticle);
        await cacheArticles(listOfArticle);
      } catch (e) {
        yield ArticleError(message: e.toString());
      }
    }

    if (event is ArticleFetchMore) {
      try {
        List<Article> respData = await fetchArticle(page: _pageCount + 1, perPage: event.perPage);
        if (respData.length > 0) {
          _pageCount++;
        }
        List<Article> combinedList = [];
        combinedList.addAll(state.listOfArtikel ?? []);
        combinedList.addAll(respData);
        yield ArticleLoading();
        yield ArticleLoaded(listOfArticle: combinedList);
        await cacheArticles(combinedList);
      } catch (err) {
        yield ArticleError(message: err.toString());
      }
    }
  }

  Future<void> cacheArticles(List<Article> articles) async {
    final prefs = await SharedPreferences.getInstance();
    final encodedData = jsonEncode(articles.map((article) => article.toJson()).toList());
    await prefs.setString('cached_articles', encodedData);
    await prefs.setInt('cached_articles_timestamp', DateTime.now().millisecondsSinceEpoch);
  }

  Future<List<Article>?> loadCachedArticles() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString('cached_articles');
    if (cachedData != null) {
      return (jsonDecode(cachedData) as List<dynamic>).map((rawBlog) {
        return Article.fromJson(rawBlog);
      }).toList();
    }
    return null;
  }

  Future<bool> hasCachedArticles() async {
    final prefs = await SharedPreferences.getInstance();
    final timestamp = prefs.getInt('cached_articles_timestamp');
    if (timestamp != null) {
      final currentTime = DateTime.now().millisecondsSinceEpoch;
      final difference = currentTime - timestamp;
      return difference <= 7 * 24 * 60 * 60 * 1000; // 1 week in milliseconds
    }
    return false;
  }

  Future<List<Article>> fetchArticle({int perPage = 25, int page = 1}) async {
    dynamic articles = await ApiService.getArticle(
        '', {"per_page": perPage.toString(), "page": page.toString()});
    if (articles == null) {
      return [];
    }
    List<dynamic> listOfData = json.decode(articles.body) as List<dynamic>;
    if (listOfData.length == 0) {
      return [];
    }
    return listOfData.map((rawBlog) {
      return Article.fromJson(rawBlog);
    }).toList();
  }
}
