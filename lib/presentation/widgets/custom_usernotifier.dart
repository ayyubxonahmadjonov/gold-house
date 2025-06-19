import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPrefsNotifier extends ValueNotifier<Map<String, String>> {
  UserPrefsNotifier() : super({'name': '', 'surname': ''});

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('profilename') ?? '';
    final surname = prefs.getString('profilesurname') ?? '';
    value = {'name': name, 'surname': surname};
  }

  Future<void> updateNameSurname(String name, String surname) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profilename', name);
    await prefs.setString('profilesurname', surname);
    value = {'name': name, 'surname': surname};
  }
}
