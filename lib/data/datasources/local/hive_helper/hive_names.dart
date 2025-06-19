import 'package:flutter/widgets.dart';

class HiveBoxes {
  const HiveBoxes._();

  static Future<void> clearAllBoxes() async {
    await Future.wait([]);
  }
}

class HiveBoxNames {
  static const String userData = "userData";
  static const String appLanguage = "appLanguage";
  static const String primaryColor = "primaryColor";
  static const String profilePhoto = "profilePhoto";
  static const String acces_token = "accestoken";
  static const String refresh_token = "refreshtoken";
}
