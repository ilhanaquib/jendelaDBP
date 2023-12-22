import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:jendela_dbp/controllers/global_var.dart';
import 'package:jendela_dbp/hive/models/hive_media_model.dart';
import 'package:jendela_dbp/hive/models/hive_radio_category_model.dart';
import 'package:jendela_dbp/hive/models/hive_tv_model.dart';

part '../adapters/hive_radio_model.g.dart';

@HiveType(typeId: 12)
class Radio {
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
  List<dynamic>? radioCategory;
  @HiveField(12)
  List? videoTag;
  @HiveField(13)
  Map? links;
  @HiveField(14)
  List<RadioCategory>? radioCategories;
  @HiveField(15)
  YoutubeMeta? meta;

  Radio(
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
      this.radioCategory,
      this.radioCategories,
      this.videoTag,
      this.links,
      this.meta})
      : super();

  static Radio fromJson(Map<String, dynamic> jsonString) {
    Map<String, dynamic> radio = jsonString;
    return Radio(
        id: radio['id'],
        date: radio['date'] == null ? null : DateTime.parse(radio['date']),
        guid: radio['guid'],
        modified: radio['modified'] == null
            ? null
            : DateTime.parse(radio['modified']),
        slug: radio['slug'],
        status: radio['status'],
        type: radio['type'],
        link: radio['link'],
        title: radio['title'],
        content: radio['content'],
        featuredMedia: radio['featured_media'],
        radioCategory: radio['video_category'],
        videoTag: radio['video_tag'],
        links: radio['_links'],
        meta: YoutubeMeta.fromJson(radio['meta']));
  }

  Future<Media?> getFeaturedMedia() async {
    String tempMediaLink = links!['wp:featuredmedia'][0]['href'];
    var response = await http.get(Uri.parse(tempMediaLink));
    if (response.statusCode != 200) {
      return null;
    }
    Map<String, dynamic> body = jsonDecode(response.body);
    return Media.fromJson(body);
  }

  Future<List<Radio>?> fetchRadio(int startIndex, int perPage,
      {int? category}) async {
    Map<String, dynamic> queryParameters = {
      "page": startIndex.toString(),
      "per_page": perPage.toString(),
      "status": "publish",
      "categories": category != null ? category.toString() : ""
    };
    final response = await http.get(Uri.https(
        GlobalVar.baseURLDomain, 'wp-json/wp/v2/radios', queryParameters));
    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;
      return data.map((rawVideo) {
        return Radio.fromJson(rawVideo);
      }).toList();
    } else {
      return null;
    }
  }

  /// Get radio categories data.
  Future<List<RadioCategory>> fetchRadioCategories() async {
    List<RadioCategory> tempData = [];
    if (radioCategories != null) {
      for (int i = 0; i < radioCategories!.length; i++) {
        var radioCategoryId = radioCategories![i];
        var response = await http.get(Uri.https(GlobalVar.baseURLDomain,
            'wp-json/wp/v2/radio_category/$radioCategoryId'));
        if (response.statusCode == 200) {
          Map<String, dynamic> data =
              json.decode(response.body) as Map<String, dynamic>;
          tempData.add(RadioCategory.fromJson(data));
        }
      }
    }
    return tempData;
  }
}
