import 'package:equatable/equatable.dart';

import 'package:jendela_dbp/hive/models/hivePostModel.dart';

// ignore: must_be_immutable
abstract class PostState extends Equatable {
  PostState();
  List<Post>? listOfPost;
  Post? post;

  PostLoaded copyWith({List<Post>? listOfPost, Post? post}) {
    return PostLoaded(
      listOfPost: listOfPost ?? this.listOfPost,
      post: post ?? this.post,
    );
  }
}

// ignore: must_be_immutable
class PostLoaded extends PostState {
  @override
  List props = [];
  @override
  // ignore: overridden_fields
  final List<Post>? listOfPost;
  @override
  // ignore: overridden_fields
  final Post? post;

  PostLoaded({this.listOfPost, this.post}) : super();

  @override
  PostLoaded copyWith({List<Post>? listOfPost, Post? post}) {
    return PostLoaded(
      listOfPost: listOfPost ?? this.listOfPost,
      post: post ?? this.post,
    );
  }

  @override
  String toString() =>
      'PostLoaded { post: ${post.toString()}, listOfPost: ${listOfPost.toString()} }';
}

// ignore: must_be_immutable
class PostInit extends PostState {
  @override
  List props = [];
}

// ignore: must_be_immutable
class PostLoading extends PostState {
  @override
  List props = [];
}

// ignore: must_be_immutable
class PostError extends PostState {
  @override
  List props = [];
  String? message;
  PostError({this.message});
}
