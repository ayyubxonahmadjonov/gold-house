import 'dart:async';

import 'package:hive/hive.dart';
import 'package:gold_house/core/constants/app_imports.dart'; 

class BasketNotifier {
  static ValueNotifier<int> productCount = ValueNotifier<int>(0);
  static ValueNotifier<int> basketProductCount = ValueNotifier<int>(0);
  static StreamSubscription<BoxEvent>? _basketSubscription;

  static void init() {
    final newBasketProduct = SharedPreferencesService.instance.getString('newBasketProduct') ?? '0';
    basketProductCount.value = int.tryParse(newBasketProduct) ?? 0;

    _updateProductCount();

    _basketSubscription = HiveBoxes.basketData.watch().listen((event) {
      _updateProductCount();
    });
  }

  static void _updateProductCount() {
    final basketList = HiveBoxes.basketData.values.toList();
    productCount.value = basketList.fold(0, (sum, product) => sum + (int.parse(product.quantity ?? '1')));
    SharedPreferencesService.instance.saveString('basketProductCount', productCount.value.toString());
  }
  static void updateNewBasketProduct(String value) {
    SharedPreferencesService.instance.saveString('newBasketProduct', value);
    basketProductCount.value = int.tryParse(value) ?? 0;
  }

  static void dispose() {
    _basketSubscription?.cancel();
  }
}