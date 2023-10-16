import 'package:equatable/equatable.dart';
import 'package:jendela_dbp/hive/models/hiveArticleModel.dart';

abstract class ArticleState extends Equatable {
  ArticleState();
  List<Article>? listOfArtikel;
  Article? article;

  ArticleLoaded copyWith({List<Article>? listOfArticle, Article? article}) {
    return ArticleLoaded(
      listOfArticle: listOfArticle ?? this.listOfArtikel,
      article: article ?? this.article,
    );
  }
}

class ArticleLoaded extends ArticleState {
  List props = [];
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
      'ArticleLoaded { article: ${article.toString()}, listOfArticle: ${listOfArticle.toString()} }';
}

class ArticleInit extends ArticleState {
  List props = [];
}

class ArticleLoading extends ArticleState {
  List props = [];
}

class ArticleError extends ArticleState {
  List props = [];
  String? message;
  ArticleError({this.message});
}
