import 'package:hive/hive.dart';

part '../adapters/hive_berita_model.g.dart';

@HiveType(typeId: 5)
class Berita {
  Berita(
      {this.blogId,
      this.id,
      this.postAuthor,
      this.postDate,
      this.postDateGmt,
      this.postContent,
      this.postTitle,
      this.postExcerpt,
      this.postStatus,
      this.commentStatus,
      this.pingStatus,
      this.postPassword,
      this.postName,
      this.toPing,
      this.pinged,
      this.postModified,
      this.postModifiedGmt,
      this.postContentFiltered,
      this.postParent,
      this.guid,
      this.menuOrder,
      this.postType,
      this.postMimeType,
      this.commentCount,
      this.filter,
      this.featuredImage,
      this.hitScore,
      this.edbpYoutubeUrl,
      this.edbpVideoSnippetUrl,
      this.edbpLiveStatus,
      this.categories,
      this.tags,
      this.featuredImage2});
  @HiveField(0)
  String? blogId;
  @HiveField(1)
  int? id;
  @HiveField(2)
  String? postAuthor;
  @HiveField(3)
  String? postDate;
  @HiveField(4)
  String? postDateGmt;
  @HiveField(5)
  String? postContent;
  @HiveField(6)
  String? postTitle;
  @HiveField(7)
  String? postExcerpt;
  @HiveField(8)
  String? postStatus;
  @HiveField(9)
  String? commentStatus;
  @HiveField(10)
  String? pingStatus;
  @HiveField(11)
  String? postPassword;
  @HiveField(12)
  String? postName;
  @HiveField(13)
  String? toPing;
  @HiveField(14)
  String? pinged;
  @HiveField(15)
  String? postModified;
  @HiveField(16)
  String? postModifiedGmt;
  @HiveField(17)
  String? postContentFiltered;
  @HiveField(18)
  int? postParent;
  @HiveField(19)
  String? guid;
  @HiveField(20)
  int? menuOrder;
  @HiveField(21)
  String? postType;
  @HiveField(22)
  String? postMimeType;
  @HiveField(23)
  String? commentCount;
  @HiveField(24)
  String? filter;
  @HiveField(25)
  String? featuredImage;
  @HiveField(26)
  int? hitScore;
  @HiveField(27)
  String? edbpYoutubeUrl;
  @HiveField(28)
  String? edbpVideoSnippetUrl;
  @HiveField(29)
  String? edbpLiveStatus;
  @HiveField(30)
  List<dynamic>? categories;
  @HiveField(31)
  List<dynamic>? tags;
  @HiveField(32)
  String? featuredImage2;

  static Berita fromJson(Map jsonString) {
    return Berita(
        blogId: jsonString['BLOG_ID'],
        id: jsonString['ID'],
        postAuthor: jsonString['post_author'],
        postDate: jsonString['post_date'],
        postDateGmt: jsonString['post_date_gmt'],
        postContent: jsonString['post_content'],
        postTitle: jsonString['post_title'],
        postExcerpt: jsonString['post_excerpt'],
        postStatus: jsonString['post_status'],
        commentStatus: jsonString['comment_status'],
        pingStatus: jsonString['ping_status'],
        postPassword: jsonString['post_password'],
        postName: jsonString['post_name'],
        toPing: jsonString['to_ping'],
        pinged: jsonString['pinged'],
        postModified: jsonString['post_modified'],
        postModifiedGmt: jsonString['post_modified_gmt'],
        postContentFiltered: jsonString['post_content_filtered'],
        postParent: jsonString['post_parent'],
        guid: jsonString['guid'],
        menuOrder: jsonString['menu_order'],
        postType: jsonString['post_type'],
        postMimeType: jsonString['post_mime_type'],
        commentCount: jsonString['comment_count'],
        filter: jsonString['filter'],
        featuredImage: jsonString['featured_image'] == false
            ? null
            : jsonString['featured_image'],
        hitScore: jsonString['hit_score'],
        edbpYoutubeUrl: jsonString['edbp_youtube_url'],
        edbpVideoSnippetUrl: jsonString['edbp_video_snippet_url'],
        edbpLiveStatus: jsonString['edbp_live_status'],
        categories: jsonString['categories'],
        tags: jsonString['tags'],
        featuredImage2: jsonString['featured_image_2'] == ""
            ? null
            : jsonString['featured_image_2']);
  }
}
