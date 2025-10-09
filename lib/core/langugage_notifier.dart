import 'package:flutter/foundation.dart';
import 'package:gold_house/data/datasources/local/shared_preferences/shared_service.dart';

class LanguageNotifier {
  static final ValueNotifier<String> selectedLanguage = ValueNotifier<String>(
    SharedPreferencesService.instance.getString("selected_lg") ?? "en",
  );

  static void updateLanguage(String newLanguage) {
    selectedLanguage.value = newLanguage;
    SharedPreferencesService.instance.saveString("selected_lg", newLanguage);
  }
}