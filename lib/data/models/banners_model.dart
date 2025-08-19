class BannerModel {
  final int id;
  final int branch;
  final String image;
  final bool isActive;

  BannerModel({
    required this.id,
    required this.branch,
    required this.image,
    required this.isActive,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'] ?? 0,
      branch: json['branch'] ?? 0,
      image: json['image'] ?? '',
      isActive: json['is_active'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "branch": branch,
      "image": image,
      "is_active": isActive,
    };
  }
}
