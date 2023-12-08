import 'package:hive/hive.dart';

part '../adapters/hive_article_model.g.dart';

@HiveType(typeId: 4)
class Article {
  Article(
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

  static Article fromJson(Map jsonString) {
    return Article(
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
        featuredImage: jsonString['featured_image'] is String
            ? jsonString['featured_image']
            : null,
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['BLOG_ID'] = blogId;
    data['ID'] = id;
    data['post_author'] = postAuthor;
    data['post_date'] = postDate;
    data['post_date_gmt'] = postDateGmt;
    data['post_content'] = postContent;
    data['post_title'] = postTitle;
    data['post_excerpt'] = postExcerpt;
    data['post_status'] = postStatus;
    data['comment_status'] = commentStatus;
    data['ping_status'] = pingStatus;
    data['post_password'] = postPassword;
    data['post_name'] = postName;
    data['to_ping'] = toPing;
    data['pinged'] = pinged;
    data['post_modified'] = postModified;
    data['post_modified_gmt'] = postModifiedGmt;
    data['post_content_filtered'] = postContentFiltered;
    data['post_parent'] = postParent;
    data['guid'] = guid;
    data['menu_order'] = menuOrder;
    data['post_type'] = postType;
    data['post_mime_type'] = postMimeType;
    data['comment_count'] = commentCount;
    data['filter'] = filter;
    data['hit_score'] = hitScore;
    data['edbp_youtube_url'] = edbpYoutubeUrl;
    data['edbp_video_snippet_url'] = edbpVideoSnippetUrl;
    data['edbp_live_status'] = edbpLiveStatus;
    data['categories'] = categories;
    data['tags'] = tags;
    data['featured_image'] = featuredImage;
    data['featured_image_2'] = featuredImage2;
    return data;
  }
}
