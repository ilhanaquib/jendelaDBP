import 'package:equatable/equatable.dart';
import 'package:jendela_dbp/hive/models/hive_article_model.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ArticleEvent extends Equatable {}

class ArticleFetch extends ArticleEvent {
  final List<Article>? listOfArticle;
  final int perPage;
  final int page;
  ArticleFetch({this.listOfArticle, this.perPage = 25, this.page = 1});
  @override
  String toString() => 'Fetch';
  @override
  List<Object> get props => [listOfArticle ?? [], perPage, page];
}

class ArticleFetchMore extends ArticleEvent {
  final List<Article>? listOfArticle;
  final int perPage;
  ArticleFetchMore({this.listOfArticle, this.perPage = 25});
  @override
  String toString() => 'FetchMore';
  @override
  List<Object> get props => [listOfArticle ?? []];
}
