class Category {
  final int id; // ID
  final int branch; // Branch
  final String nameUz; // Nomi (O'zbek)
  final String nameRu; // Название (Русский)
  final String nameEn; // Name (English)

  Category({
    required this.id,
    required this.branch,
    required this.nameUz,
    required this.nameRu,
    required this.nameEn,
  });

  /// JSONdan modelga o'tkazish
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as int,
      branch: json['branch'] as int,
      nameUz: json['name_uz'] as String,
      nameRu: json['name_ru'] as String,
      nameEn: json['name_en'] as String,
    );
  }

  /// Modeldan JSONga o'tkazish
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'branch': branch,
      'name_uz': nameUz,
      'name_ru': nameRu,
      'name_en': nameEn,
    };
  }
}
