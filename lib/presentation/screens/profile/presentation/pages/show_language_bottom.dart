import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:gold_house/data/datasources/local/shared_preferences/shared_service.dart';

void showLanguageBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Theme.of(context).colorScheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) {
      final currentLocale = context.locale.languageCode;

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "select_language".tr(),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            _buildLanguageTile(
              context,
              langCode: "en",
              title: "English",
              flag: "🇬🇧",
              currentLocale: currentLocale,
            ),
            _buildLanguageTile(
              context,
              langCode: "uz",
              title: "Oʻzbekcha",
              flag: "🇺🇿",
              currentLocale: currentLocale,
            ),
            _buildLanguageTile(
              context,
              langCode: "ru",
              title: "Русский",
              flag: "🇷🇺",
              currentLocale: currentLocale,
            ),
            const SizedBox(height: 8),
          ],
        ),
      );
    },
  );
}

Widget _buildLanguageTile(
  BuildContext context, {
  required String langCode,
  required String title,
  required String flag,
  required String currentLocale,
}) {
  final isSelected = currentLocale == langCode;

  return Card(
    margin: const EdgeInsets.symmetric(vertical: 6),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    elevation: isSelected ? 4 : 1,
    child: ListTile(
      leading: Text(flag, style: const TextStyle(fontSize: 24)),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).textTheme.bodyLarge?.color,
        ),
      ),
      trailing: isSelected
          ? Icon(Icons.check_circle,
              color: Theme.of(context).colorScheme.primary)
          : null,
      onTap: () {
        SharedPreferencesService.instance.saveString("selected_lg", langCode);
        context.setLocale(Locale(langCode));
        Navigator.pop(context);
      },
    ),
  );
}
