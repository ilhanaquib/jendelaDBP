import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'package:jendela_dbp/hive/models/hivePostModel.dart';

// ignore: must_be_immutable
@immutable
abstract class PostEvent extends Equatable {
  List<Post>? listOfPost;
  String? token;
}

// ignore: must_be_immutable
class PostFetch extends PostEvent {
  final int perPage;
  final int page;
  @override
  // ignore: overridden_fields
  final List<Post>? listOfPost;
  @override
  // ignore: overridden_fields
  final String? token;

  PostFetch(
      {this.listOfPost, this.token, this.perPage = 25, this.page = 1});

  @override
  String toString() => 'Fetch';
  @override
  List<Object> get props => [listOfPost ?? []];
}

// ignore: must_be_immutable
class PostFetchMore extends PostEvent {
  final int perPage;
  @override
  // ignore: overridden_fields
  final List<Post>? listOfPost;
  @override
  // ignore: overridden_fields
  final String? token;

  PostFetchMore({this.listOfPost, this.token, this.perPage = 25});

  @override
  String toString() => 'FetchMore';
  @override
  List<Object> get props => [listOfPost ?? []];
}
