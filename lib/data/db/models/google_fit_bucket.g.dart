// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'google_fit_bucket.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GoogleFitBucketAdapter extends TypeAdapter<GoogleFitBucket> {
  @override
  GoogleFitBucket read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GoogleFitBucket.empty()
      ..entries = (fields[0] as List)?.cast<GoogleFitStepEntry>()
      ..requestTimeInMillis = fields[1] as int;
  }

  @override
  void write(BinaryWriter writer, GoogleFitBucket obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.entries)
      ..writeByte(1)
      ..write(obj.requestTimeInMillis);
  }
}
