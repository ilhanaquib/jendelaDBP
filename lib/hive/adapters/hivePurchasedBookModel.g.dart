// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../models/hivePurchasedBookModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HivePurchasedBookAdapter extends TypeAdapter<HivePurchasedBook> {
  @override
  final int typeId = 2;

  @override
  HivePurchasedBook read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HivePurchasedBook(
      download_id: fields[0] as String?,
      download_url: fields[1] as String?,
      product_name: fields[2] as String?,
      isDownload: fields[3] as bool?,
      downloadUser: fields[4] as String?,
      typeFile: fields[5] as String?,
      bookHistory: fields[6] as String?,
      isFavorite: fields[7] as bool?,
      product_id: fields[9] as int?,
      download_name: fields[8] as String?,
      order_id: fields[10] as int?,
      order_key: fields[11] as String?,
      downloads_remaining: fields[12] as String?,
      access_expires: fields[13] as String?,
      access_expires_gmt: fields[14] as String?,
      download_url_temp: fields[15] as String?,
      localPath: fields[16] as String?,
      descriptionParent: fields[19] as String?,
      featured_media_url: fields[17] as String?,
      parentID: fields[18] as int?,
      product_category: fields[20] as String?,
      IDUser: fields[21] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, HivePurchasedBook obj) {
    writer
      ..writeByte(22)
      ..writeByte(0)
      ..write(obj.download_id)
      ..writeByte(1)
      ..write(obj.download_url)
      ..writeByte(2)
      ..write(obj.product_name)
      ..writeByte(3)
      ..write(obj.isDownload)
      ..writeByte(4)
      ..write(obj.downloadUser)
      ..writeByte(5)
      ..write(obj.typeFile)
      ..writeByte(6)
      ..write(obj.bookHistory)
      ..writeByte(7)
      ..write(obj.isFavorite)
      ..writeByte(8)
      ..write(obj.download_name)
      ..writeByte(9)
      ..write(obj.product_id)
      ..writeByte(10)
      ..write(obj.order_id)
      ..writeByte(11)
      ..write(obj.order_key)
      ..writeByte(12)
      ..write(obj.downloads_remaining)
      ..writeByte(13)
      ..write(obj.access_expires)
      ..writeByte(14)
      ..write(obj.access_expires_gmt)
      ..writeByte(15)
      ..write(obj.download_url_temp)
      ..writeByte(16)
      ..write(obj.localPath)
      ..writeByte(17)
      ..write(obj.featured_media_url)
      ..writeByte(18)
      ..write(obj.parentID)
      ..writeByte(19)
      ..write(obj.descriptionParent)
      ..writeByte(20)
      ..write(obj.product_category)
      ..writeByte(21)
      ..write(obj.IDUser);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HivePurchasedBookAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
