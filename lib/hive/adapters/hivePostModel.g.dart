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
      commentStatus: fields[1] as String?,
      date: fields[2] as String?,
      dateGmt: fields[3] as String?,
      featuredMedia: fields[4] as int?,
      format: fields[5] as String?,
      id: fields[6] as int?,
      link: fields[7] as String?,
      modified: fields[8] as String?,
      modifiedGmt: fields[9] as String?,
      pingStatus: fields[10] as String?,
      slug: fields[11] as String?,
      status: fields[12] as String?,
      type: fields[13] as String?,
      yoastHead: fields[14] as String?,
      title: fields[15] as String?,
      featuredMediaUrls: fields[16] as String?,
      content: fields[17] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Post obj) {
    writer
      ..writeByte(18)
      ..writeByte(0)
      ..write(obj.author)
      ..writeByte(1)
      ..write(obj.commentStatus)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.dateGmt)
      ..writeByte(4)
      ..write(obj.featuredMedia)
      ..writeByte(5)
      ..write(obj.format)
      ..writeByte(6)
      ..write(obj.id)
      ..writeByte(7)
      ..write(obj.link)
      ..writeByte(8)
      ..write(obj.modified)
      ..writeByte(9)
      ..write(obj.modifiedGmt)
      ..writeByte(10)
      ..write(obj.pingStatus)
      ..writeByte(11)
      ..write(obj.slug)
      ..writeByte(12)
      ..write(obj.status)
      ..writeByte(13)
      ..write(obj.type)
      ..writeByte(14)
      ..write(obj.yoastHead)
      ..writeByte(15)
      ..write(obj.title)
      ..writeByte(16)
      ..write(obj.featuredMediaUrls)
      ..writeByte(17)
      ..write(obj.content);
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
