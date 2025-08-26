class Location {
  final int id;
  final String latitude;
  final String longitude;
  final String addressUz;
  final String addressRu;
  final String addressEn;
  final bool isActive;
  final bool isMain;

  Location({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.addressUz,
    required this.addressRu,
    required this.addressEn,
    required this.isActive,
    required this.isMain,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'] as int,
      latitude: json['latitude'] as String,
      longitude: json['longitude'] as String,
      addressUz: json['address_uz'] as String,
      addressRu: json['address_ru'] as String,
      addressEn: json['address_en'] as String,
      isActive: json['is_active'] as bool,
      isMain: json['is_main'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'latitude': latitude,
      'longitude': longitude,
      'address_uz': addressUz,
      'address_ru': addressRu,
      'address_en': addressEn,
      'is_active': isActive,
      'is_main': isMain,
    };
  }
}

class BranchModel {
  final int id;
  final Location location;
  final int branch;
  final String nameUz;
  final String nameRu;
  final String nameEn;
  final String addressUz;
  final String addressRu;
  final String addressEn;
  final String phone;
  final String workingHoursUz;
  final String workingHoursRu;
  final String workingHoursEn;
  final bool isActive;
  final int order;

  BranchModel({
    required this.id,
    required this.location,
    required this.branch,
    required this.nameUz,
    required this.nameRu,
    required this.nameEn,
    required this.addressUz,
    required this.addressRu,
    required this.addressEn,
    required this.phone,
    required this.workingHoursUz,
    required this.workingHoursRu,
    required this.workingHoursEn,
    required this.isActive,
    required this.order,
  });

  factory BranchModel.fromJson(Map<String, dynamic> json) {
    return BranchModel(
      id: json['id'] as int,
      location: Location.fromJson(json['location']),
      branch: json['branch'] as int,
      nameUz: json['name_uz'] as String,
      nameRu: json['name_ru'] as String,
      nameEn: json['name_en'] as String,
      addressUz: json['address_uz'] as String,
      addressRu: json['address_ru'] as String,
      addressEn: json['address_en'] as String,
      phone: json['phone'] as String,
      workingHoursUz: json['working_hours_uz'] as String,
      workingHoursRu: json['working_hours_ru'] as String,
      workingHoursEn: json['working_hours_en'] as String,
      isActive: json['is_active'] as bool,
      order: json['order'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'location': location.toJson(),
      'branch': branch,
      'name_uz': nameUz,
      'name_ru': nameRu,
      'name_en': nameEn,
      'address_uz': addressUz,
      'address_ru': addressRu,
      'address_en': addressEn,
      'phone': phone,
      'working_hours_uz': workingHoursUz,
      'working_hours_ru': workingHoursRu,
      'working_hours_en': workingHoursEn,
      'is_active': isActive,
      'order': order,
    };
  }
}
