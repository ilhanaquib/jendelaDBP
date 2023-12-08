// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../models/hive_purchased_book_model.dart';

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
      downloadId: fields[0] as String?,
      downloadUrl: fields[1] as String?,
      productName: fields[2] as String?,
      isDownload: fields[3] as bool?,
      downloadUser: fields[4] as String?,
      typeFile: fields[5] as String?,
      bookHistory: fields[6] as String?,
      isFavorite: fields[7] as bool?,
      productId: fields[9] as int?,
      downloadName: fields[8] as String?,
      orderId: fields[10] as int?,
      orderKey: fields[11] as String?,
      downloadsRemaining: fields[12] as String?,
      accessExpires: fields[13] as String?,
      accessExpiresGmt: fields[14] as String?,
      downloadUrlTemp: fields[15] as String?,
      localPath: fields[16] as String?,
      descriptionParent: fields[19] as String?,
      featuredMediaUrl: fields[17] as String?,
      parentID: fields[18] as int?,
      productCategory: fields[20] as String?,
      idUser: fields[21] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, HivePurchasedBook obj) {
    writer
      ..writeByte(22)
      ..writeByte(0)
      ..write(obj.downloadId)
      ..writeByte(1)
      ..write(obj.downloadUrl)
      ..writeByte(2)
      ..write(obj.productName)
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
      ..write(obj.downloadName)
      ..writeByte(9)
      ..write(obj.productId)
      ..writeByte(10)
      ..write(obj.orderId)
      ..writeByte(11)
      ..write(obj.orderKey)
      ..writeByte(12)
      ..write(obj.downloadsRemaining)
      ..writeByte(13)
      ..write(obj.accessExpires)
      ..writeByte(14)
      ..write(obj.accessExpiresGmt)
      ..writeByte(15)
      ..write(obj.downloadUrlTemp)
      ..writeByte(16)
      ..write(obj.localPath)
      ..writeByte(17)
      ..write(obj.featuredMediaUrl)
      ..writeByte(18)
      ..write(obj.parentID)
      ..writeByte(19)
      ..write(obj.descriptionParent)
      ..writeByte(20)
      ..write(obj.productCategory)
      ..writeByte(21)
      ..write(obj.idUser);
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
