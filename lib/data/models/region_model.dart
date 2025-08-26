class Region {
  final int id;
  final String nameUz;
  final String nameRu;
  final String nameEn;

  Region({
    required this.id,
    required this.nameUz,
    required this.nameRu,
    required this.nameEn,
  });

  factory Region.fromJson(Map<String, dynamic> json) {
    return Region(
      id: json['id'] as int,
      nameUz: json['name_uz'] as String,
      nameRu: json['name_ru'] as String,
      nameEn: json['name_en'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name_uz': nameUz,
      'name_ru': nameRu,
      'name_en': nameEn,
    };
  }
}
