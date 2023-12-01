import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:jendela_dbp/api_services.dart';
import 'package:jendela_dbp/hive/models/hivePostModel.dart';
import 'package:jendela_dbp/stateManagement/events/post_event.dart';
import 'package:jendela_dbp/stateManagement/states/post_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewPostBloc extends Bloc<PostEvent, PostState> {
  NewPostBloc() : super(PostInit());
  int _pageCount = 1;

  @override
  Stream<PostState> mapEventToState(PostEvent event) async* {
    if (event is PostInit) {
      _pageCount = 1;
      if (await hasCachedPosts()) {
        final cachedPosts = await loadCachedPosts();
        yield PostLoaded(listOfPost: cachedPosts);
      }
    }

    if (event is PostFetch) {
      yield PostLoading();
      _pageCount = 1;
      try {
        List<Post> listOfPost = await fetchPost();
        yield PostLoaded(listOfPost: listOfPost);
        await cachePosts(listOfPost);
      } catch (e) {
        yield PostError(message: e.toString());
      }
    }

    if (event is PostFetchMore) {
      try {
        List<Post> respData =
            await fetchPost(page: _pageCount + 1, perPage: event.perPage);
        if (respData.isNotEmpty) {
          _pageCount++;
        }
        List<Post> combinedList = [];
        combinedList.addAll(state.listOfPost ?? []);
        combinedList.addAll(respData);
        yield PostLoading();
        yield PostLoaded(listOfPost: combinedList);
        await cachePosts(combinedList);
      } catch (err) {
        yield PostError(message: err.toString());
      }
    }
  }

  Future<void> cachePosts(List<Post> posts) async {
    final prefs = await SharedPreferences.getInstance();
    final encodedData =
        jsonEncode(posts.map((posts) => posts.toJson()).toList());
    await prefs.setString('cached_posts', encodedData);
    await prefs.setInt(
        'cached_posts_timestamp', DateTime.now().millisecondsSinceEpoch);
  }

  Future<List<Post>?> loadCachedPosts() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString('cached_posts');
    if (cachedData != null) {
      return (jsonDecode(cachedData) as List<dynamic>).map((rawBlog) {
        return Post.fromJson(rawBlog);
      }).toList();
    }
    return null;
  }

  Future<bool> hasCachedPosts() async {
    final prefs = await SharedPreferences.getInstance();
    final timestamp = prefs.getInt('cached_posts_timestamp');
    if (timestamp != null) {
      final currentTime = DateTime.now().millisecondsSinceEpoch;
      final difference = currentTime - timestamp;
      return difference <= 7 * 24 * 60 * 60 * 1000; // 1 week in milliseconds
    }
    return false;
  }

  Future<List<Post>> fetchPost({int perPage = 25, int page = 1}) async {
    dynamic posts = await ApiService.getPosts(
        '', {"per_page": perPage.toString(), "page": page.toString()});
    if (posts == null) {
      return [];
    }
    List<dynamic> listOfData = json.decode(posts.body) as List<dynamic>;
    if (listOfData.isEmpty) {
      return [];
    }
    return listOfData.map((rawBlog) {
      return Post.fromJson(rawBlog);
    }).toList();
  }
}
