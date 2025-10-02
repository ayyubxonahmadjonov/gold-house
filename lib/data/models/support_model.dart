class SupportModel {
  final int id;
  final int branch;
  final String titleUz;
  final String titleRu;
  final String titleEn;
  final String phoneNumber;
  final bool isActive;
  final int order;

  SupportModel({
    required this.id,
    required this.branch,
    required this.titleUz,
    required this.titleRu,
    required this.titleEn,
    required this.phoneNumber,
    required this.isActive,
    required this.order,
  });

  factory SupportModel.fromJson(Map<String, dynamic> json) {
    return SupportModel(
      id: json['id'] as int,
      branch: json['branch'] as int,
      titleUz: json['title_uz'] as String,
      titleRu: json['title_ru'] as String,
      titleEn: json['title_en'] as String,
      phoneNumber: json['phone_number'] as String,
      isActive: json['is_active'] as bool,
      order: json['order'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'branch': branch,
      'title_uz': titleUz,
      'title_ru': titleRu,
      'title_en': titleEn,
      'phone_number': phoneNumber,
      'is_active': isActive,
      'order': order,
    };
  }
}
