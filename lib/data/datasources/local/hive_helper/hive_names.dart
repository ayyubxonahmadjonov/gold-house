import 'package:gold_house/data/models/basket_model.dart';
import 'package:gold_house/data/models/favorite_product_model.dart';
import 'package:hive_flutter/hive_flutter.dart'; 

class HiveBoxes {
  const HiveBoxes._();

  static Box<BasketModel> get basketData => Hive.box<BasketModel>(
        HiveBoxNames.basketData,
      );

  static Box<FavoriteProductModel> get favoriteProduct => Hive.box<FavoriteProductModel>(
        HiveBoxNames.favoriteProduct,
      );

  static Future<void> clearAllBoxes() async {
    await Future.wait([]);
  }
}

class HiveBoxNames {
  static const String userData = "userDatas";
  static const String basketData = "basketDatas";
  static const String favoriteProduct = "favoriteProducts";
}