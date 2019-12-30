// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_details.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AccountDetailsAdapter extends TypeAdapter<AccountDetails> {
  @override
  AccountDetails read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AccountDetails.empty()
      ..displayName = fields[0] as String
      ..email = fields[1] as String
      ..id = fields[2] as String
      ..photoUrl = fields[3] as String
      ..fitbitToken = fields[4] as String
      ..userId = fields[5] as String
      ..scopes = (fields[6] as List)?.cast<String>()
      ..tokenType = fields[7] as String
      ..expiresIn = fields[8] as String
      ..googleAccessToken = fields[9] as String;
  }

  @override
  void write(BinaryWriter writer, AccountDetails obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.displayName)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.id)
      ..writeByte(3)
      ..write(obj.photoUrl)
      ..writeByte(4)
      ..write(obj.fitbitToken)
      ..writeByte(5)
      ..write(obj.userId)
      ..writeByte(6)
      ..write(obj.scopes)
      ..writeByte(7)
      ..write(obj.tokenType)
      ..writeByte(8)
      ..write(obj.expiresIn)
      ..writeByte(9)
      ..write(obj.googleAccessToken);
  }
}
