import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:jendela_dbp/controllers/global_var.dart';

part '../adapters/hive_tv_category_model.g.dart';

@HiveType(typeId: 14)
class TvCategory {
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

  TvCategory({
    this.id,
    this.count,
    this.description,
    this.name,
    this.taxonomy,
    this.slug,
    this.link,
    this.links,
  }) : super();

  static TvCategory fromJson(Map<String, dynamic> jsonString) {
    Map<String, dynamic> tvCategory = jsonString;
    return TvCategory(
      id: tvCategory['id'],
      count: tvCategory['count'],
      description: tvCategory['description'],
      name: tvCategory['name'],
      taxonomy: tvCategory['taxonomy'],
      slug: tvCategory['slug'],
      link: tvCategory['link'],
      links: tvCategory['_links'],
    );
  }

  /// Get video categories data.
  static Future<TvCategory?> fetchById(int id) async {
    // ignore: unused_local_variable
    TvCategory tvCategory;
    var response = await http.get(Uri.https(
        GlobalVar.baseURLDomain, 'wp-json/wp/v2/video_category/$id'));
    if (response.statusCode == 200) {
      Map<String, dynamic> data =
          json.decode(response.body) as Map<String, dynamic>;
      tvCategory = TvCategory.fromJson(data);
    }
      return null;
  }
}
