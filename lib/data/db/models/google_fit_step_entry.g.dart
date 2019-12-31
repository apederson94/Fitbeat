// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'google_fit_step_entry.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GoogleFitStepEntryAdapter extends TypeAdapter<GoogleFitStepEntry> {
  @override
  GoogleFitStepEntry read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GoogleFitStepEntry.empty()
      ..startTimeMillis = fields[0] as String
      ..endTimeMillis = fields[1] as String
      ..stepCount = fields[2] as int;
  }

  @override
  void write(BinaryWriter writer, GoogleFitStepEntry obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.startTimeMillis)
      ..writeByte(1)
      ..write(obj.endTimeMillis)
      ..writeByte(2)
      ..write(obj.stepCount);
  }
}
