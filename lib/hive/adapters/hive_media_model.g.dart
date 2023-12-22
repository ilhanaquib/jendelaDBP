// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../models/hive_media_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MediaAdapter extends TypeAdapter<Media> {
  @override
  final int typeId = 9;

  @override
  Media read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Media(
      id: fields[0] as int?,
      date: fields[1] as String?,
      guid: (fields[2] as Map?)?.cast<dynamic, dynamic>(),
      mediaDetails: (fields[3] as Map?)?.cast<dynamic, dynamic>(),
    )..mimeType = fields[4] as String?;
  }

  @override
  void write(BinaryWriter writer, Media obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.guid)
      ..writeByte(3)
      ..write(obj.mediaDetails)
      ..writeByte(4)
      ..write(obj.mimeType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MediaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
