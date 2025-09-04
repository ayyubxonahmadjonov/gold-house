import 'package:gold_house/data/datasources/local/hive_helper/adapters.dart';
import 'package:gold_house/data/models/product_model.dart';
import 'package:hive/hive.dart';

part 'favorite_product_model.g.dart';

@HiveType(typeId: 5,adapterName: HiveAdapters.favoriteProductAdapter) 
class FavoriteProductModel {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String nameUz;

  @HiveField(2)
  final String nameRu;

  @HiveField(3)
  final String nameEn;

  @HiveField(4)
  final String? descriptionUz;

  @HiveField(5)
  final String? descriptionRu;

  @HiveField(6)
  final String? descriptionEn;

  @HiveField(7)
  final String image;

  @HiveField(8)
  final double price;

  @HiveField(9)
  final bool isAvailable;

  @HiveField(10)
  final int variantId;

  @HiveField(11)
  final double monthlyPayment3;

  @HiveField(12)
  final double monthlyPayment6;

  @HiveField(13)
  final double monthlyPayment12;

  @HiveField(14)
  final double monthlyPayment24;

  FavoriteProductModel({
    required this.id,
    required this.nameUz,
    required this.nameRu,
    required this.nameEn,
    required this.descriptionUz,
    required this.descriptionRu,
    required this.descriptionEn,
    required this.image,
    required this.price,
    required this.isAvailable,
    required this.variantId,
    required this.monthlyPayment3,
    required this.monthlyPayment6,
    required this.monthlyPayment12,
    required this.monthlyPayment24,
  });


  factory FavoriteProductModel.fromProduct(Product product) {
    final firstVariant = product.variants.isNotEmpty ? product.variants[0] : null;

    return FavoriteProductModel(
      id: product.id,
      nameUz: product.nameUz,
      nameRu: product.nameRu,
      nameEn: product.nameEn,
      descriptionUz: product.descriptionUz,
      descriptionRu: product.descriptionRu,
      descriptionEn: product.descriptionEn,
      image: product.image,
      price: firstVariant?.price ?? 0,
      isAvailable: firstVariant?.isAvailable ?? product.isAvailable,
      variantId: firstVariant?.id ?? 0,
      monthlyPayment3: firstVariant?.monthlyPayment3 ?? 0,
      monthlyPayment6: firstVariant?.monthlyPayment6 ?? 0,
      monthlyPayment12: firstVariant?.monthlyPayment12 ?? 0,
      monthlyPayment24: firstVariant?.monthlyPayment24 ?? 0,
    );
  }
}
