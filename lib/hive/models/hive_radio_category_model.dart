import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:jendela_dbp/controllers/global_var.dart';

part '../adapters/hive_radio_category_model.g.dart';

@HiveType(typeId: 11)
class RadioCategory {
  @HiveField(0)
  int? id;
  @HiveField(1)
  int? count;
  @HiveField(2)
  String? description;
  @HiveField(3)
  String? name;
  @HiveField(4)
  String? taxonomy;
  @HiveField(5)
  String? slug;
  @HiveField(6)
  String? link;
  @HiveField(7)
  Map? links;

  RadioCategory({
    this.id,
    this.count,
    this.description,
    this.name,
    this.taxonomy,
    this.slug,
    this.link,
    this.links,
  }) : super();

  static RadioCategory fromJson(Map<String, dynamic> jsonString) {
    Map<String, dynamic> videoCategory = jsonString;
    return RadioCategory(
      id: videoCategory['id'],
      count: videoCategory['count'],
      description: videoCategory['description'],
      name: videoCategory['name'],
      taxonomy: videoCategory['taxonomy'],
      slug: videoCategory['slug'],
      link: videoCategory['link'],
      links: videoCategory['_links'],
    );
  }

  /// Get video categories data.
  static Future<RadioCategory?> fetchById(int id) async {
    RadioCategory? videoCategory;
    var response = await http.get(Uri.https(
        GlobalVar.baseURLDomain, 'wp-json/wp/v2/video_category/$id'));
    if (response.statusCode == 200) {
      Map<String, dynamic> data =
          json.decode(response.body) as Map<String, dynamic>;
      videoCategory = RadioCategory.fromJson(data);
    }
      return videoCategory;
  }
}
