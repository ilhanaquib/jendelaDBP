// ignore_for_file: overridden_fields, annotate_overrides, must_be_immutable

import 'package:equatable/equatable.dart';
import 'package:jendela_dbp/hive/models/hive_article_model.dart';

abstract class ArticleEvent extends Equatable {
  List<Article>? listOfArticle;
  String? token;
}
      
class ArticleFetch extends ArticleEvent {
  final int perPage;
  final int page;
  final List<Article>? listOfArticle;
  final String? token;

  ArticleFetch(
      {this.listOfArticle, this.token, this.perPage = 25, this.page = 1});

  @override
  String toString() => 'Fetch';
  @override
  List<Object> get props => [listOfArticle ?? []];
}

class ArticleFetchMore extends ArticleEvent {
  final int perPage;
  final List<Article>? listOfArticle;
  final String? token;

  ArticleFetchMore({this.listOfArticle, this.token, this.perPage = 25});

  @override
  String toString() => 'FetchMore';
  @override
  List<Object> get props => [listOfArticle ?? []];
}
