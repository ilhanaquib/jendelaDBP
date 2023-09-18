// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../models/hiveBookModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveBookAPIAdapter extends TypeAdapter<HiveBookAPI> {
  @override
  final int typeId = 1;

  @override
  HiveBookAPI read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveBookAPI(
      id: fields[0] as int?,
      name: fields[1] as String?,
      images: fields[2] as String?,
      description: fields[3] as String?,
      categories: fields[4] as String?,
      regular_price: fields[5] as String?,
      sale_price: fields[6] as String?,
      average_rating: fields[9] as String?,
      date_created: fields[7] as String?,
      date_modified: fields[8] as String?,
      rating_count: fields[10] as int?,
      downloadUser: fields[12] as String?,
      isDownload: fields[11] as bool?,
      isFavorite: fields[13] as bool?,
      status: fields[14] as String?,
      type: fields[15] as String?,
      woocommerce_variations: fields[16] as String?,
      quantity: fields[17] as int?,
      discountPrice: fields[18] as String?,
      product_category: fields[19] as String?,
      price: fields[20] as String?,
      sku: fields[21] as String?,
      stock_status: fields[22] as String?,
      meta_data: (fields[23] as List?)?.cast<dynamic>(),
      external_url: fields[24] as String?,
      toCheckout: fields[25] as bool?,
      buyQuantity: fields[26] as int?,
      timestamp: fields[27] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, HiveBookAPI obj) {
    writer
      ..writeByte(28)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.images)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.categories)
      ..writeByte(5)
      ..write(obj.regular_price)
      ..writeByte(6)
      ..write(obj.sale_price)
      ..writeByte(7)
      ..write(obj.date_created)
      ..writeByte(8)
      ..write(obj.date_modified)
      ..writeByte(9)
      ..write(obj.average_rating)
      ..writeByte(10)
      ..write(obj.rating_count)
      ..writeByte(11)
      ..write(obj.isDownload)
      ..writeByte(12)
      ..write(obj.downloadUser)
      ..writeByte(13)
      ..write(obj.isFavorite)
      ..writeByte(14)
      ..write(obj.status)
      ..writeByte(15)
      ..write(obj.type)
      ..writeByte(16)
      ..write(obj.woocommerce_variations)
      ..writeByte(17)
      ..write(obj.quantity)
      ..writeByte(18)
      ..write(obj.discountPrice)
      ..writeByte(19)
      ..write(obj.product_category)
      ..writeByte(20)
      ..write(obj.price)
      ..writeByte(21)
      ..write(obj.sku)
      ..writeByte(22)
      ..write(obj.stock_status)
      ..writeByte(23)
      ..write(obj.meta_data)
      ..writeByte(24)
      ..write(obj.external_url)
      ..writeByte(25)
      ..write(obj.toCheckout)
      ..writeByte(26)
      ..write(obj.buyQuantity)
      ..writeByte(27)
      ..write(obj.timestamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveBookAPIAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
