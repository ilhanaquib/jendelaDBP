// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../models/hive_radio_category_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RadioCategoryAdapter extends TypeAdapter<RadioCategory> {
  @override
  final int typeId = 11;

  @override
  RadioCategory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RadioCategory(
      id: fields[0] as int?,
      count: fields[1] as int?,
      description: fields[2] as String?,
      name: fields[3] as String?,
      taxonomy: fields[4] as String?,
      slug: fields[5] as String?,
      link: fields[6] as String?,
      links: (fields[7] as Map?)?.cast<dynamic, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, RadioCategory obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.count)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.name)
      ..writeByte(4)
      ..write(obj.taxonomy)
      ..writeByte(5)
      ..write(obj.slug)
      ..writeByte(6)
      ..write(obj.link)
      ..writeByte(7)
      ..write(obj.links);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RadioCategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
