// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_product_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FavoriteProductModelAdapter extends TypeAdapter<FavoriteProductModel> {
  @override
  final int typeId = 5;

  @override
  FavoriteProductModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FavoriteProductModel(
      id: fields[0] as int,
      nameUz: fields[1] as String,
      nameRu: fields[2] as String,
      nameEn: fields[3] as String,
      descriptionUz: fields[4] as String?,
      descriptionRu: fields[5] as String?,
      descriptionEn: fields[6] as String?,
      images: (fields[7] as List).cast<String>(),
      price: (fields[8] as List).cast<String>(),
      isAvailable: fields[9] as bool,
      variantId: fields[10] as int,
      monthlyPayment3: fields[11] as double,
      monthlyPayment6: fields[12] as double,
      monthlyPayment12: fields[13] as double,
      monthlyPayment24: fields[14] as double,
      sizes: (fields[15] as List).cast<String>(),
      color: (fields[16] as List?)?.cast<String>(),
      branch: fields[17] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, FavoriteProductModel obj) {
    writer
      ..writeByte(18)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.nameUz)
      ..writeByte(2)
      ..write(obj.nameRu)
      ..writeByte(3)
      ..write(obj.nameEn)
      ..writeByte(4)
      ..write(obj.descriptionUz)
      ..writeByte(5)
      ..write(obj.descriptionRu)
      ..writeByte(6)
      ..write(obj.descriptionEn)
      ..writeByte(7)
      ..write(obj.images)
      ..writeByte(8)
      ..write(obj.price)
      ..writeByte(9)
      ..write(obj.isAvailable)
      ..writeByte(10)
      ..write(obj.variantId)
      ..writeByte(11)
      ..write(obj.monthlyPayment3)
      ..writeByte(12)
      ..write(obj.monthlyPayment6)
      ..writeByte(13)
      ..write(obj.monthlyPayment12)
      ..writeByte(14)
      ..write(obj.monthlyPayment24)
      ..writeByte(15)
      ..write(obj.sizes)
      ..writeByte(16)
      ..write(obj.color)
      ..writeByte(17)
      ..write(obj.branch);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavoriteProductModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
