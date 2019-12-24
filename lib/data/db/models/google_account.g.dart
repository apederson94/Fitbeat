// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'google_account.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GoogleAccountAdapter extends TypeAdapter<GoogleAccount> {
  @override
  GoogleAccount read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GoogleAccount.empty()
      ..displayName = fields[0] as String
      ..email = fields[1] as String
      ..id = fields[2] as String
      ..photoUrl = fields[3] as String;
  }

  @override
  void write(BinaryWriter writer, GoogleAccount obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.displayName)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.id)
      ..writeByte(3)
      ..write(obj.photoUrl);
  }
}
