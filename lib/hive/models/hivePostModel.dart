import 'package:hive/hive.dart';

part '../adapters/hivePostModel.g.dart';

@HiveType(typeId: 4)
class Post {
  Post({
    this.author,
    this.commentStatus,
    this.date,
    this.dateGmt,
    this.featuredMedia,
    this.format,
    this.id,
    this.link,
    this.modified,
    this.modifiedGmt,
    this.pingStatus,
    this.slug,
    this.status,
    this.type,
    this.yoastHead,
    this.title,
    this.featuredMediaUrls,
    this.content,
  });
  @HiveField(0)
  int? author;
  @HiveField(1)
  String? commentStatus;
  @HiveField(2)
  String? date;
  @HiveField(3)
  String? dateGmt;
  @HiveField(4)
  int? featuredMedia;
  @HiveField(5)
  String? format;
  @HiveField(6)
  int? id;
  @HiveField(7)
  String? link;
  @HiveField(8)
  String? modified;
  @HiveField(9)
  String? modifiedGmt;
  @HiveField(10)
  String? pingStatus;
  @HiveField(11)
  String? slug;
  @HiveField(12)
  String? status;
  @HiveField(13)
  String? type;
  @HiveField(14)
  String? yoastHead;
  @HiveField(15)
  String? title;
  @HiveField(16)
  String? featuredMediaUrls;
  @HiveField(17)
  String? content;

  static Post fromJson(Map jsonString) {
    return Post(
      author: jsonString['author'],
      commentStatus: jsonString['comment_status'],
      date: jsonString['date'],
      dateGmt: jsonString['date_gmt'],
      featuredMedia: jsonString['featured_media'],
      format: jsonString['format'],
      id: jsonString['id'],
      link: jsonString['link'],
      modified: jsonString['modified'],
      modifiedGmt: jsonString['modified_gmt'],
      pingStatus: jsonString['ping_status'],
      slug: jsonString['slug'],
      status: jsonString['status'],
      type: jsonString['type'],
      yoastHead: jsonString['yoast_head'],
      title: jsonString['title']['rendered'],
      featuredMediaUrls: jsonString['featured_media_urls']['post-thumbnail'],
      content: jsonString['content']['rendered'],
    );
  }

  static Post fromJsonCache(Map jsonString) {
    return Post(
      author: jsonString['author'],
      commentStatus: jsonString['comment_status'],
      date: jsonString['date'],
      dateGmt: jsonString['date_gmt'],
      featuredMedia: jsonString['featured_media'],
      format: jsonString['format'],
      id: jsonString['id'],
      link: jsonString['link'],
      modified: jsonString['modified'],
      modifiedGmt: jsonString['modified_gmt'],
      pingStatus: jsonString['ping_status'],
      slug: jsonString['slug'],
      status: jsonString['status'],
      type: jsonString['type'],
      yoastHead: jsonString['yoast_head'],
      title: jsonString['title'],
      featuredMediaUrls: jsonString['featured_media_urls'],
      content: jsonString['content'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'author': author,
      'comment_status': commentStatus,
      'date': date,
      'date_gmt': dateGmt,
      'featured_media': featuredMedia,
      'format': format,
      'id': id,
      'link': link,
      'modified': modified,
      'modified_gmt': modifiedGmt,
      'ping_status': pingStatus,
      'slug': slug,
      'status': status,
      'type': type,
      'yoast_head': yoastHead,
      'title': title,
      'featured_media_urls': featuredMediaUrls,
      'content': content,
    };
  }
}
