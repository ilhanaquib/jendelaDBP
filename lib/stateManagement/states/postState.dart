import 'package:equatable/equatable.dart';

import 'package:jendela_dbp/hive/models/hivePostModel.dart';

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

class PostLoaded extends PostState {
  List props = [];
  final List<Post>? listOfPost;
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

class PostInit extends PostState {
  List props = [];
}

class PostLoading extends PostState {
  List props = [];
}

class PostError extends PostState {
  List props = [];
  String? message;
  PostError({this.message});
}
