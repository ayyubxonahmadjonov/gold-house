class Agreement {
  final int id;
  final int branch;
  final String titleUz;
  final String titleRu;
  final String titleEn;
  final String contentUz;
  final String contentRu;
  final String contentEn;
  final String version;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  Agreement({
    required this.id,
    required this.branch,
    required this.titleUz,
    required this.titleRu,
    required this.titleEn,
    required this.contentUz,
    required this.contentRu,
    required this.contentEn,
    required this.version,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  /// JSON → Model
  factory Agreement.fromJson(Map<String, dynamic> json) {
    return Agreement(
      id: json['id'] as int,
      branch: json['branch'] as int,
      titleUz: json['title_uz'] as String,
      titleRu: json['title_ru'] as String,
      titleEn: json['title_en'] as String,
      contentUz: json['content_uz'] as String,
      contentRu: json['content_ru'] as String,
      contentEn: json['content_en'] as String,
      version: json['version'] as String,
      isActive: json['is_active'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  /// Model → JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'branch': branch,
      'title_uz': titleUz,
      'title_ru': titleRu,
      'title_en': titleEn,
      'content_uz': contentUz,
      'content_ru': contentRu,
      'content_en': contentEn,
      'version': version,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
