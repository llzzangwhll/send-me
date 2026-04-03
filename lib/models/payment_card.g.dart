// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_card.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PaymentCardAdapter extends TypeAdapter<PaymentCard> {
  @override
  final int typeId = 0;

  @override
  PaymentCard read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PaymentCard(
      id: fields[0] as String,
      bankName: fields[1] as String,
      accountNumber: fields[2] as String,
      holderName: fields[3] as String,
      amount: fields[4] as int?,
      tossMeLink: fields[5] as String?,
      kakaoPayLink: fields[6] as String?,
      memo: fields[7] as String?,
      createdAt: fields[8] as DateTime,
      colorIndex: fields[9] as int,
    );
  }

  @override
  void write(BinaryWriter writer, PaymentCard obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.bankName)
      ..writeByte(2)
      ..write(obj.accountNumber)
      ..writeByte(3)
      ..write(obj.holderName)
      ..writeByte(4)
      ..write(obj.amount)
      ..writeByte(5)
      ..write(obj.tossMeLink)
      ..writeByte(6)
      ..write(obj.kakaoPayLink)
      ..writeByte(7)
      ..write(obj.memo)
      ..writeByte(8)
      ..write(obj.createdAt)
      ..writeByte(9)
      ..write(obj.colorIndex);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaymentCardAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
