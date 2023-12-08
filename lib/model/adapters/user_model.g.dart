// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 13;

  @override
  User read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return User(
      id: fields[0] as int?,
      name: fields[1] as String?,
      jwtToken: fields[2] as String?,
      email: fields[3] as String?,
      avatarUrls: (fields[4] as Map?)?.cast<dynamic, dynamic>(),
      links: (fields[5] as Map?)?.cast<dynamic, dynamic>(),
      address_1: fields[6] as String?,
      address_2: fields[7] as String?,
      city: fields[8] as String?,
      company: fields[9] as String?,
      country: fields[10] as String?,
      firstName: fields[11] as String?,
      lastName: fields[12] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.jwtToken)
      ..writeByte(3)
      ..write(obj.email)
      ..writeByte(4)
      ..write(obj.avatarUrls)
      ..writeByte(5)
      ..write(obj.links)
      ..writeByte(6)
      ..write(obj.address_1)
      ..writeByte(7)
      ..write(obj.address_2)
      ..writeByte(8)
      ..write(obj.city)
      ..writeByte(9)
      ..write(obj.company)
      ..writeByte(10)
      ..write(obj.country)
      ..writeByte(11)
      ..write(obj.firstName)
      ..writeByte(12)
      ..write(obj.lastName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
