import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:jendela_dbp/api-services.dart';
import 'package:jendela_dbp/hive/models/hivePostModel.dart';
import 'package:jendela_dbp/stateManagement/events/postEvent.dart';
import 'package:jendela_dbp/stateManagement/states/postState.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  // News Bloc
  int _pageCount = 1;

  PostBloc() : super(PostInit()) {
    on<PostFetch>((event, emit) async {
      _pageCount = 1;
      emit(PostLoading());
      try {
        List<Post> listOfPost = await fetchPostFromCacheOrApi();
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

  Future<List<Post>> fetchPostFromCacheOrApi() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString('posts_cache');
    final cachedTimestamp = prefs.getInt('posts_cache_timestamp');

    if (cachedData != null && cachedTimestamp != null) {
      final currentTime = DateTime.now().millisecondsSinceEpoch;
      const maxCacheAge = 86400000; // 1 day in milliseconds

      if (currentTime - cachedTimestamp <= maxCacheAge) {
        // Data is still valid, parse and return it
        List<dynamic> listOfData = json.decode(cachedData) as List<dynamic>;
        return listOfData.map((rawBlog) {
          return Post.fromJsonCache(rawBlog);
        }).toList();
      }
    }

    // If cached data is expired or not available, fetch from API and cache it
    List<Post> listOfPost = await fetchPost();

    // Store the new data and current timestamp in SharedPreferences
    prefs.setString('posts_cache', json.encode(listOfPost));
    prefs.setInt(
        'posts_cache_timestamp', DateTime.now().millisecondsSinceEpoch);

    return listOfPost;
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
