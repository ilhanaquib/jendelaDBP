// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../models/hiveUserBookModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BookUserModelAdapter extends TypeAdapter<BookUserModel> {
  @override
  final int typeId = 0;

  @override
  BookUserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BookUserModel(
      bookId: fields[0] as String?,
      pathEpub: fields[1] as String?,
      pathPdf: fields[2] as String?,
      isDownload: fields[3] as bool?,
      downloadUser: fields[4] as String?,
      typeFile: fields[5] as String?,
      bookHistory: fields[6] as String?,
      isFavorite: fields[7] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, BookUserModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.bookId)
      ..writeByte(1)
      ..write(obj.pathEpub)
      ..writeByte(2)
      ..write(obj.pathPdf)
      ..writeByte(3)
      ..write(obj.isDownload)
      ..writeByte(4)
      ..write(obj.downloadUser)
      ..writeByte(5)
      ..write(obj.typeFile)
      ..writeByte(6)
      ..write(obj.bookHistory)
      ..writeByte(7)
      ..write(obj.isFavorite);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookUserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
