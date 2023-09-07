// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../models/hivePostModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PostAdapter extends TypeAdapter<Post> {
  @override
  final int typeId = 4;

  @override
  Post read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Post(
      author: fields[0] as int?,
      comment_status: fields[1] as String?,
      date: fields[2] as String?,
      date_gmt: fields[3] as String?,
      featured_media: fields[4] as int?,
      format: fields[5] as String?,
      id: fields[6] as int?,
      link: fields[7] as String?,
      modified: fields[8] as String?,
      modified_gmt: fields[9] as String?,
      ping_status: fields[10] as String?,
      slug: fields[11] as String?,
      status: fields[12] as String?,
      sticky: fields[13] as String?,
      type: fields[14] as String?,
      yoast_head: fields[15] as String?,
      title: fields[16] as String?,
      featured_media_urls: fields[17] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Post obj) {
    writer
      ..writeByte(18)
      ..writeByte(0)
      ..write(obj.author)
      ..writeByte(1)
      ..write(obj.comment_status)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.date_gmt)
      ..writeByte(4)
      ..write(obj.featured_media)
      ..writeByte(5)
      ..write(obj.format)
      ..writeByte(6)
      ..write(obj.id)
      ..writeByte(7)
      ..write(obj.link)
      ..writeByte(8)
      ..write(obj.modified)
      ..writeByte(9)
      ..write(obj.modified_gmt)
      ..writeByte(10)
      ..write(obj.ping_status)
      ..writeByte(11)
      ..write(obj.slug)
      ..writeByte(12)
      ..write(obj.status)
      ..writeByte(13)
      ..write(obj.sticky)
      ..writeByte(14)
      ..write(obj.type)
      ..writeByte(15)
      ..write(obj.yoast_head)
      ..writeByte(16)
      ..write(obj.title)
      ..writeByte(17)
      ..write(obj.featured_media_urls);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PostAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
