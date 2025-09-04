
import 'package:gold_house/data/models/basket_model.dart';
import 'package:gold_house/data/models/favorite_product_model.dart';
import 'package:hive/hive.dart';

class HiveBoxes {
  const HiveBoxes._();
    static final Box<BasketModel> basketData = Hive.box(
    HiveBoxNames.basketData,
  );
      static final Box<FavoriteProductModel> favoriteProduct = Hive.box(
    HiveBoxNames.favoriteProduct,
  );

  static Future<void> clearAllBoxes() async {
    await Future.wait([]);
  }
}

class HiveBoxNames {
  static const String userData = "userData";
static const String basketData = "basketData";
static const String favoriteProduct = "favoriteProduct";

}
