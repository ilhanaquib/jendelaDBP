// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../models/hiveArticleModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ArticleAdapter extends TypeAdapter<Article> {
  @override
  final int typeId = 4;

  @override
  Article read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Article(
      blogId: fields[0] as String?,
      id: fields[1] as int?,
      postAuthor: fields[2] as String?,
      postDate: fields[3] as String?,
      postDateGmt: fields[4] as String?,
      postContent: fields[5] as String?,
      postTitle: fields[6] as String?,
      postExcerpt: fields[7] as String?,
      postStatus: fields[8] as String?,
      commentStatus: fields[9] as String?,
      pingStatus: fields[10] as String?,
      postPassword: fields[11] as String?,
      postName: fields[12] as String?,
      toPing: fields[13] as String?,
      pinged: fields[14] as String?,
      postModified: fields[15] as String?,
      postModifiedGmt: fields[16] as String?,
      postContentFiltered: fields[17] as String?,
      postParent: fields[18] as int?,
      guid: fields[19] as String?,
      menuOrder: fields[20] as int?,
      postType: fields[21] as String?,
      postMimeType: fields[22] as String?,
      commentCount: fields[23] as String?,
      filter: fields[24] as String?,
      featuredImage: fields[25] as String?,
      hitScore: fields[26] as int?,
      edbpYoutubeUrl: fields[27] as String?,
      edbpVideoSnippetUrl: fields[28] as String?,
      edbpLiveStatus: fields[29] as String?,
      categories: (fields[30] as List?)?.cast<dynamic>(),
      tags: (fields[31] as List?)?.cast<dynamic>(),
      featuredImage2: fields[32] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Article obj) {
    writer
      ..writeByte(33)
      ..writeByte(0)
      ..write(obj.blogId)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.postAuthor)
      ..writeByte(3)
      ..write(obj.postDate)
      ..writeByte(4)
      ..write(obj.postDateGmt)
      ..writeByte(5)
      ..write(obj.postContent)
      ..writeByte(6)
      ..write(obj.postTitle)
      ..writeByte(7)
      ..write(obj.postExcerpt)
      ..writeByte(8)
      ..write(obj.postStatus)
      ..writeByte(9)
      ..write(obj.commentStatus)
      ..writeByte(10)
      ..write(obj.pingStatus)
      ..writeByte(11)
      ..write(obj.postPassword)
      ..writeByte(12)
      ..write(obj.postName)
      ..writeByte(13)
      ..write(obj.toPing)
      ..writeByte(14)
      ..write(obj.pinged)
      ..writeByte(15)
      ..write(obj.postModified)
      ..writeByte(16)
      ..write(obj.postModifiedGmt)
      ..writeByte(17)
      ..write(obj.postContentFiltered)
      ..writeByte(18)
      ..write(obj.postParent)
      ..writeByte(19)
      ..write(obj.guid)
      ..writeByte(20)
      ..write(obj.menuOrder)
      ..writeByte(21)
      ..write(obj.postType)
      ..writeByte(22)
      ..write(obj.postMimeType)
      ..writeByte(23)
      ..write(obj.commentCount)
      ..writeByte(24)
      ..write(obj.filter)
      ..writeByte(25)
      ..write(obj.featuredImage)
      ..writeByte(26)
      ..write(obj.hitScore)
      ..writeByte(27)
      ..write(obj.edbpYoutubeUrl)
      ..writeByte(28)
      ..write(obj.edbpVideoSnippetUrl)
      ..writeByte(29)
      ..write(obj.edbpLiveStatus)
      ..writeByte(30)
      ..write(obj.categories)
      ..writeByte(31)
      ..write(obj.tags)
      ..writeByte(32)
      ..write(obj.featuredImage2);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ArticleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
