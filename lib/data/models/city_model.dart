class City {
  final int id;
  final String nameUz;
  final String nameRu;
  final String nameEn;
  final int region;

  City({
    required this.id,
    required this.nameUz,
    required this.nameRu,
    required this.nameEn,
    required this.region,
  });

  // JSONdan objectga
  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['id'] as int,
      nameUz: json['name_uz'] as String,
      nameRu: json['name_ru'] as String,
      nameEn: json['name_en'] as String,
      region: json['region'] as int,
    );
  }

  // Objectni JSONga
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name_uz': nameUz,
      'name_ru': nameRu,
      'name_en': nameEn,
      'region': region,
    };
  }
}
