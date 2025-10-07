import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:gold_house/core/constants/app_imports.dart'; // Import for SharedPreferencesService and HiveBoxes

class BasketNotifier {
  static ValueNotifier<int> productCount = ValueNotifier<int>(0);
  static ValueNotifier<int> basketProductCount = ValueNotifier<int>(0);
  static StreamSubscription<BoxEvent>? _basketSubscription;

  // Initialize the notifier
  static void init() {
    // Initialize basketProductCount from SharedPreferences
    final newBasketProduct = SharedPreferencesService.instance.getString('newBasketProduct') ?? '0';
    basketProductCount.value = int.tryParse(newBasketProduct) ?? 0;

    // Initialize productCount from Hive basket data
    _updateProductCount();

    // Listen for changes in Hive basket data to update productCount
    _basketSubscription = HiveBoxes.basketData.watch().listen((event) {
      _updateProductCount();
    });
  }

  // Update productCount based on the sum of quantities in the basket
  static void _updateProductCount() {
    final basketList = HiveBoxes.basketData.values.toList();
    productCount.value = basketList.fold(0, (sum, product) => sum + (int.parse(product.quantity ?? '1')));
    SharedPreferencesService.instance.saveString('basketProductCount', productCount.value.toString());
  }

  // Update basketProductCount when newBasketProduct changes
  static void updateNewBasketProduct(String value) {
    SharedPreferencesService.instance.saveString('newBasketProduct', value);
    basketProductCount.value = int.tryParse(value) ?? 0;
  }

  // Dispose of the subscription to prevent memory leaks
  static void dispose() {
    _basketSubscription?.cancel();
  }
}