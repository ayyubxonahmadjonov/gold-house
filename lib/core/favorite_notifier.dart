import 'package:flutter/material.dart';

class FavoriteNotifier {
  static final ValueNotifier<int> favoriteUpdateNotifier = ValueNotifier<int>(0);

  static void notifyFavoriteChanged() {
    favoriteUpdateNotifier.value++;
  }
}