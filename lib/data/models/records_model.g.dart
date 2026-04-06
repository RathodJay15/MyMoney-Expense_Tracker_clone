// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'records_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecordModelAdapter extends TypeAdapter<RecordModel> {
  @override
  final int typeId = 3;

  @override
  RecordModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RecordModel(
      recordId: fields[0] as int?,
      type: fields[1] as String,
      accountId: fields[2] as int,
      categoryId: fields[3] as int?,
      transferAccountId: fields[4] as int?,
      note: fields[5] as String?,
      amount: fields[6] as double,
      date: fields[7] as DateTime,
      time: fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, RecordModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.recordId)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.accountId)
      ..writeByte(3)
      ..write(obj.categoryId)
      ..writeByte(4)
      ..write(obj.transferAccountId)
      ..writeByte(5)
      ..write(obj.note)
      ..writeByte(6)
      ..write(obj.amount)
      ..writeByte(7)
      ..write(obj.date)
      ..writeByte(8)
      ..write(obj.time);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecordModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
