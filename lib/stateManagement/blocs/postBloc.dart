import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:jendela_dbp/api-services.dart';
import 'package:jendela_dbp/hive/models/hivePostModel.dart';
import 'package:jendela_dbp/stateManagement/events/postEvent.dart';
import 'package:jendela_dbp/stateManagement/states/postState.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  // News Bloc
  int _pageCount = 1;

  PostBloc() : super(PostInit()) {
    on<PostFetch>((event, emit) async {
      _pageCount = 1;
      emit(PostLoading());
      try {
        List<Post> listOfPost = await fetchPost();
        emit(PostLoaded(listOfPost: listOfPost));
      } catch (e) {
        emit(PostError(message: e.toString()));
      }
    });

    on<PostFetchMore>((event, emit) async {
      try {
        List<Post> respData =
            await fetchPost(page: _pageCount + 1, perPage: event.perPage);
        if (respData.length > 0) {
          _pageCount++;
        }
        List<Post> combinedList = [];
        combinedList.addAll(state.listOfPost ?? []);
        combinedList.addAll(respData);
        emit(PostLoading());
        emit(PostLoaded(listOfPost: combinedList));
      } catch (err) {
        emit(PostError(message: err.toString()));
      }
    });
  }
}

Future<List<Post>> fetchPost({int perPage = 25, int page = 1}) async {
  dynamic posts = await ApiService.getPosts(
      '', {"per_page": perPage.toString(), "page": page.toString()});
  if (posts == null) {
    return [];
  }
  List<dynamic> listOfData = json.decode(posts.body) as List<dynamic>;
  if (listOfData.length == 0) {
    return [];
  }
  return listOfData.map((rawBlog) {
    return Post.fromJson(rawBlog);
  }).toList();
}
