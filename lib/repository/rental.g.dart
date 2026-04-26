// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rental.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RentalAdapter extends TypeAdapter<Rental> {
  @override
  final int typeId = 1;

  @override
  Rental read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Rental(
      id: fields[0] as String,
      userId: fields[1] as String,
      bikeId: fields[2] as String,
      booking: fields[3] as bool,
      start: fields[4] as DateTime?,
      finish: fields[5] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Rental obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.bikeId)
      ..writeByte(3)
      ..write(obj.booking)
      ..writeByte(4)
      ..write(obj.start)
      ..writeByte(5)
      ..write(obj.finish);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RentalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
