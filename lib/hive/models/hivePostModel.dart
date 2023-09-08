import 'package:hive/hive.dart';

part '../adapters/hivePostModel.g.dart';

@HiveType(typeId: 4)
class Post {
  Post(
      {this.author,
      this.comment_status,
      this.date,
      this.date_gmt,
      this.featured_media,
      this.format,
      this.id,
      this.link,
      this.modified,
      this.modified_gmt,
      this.ping_status,
      this.slug,
      this.status,
      this.sticky,
      this.type,
      this.yoast_head,
      this.title,
      this.featured_media_urls,
      this.content});
  @HiveField(0)
  int? author;
  @HiveField(1)
  String? comment_status;
  @HiveField(2)
  String? date;
  @HiveField(3)
  String? date_gmt;
  @HiveField(4)
  int? featured_media;
  @HiveField(5)
  String? format;
  @HiveField(6)
  int? id;
  @HiveField(7)
  String? link;
  @HiveField(8)
  String? modified;
  @HiveField(9)
  String? modified_gmt;
  @HiveField(10)
  String? ping_status;
  @HiveField(11)
  String? slug;
  @HiveField(12)
  String? status;
  @HiveField(13)
  String? sticky;
  @HiveField(14)
  String? type;
  @HiveField(15)
  String? yoast_head;
  @HiveField(16)
  String? title;
  @HiveField(17)
  String? featured_media_urls;
  @HiveField(18)
  String? content;

  static Post fromJson(Map jsonString) {
    return Post(
      author: jsonString['author'],
      comment_status: jsonString['comment_status'],
      date: jsonString['date'],
      date_gmt: jsonString['date_gmt'],
      featured_media: jsonString['featured_media'],
      format: jsonString['format'],
      id: jsonString['id'],
      link: jsonString['link'],
      modified: jsonString['modified'],
      modified_gmt: jsonString['modified_gmt'],
      ping_status: jsonString['ping_status'],
      slug: jsonString['slug'],
      status: jsonString['status'],
      sticky: jsonString['pinged'],
      type: jsonString['type'],
      yoast_head: jsonString['yoast_head'],
      title: jsonString['title']['rendered'],
      featured_media_urls: jsonString['featured_media_urls']['post-thumbnail'],
      content: jsonString['content']['rendered']
    );
  }
}
