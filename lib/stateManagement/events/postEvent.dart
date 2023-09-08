import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'package:jendela_dbp/hive/models/hivePostModel.dart';

@immutable
abstract class PostEvent extends Equatable {
  List<Post>? listOfPost;
  String? token;
}

class PostFetch extends PostEvent {
  final int perPage;
  final int page;
  final List<Post>? listOfPost;
  final String? token;

  PostFetch(
      {this.listOfPost, this.token, this.perPage = 25, this.page = 1});

  @override
  String toString() => 'Fetch';
  @override
  List<Object> get props => [listOfPost ?? []];
}

class PostFetchMore extends PostEvent {
  final int perPage;
  final List<Post>? listOfPost;
  final String? token;

  PostFetchMore({this.listOfPost, this.token, this.perPage = 25});

  @override
  String toString() => 'FetchMore';
  @override
  List<Object> get props => [listOfPost ?? []];
}
