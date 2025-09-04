import 'package:gold_house/data/datasources/local/hive_helper/hive_names.dart';
import 'package:gold_house/data/models/basket_model.dart';
import 'package:gold_house/data/models/favorite_product_model.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as pp;

class HiveService {
  const HiveService._();
  static Future<void> init() async {
    final dir = await pp.getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    Hive.registerAdapter(BasketModelAdapter());
    Hive.registerAdapter(FavoriteProductModelAdapter());

     await Hive.openBox<BasketModel>(HiveBoxNames.basketData);
     await Hive.openBox<FavoriteProductModel>(HiveBoxNames.favoriteProduct);
  }
}
