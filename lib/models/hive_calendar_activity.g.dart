// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_calendar_activity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CalendarsHiveAdapter extends TypeAdapter<CalendarsHive> {
  @override
  final int typeId = 0;

  @override
  CalendarsHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CalendarsHive()
      ..date = fields[0] as DateTime
      ..activity = fields[1] as String;
  }

  @override
  void write(BinaryWriter writer, CalendarsHive obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.activity);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CalendarsHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
