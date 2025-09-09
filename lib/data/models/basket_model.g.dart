// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'basket_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BasketModelAdapter extends TypeAdapter<BasketModel> {
  @override
  final int typeId = 0;

  @override
  BasketModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BasketModel(
      variantId: fields[13] as int,
      productId: fields[0] as String,
      title: fields[1] as String,
      color: fields[2] as String,
      size: fields[3] as String,
      description: fields[4] as String,
      price: fields[5] as String,
      monthlyPrice3: fields[6] as String,
      monthlyPrice6: fields[7] as String,
      monthlyPrice12: fields[8] as String,
      monthlyPrice24: fields[9] as String,
      image: fields[10] as String,
      isAvailable: fields[11] as bool,
      quantity: fields[12] as String?,
      branchName: fields[14] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, BasketModel obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.productId)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.color)
      ..writeByte(3)
      ..write(obj.size)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.price)
      ..writeByte(6)
      ..write(obj.monthlyPrice3)
      ..writeByte(7)
      ..write(obj.monthlyPrice6)
      ..writeByte(8)
      ..write(obj.monthlyPrice12)
      ..writeByte(9)
      ..write(obj.monthlyPrice24)
      ..writeByte(10)
      ..write(obj.image)
      ..writeByte(11)
      ..write(obj.isAvailable)
      ..writeByte(12)
      ..write(obj.quantity)
      ..writeByte(13)
      ..write(obj.variantId)
      ..writeByte(14)
      ..write(obj.branchName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BasketModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
