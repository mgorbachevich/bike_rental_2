// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bike.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BikeAdapter extends TypeAdapter<Bike> {
  @override
  final int typeId = 0;

  @override
  Bike read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Bike(
      id: fields[0] as String,
      name: fields[1] as String,
      electro: fields[2] as bool,
      locked: fields[3] as bool,
      rentaled: fields[4] as bool,
      charge: fields[5] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Bike obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.electro)
      ..writeByte(3)
      ..write(obj.locked)
      ..writeByte(4)
      ..write(obj.rentaled)
      ..writeByte(5)
      ..write(obj.charge);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BikeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
