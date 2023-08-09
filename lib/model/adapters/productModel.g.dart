// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../productModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductAdapter extends TypeAdapter<Product> {
  @override
  final int typeId = 10;

  @override
  Product read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Product(
      id: fields[0] as int?,
      postAuthor: fields[1] as String?,
      postDate: fields[2] as String?,
      postDateGmt: fields[3] as String?,
      postContent: fields[4] as String?,
      postTitle: fields[5] as String?,
      postExcerpt: fields[6] as String?,
      postStatus: fields[7] as String?,
      commentStatus: fields[8] as String?,
      pingStatus: fields[9] as String?,
      postPassword: fields[10] as String?,
      postName: fields[11] as String?,
      toPing: fields[12] as String?,
      pinged: fields[13] as String?,
      postModified: fields[14] as String?,
      postModifiedGmt: fields[15] as String?,
      postContentFiltered: fields[16] as String?,
      postParent: fields[17] as int?,
      guid: fields[18] as dynamic,
      menuOrder: fields[19] as int?,
      postType: fields[20] as String?,
      postMimeType: fields[21] as String?,
      commentCount: fields[22] as String?,
      filter: fields[23] as String?,
      ancestors: (fields[24] as List?)?.cast<dynamic>(),
      postCategory: (fields[26] as List?)?.cast<dynamic>(),
      tagsInput: (fields[27] as List?)?.cast<dynamic>(),
      featuredMediaUrl: fields[28] as String?,
      woocommerceVariations: (fields[29] as List?)?.cast<dynamic>(),
      woocommerce: fields[30] as WcProduct?,
    )..pageTemplate = fields[25] as String?;
  }

  @override
  void write(BinaryWriter writer, Product obj) {
    writer
      ..writeByte(31)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.postAuthor)
      ..writeByte(2)
      ..write(obj.postDate)
      ..writeByte(3)
      ..write(obj.postDateGmt)
      ..writeByte(4)
      ..write(obj.postContent)
      ..writeByte(5)
      ..write(obj.postTitle)
      ..writeByte(6)
      ..write(obj.postExcerpt)
      ..writeByte(7)
      ..write(obj.postStatus)
      ..writeByte(8)
      ..write(obj.commentStatus)
      ..writeByte(9)
      ..write(obj.pingStatus)
      ..writeByte(10)
      ..write(obj.postPassword)
      ..writeByte(11)
      ..write(obj.postName)
      ..writeByte(12)
      ..write(obj.toPing)
      ..writeByte(13)
      ..write(obj.pinged)
      ..writeByte(14)
      ..write(obj.postModified)
      ..writeByte(15)
      ..write(obj.postModifiedGmt)
      ..writeByte(16)
      ..write(obj.postContentFiltered)
      ..writeByte(17)
      ..write(obj.postParent)
      ..writeByte(18)
      ..write(obj.guid)
      ..writeByte(19)
      ..write(obj.menuOrder)
      ..writeByte(20)
      ..write(obj.postType)
      ..writeByte(21)
      ..write(obj.postMimeType)
      ..writeByte(22)
      ..write(obj.commentCount)
      ..writeByte(23)
      ..write(obj.filter)
      ..writeByte(24)
      ..write(obj.ancestors)
      ..writeByte(25)
      ..write(obj.pageTemplate)
      ..writeByte(26)
      ..write(obj.postCategory)
      ..writeByte(27)
      ..write(obj.tagsInput)
      ..writeByte(28)
      ..write(obj.featuredMediaUrl)
      ..writeByte(29)
      ..write(obj.woocommerceVariations)
      ..writeByte(30)
      ..write(obj.woocommerce);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
