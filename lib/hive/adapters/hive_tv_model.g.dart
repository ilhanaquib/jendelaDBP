// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../models/hive_tv_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TvAdapter extends TypeAdapter<Tv> {
  @override
  final int typeId = 15;

  @override
  Tv read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Tv(
      id: fields[0] as int?,
      date: fields[1] as DateTime?,
      guid: (fields[2] as Map?)?.cast<dynamic, dynamic>(),
      modified: fields[3] as DateTime?,
      slug: fields[4] as String?,
      status: fields[5] as String?,
      type: fields[6] as String?,
      link: fields[7] as String?,
      title: (fields[8] as Map?)?.cast<dynamic, dynamic>(),
      content: (fields[9] as Map?)?.cast<dynamic, dynamic>(),
      featuredMedia: fields[10] as int?,
      tvCategory: (fields[11] as List?)?.cast<dynamic>(),
      tvCategories: (fields[14] as List?)?.cast<TvCategory>(),
      videoTag: (fields[12] as List?)?.cast<dynamic>(),
      links: (fields[13] as Map?)?.cast<dynamic, dynamic>(),
      meta: fields[15] as YoutubeMeta?,
      featuredMediaUrls: fields[16] as dynamic,
    );
  }

  @override
  void write(BinaryWriter writer, Tv obj) {
    writer
      ..writeByte(17)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.guid)
      ..writeByte(3)
      ..write(obj.modified)
      ..writeByte(4)
      ..write(obj.slug)
      ..writeByte(5)
      ..write(obj.status)
      ..writeByte(6)
      ..write(obj.type)
      ..writeByte(7)
      ..write(obj.link)
      ..writeByte(8)
      ..write(obj.title)
      ..writeByte(9)
      ..write(obj.content)
      ..writeByte(10)
      ..write(obj.featuredMedia)
      ..writeByte(11)
      ..write(obj.tvCategory)
      ..writeByte(12)
      ..write(obj.videoTag)
      ..writeByte(13)
      ..write(obj.links)
      ..writeByte(14)
      ..write(obj.tvCategories)
      ..writeByte(15)
      ..write(obj.meta)
      ..writeByte(16)
      ..write(obj.featuredMediaUrls);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TvAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class YoutubeMetaAdapter extends TypeAdapter<YoutubeMeta> {
  @override
  final int typeId = 16;

  @override
  YoutubeMeta read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return YoutubeMeta(
      hitScore: fields[0] as int?,
      edbpLiveStatus: fields[3] as bool?,
      edbpVideoSnippetUrl: fields[2] as String?,
      edbpYoutubeUrl: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, YoutubeMeta obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.hitScore)
      ..writeByte(1)
      ..write(obj.edbpYoutubeUrl)
      ..writeByte(2)
      ..write(obj.edbpVideoSnippetUrl)
      ..writeByte(3)
      ..write(obj.edbpLiveStatus);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is YoutubeMetaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
