import 'package:equatable/equatable.dart';
import 'package:jendela_dbp/hive/models/hive_article_model.dart';

// ignore: must_be_immutable
abstract class ArticleState extends Equatable {
  ArticleState();
  List<Article>? listOfArtikel;
  Article? article;

  ArticleLoaded copyWith({List<Article>? listOfArticle, Article? article}) {
    return ArticleLoaded(
      listOfArticle: listOfArticle ?? listOfArtikel,
      article: article ?? this.article,
    );
  }
}

// ignore: must_be_immutable
class ArticleLoaded extends ArticleState {
  @override
  List props = [];
  final List<Article>? listOfArticle;
  @override
  // ignore: overridden_fields
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
      'ArticleLoaded { article: ${article.toString()}, listOfArticle: ${listOfArticle.toString()} }';
}

// ignore: must_be_immutable
class ArticleInit extends ArticleState {
  @override
  List props = [];
}

// ignore: must_be_immutable
class ArticleLoading extends ArticleState {
  @override
  List props = [];
}

// ignore: must_be_immutable
class ArticleError extends ArticleState {
  @override
  List props = [];
  String? message;
  ArticleError({this.message});
}
