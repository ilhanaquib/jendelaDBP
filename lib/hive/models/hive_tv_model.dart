import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:jendela_dbp/controllers/global_var.dart';
import 'package:jendela_dbp/hive/models/hive_media_model.dart';
import 'package:jendela_dbp/hive/models/hive_tv_category_model.dart';

part '../adapters/hive_tv_model.g.dart';

@HiveType(typeId: 15)
class Tv {
  @HiveField(0)
  int? id;
  @HiveField(1)
  DateTime? date;
  @HiveField(2)
  Map? guid;
  @HiveField(3)
  DateTime? modified;
  @HiveField(4)
  String? slug;
  @HiveField(5)
  String? status;
  @HiveField(6)
  String? type;
  @HiveField(7)
  String? link;
  @HiveField(8)
  Map? title;
  @HiveField(9)
  Map? content;
  @HiveField(10)
  int? featuredMedia;
  @HiveField(11)
  List<dynamic>? tvCategory;
  @HiveField(12)
  List? videoTag;
  @HiveField(13)
  Map? links;
  @HiveField(14)
  List<TvCategory>? tvCategories;
  @HiveField(15)
  YoutubeMeta? meta;
  @HiveField(16)
  dynamic featuredMediaUrls;

  Tv(
      {this.id,
      this.date,
      this.guid,
      this.modified,
      this.slug,
      this.status,
      this.type,
      this.link,
      this.title,
      this.content,
      this.featuredMedia,
      this.tvCategory,
      this.tvCategories,
      this.videoTag,
      this.links,
      this.meta,
      this.featuredMediaUrls})
      : super();

  static Tv fromJson(Map<String, dynamic> jsonString) {
    Map<String, dynamic> tv = jsonString;
    return Tv(
        id: tv['id'],
        date: tv['date'] == null ? null : DateTime.parse(tv['date']),
        guid: tv['guid'],
        modified:
            tv['modified'] == null ? null : DateTime.parse(tv['modified']),
        slug: tv['slug'],
        status: tv['status'],
        type: tv['type'],
        link: tv['link'],
        title: tv['title'],
        content: tv['content'],
        featuredMedia: tv['featured_media'],
        tvCategory: tv['video_category'],
        videoTag: tv['video_tag'],
        links: tv['_links'],
        meta: YoutubeMeta.fromJson(tv['meta']),
        featuredMediaUrls: tv['featured_media_urls']);
  }

  // Future<List<Blog>> fetch() async {
  //   List<dynamic> data = await super.fetch();
  //   List<Blog> blogs;
  //   int i = 0;
  //   data.forEach((element) {
  //     blogs.add(Blog.fromJson(element));
  //     i++;
  //   });
  //   return blogs;
  // }

  Future<Media?> getFeaturedMedia() async {
    // http request

    String tempMediaLink = links!['wp:featuredmedia'][0]['href'];
    var response = await http.get(Uri.parse(tempMediaLink));
    if (response.statusCode != 200) {
      return null;
    }
    Map<String, dynamic> body = jsonDecode(response.body);
    return Media.fromJson(body);
  }

  Future<List<Tv>?> fetchVideo(int startIndex, int perPage,
      {int? category}) async {
    Map<String, dynamic> queryParamiters = {
      "page": startIndex.toString(),
      "per_page": perPage.toString(),
      "status": "publish",
      "categories": category != null ? category.toString() : ""
    };
    final response = await http.get(Uri.https(
        GlobalVar.baseURLDomain, 'wp-json/wp/v2/videos', queryParamiters));
    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;
      return data.map((rawVideo) {
        return Tv.fromJson(rawVideo);
      }).toList();
    } else {
      return null;
    }
  }

  /// Get video categories data.
  Future<List<TvCategory>?> fetchTvCategories() async {
    List<TvCategory> tempData = [];
    if (tvCategories != null) {
      for (int i = 0; i < tvCategory!.length; i++) {
        var tvCategoryId = tvCategory![i];
        var response = await http.get(Uri.https(GlobalVar.baseURLDomain,
            'wp-json/wp/v2/video_category/$tvCategoryId'));
        if (response.statusCode == 200) {
          Map<String, dynamic> data =
              json.decode(response.body) as Map<String, dynamic>;
          tempData.add(TvCategory.fromJson(data));
        }
      }
    }
    return tempData;
  }
}

@HiveType(typeId: 16)
class YoutubeMeta {
  YoutubeMeta(
      {this.hitScore,
      this.edbpLiveStatus,
      this.edbpVideoSnippetUrl,
      this.edbpYoutubeUrl});

  @HiveField(0)
  int? hitScore;
  @HiveField(1)
  String? edbpYoutubeUrl;
  @HiveField(2)
  String? edbpVideoSnippetUrl;
  @HiveField(3)
  bool? edbpLiveStatus;

  static YoutubeMeta? fromJson(Map data) {
    try {
      return YoutubeMeta(
          hitScore: data['hit_score'],
          edbpLiveStatus: data['edbp_live_status'],
          edbpVideoSnippetUrl: data['edbp_video_snippet_url'],
          edbpYoutubeUrl: data['edbp_youtube_url']);
    } catch (e) {
      return null;
    }
  }
}
