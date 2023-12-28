// ignore_for_file: must_be_immutable, overridden_fields

import 'package:equatable/equatable.dart';
import 'package:jendela_dbp/hive/models/hive_article_model.dart';

abstract class ArticleState extends Equatable {
  ArticleState();
  List<Article>? listOfArticle;
  Article? artikel;

  ArticleLoaded copyWith({List<Article>? listOfArticle, Article? article}) {
    return ArticleLoaded(
      listOfArticle: listOfArticle ?? this.listOfArticle,
      article: article ?? artikel,
    );
  }
}

class ArticleLoaded extends ArticleState {
  @override
  List props = [];
  @override
  final List<Article>? listOfArticle;
  final Article? article;

  ArticleLoaded({this.listOfArticle, this.article}) : super();

  @override
  ArticleLoaded copyWith({List<Article>? listOfArticle, Article? article}) {
    return ArticleLoaded(
      listOfArticle: listOfArticle ?? this.listOfArticle,
      article: article ?? this.article,
    );
  }

  @override
  String toString() =>
      'PostLoaded { artikel: ${article.toString()}, listOfArtikel: ${listOfArticle.toString()} }';
}

class ArticleInit extends ArticleState {
  @override
  List props = [];
}

class ArticleLoading extends ArticleState {
  @override
  List props = [];
}

class ArticleError extends ArticleState {
  @override
  List props = [];
  String? message;
  ArticleError({this.message});
}
