class Product {
  final int id;
  final int branch;
  final String nameUz;
  final String nameRu;
  final String nameEn;
  final bool isAvailable;
  final String? descriptionUz;
  final String? descriptionRu;
  final String? descriptionEn;
  final String image;
  final int views;
  final String ikpu;
  final String unitsId;
  final String unitsUz;
  final String unitsEn;
  final String unitsRu;
  final int category;
  final List<ProductVariant> variants;

  Product({
    required this.id,
    required this.branch,
    required this.nameUz,
    required this.nameRu,
    required this.nameEn,
    required this.isAvailable,
    this.descriptionUz,
    this.descriptionRu,
    this.descriptionEn,
    required this.image,
    required this.views,
    required this.ikpu,
    required this.unitsId,
    required this.unitsUz,
    required this.unitsEn,
    required this.unitsRu,
    required this.category,
    required this.variants,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      branch: json['branch'] ?? 0,
      nameUz: json['name_uz'] ?? '',
      nameRu: json['name_ru'] ?? '',
      nameEn: json['name_en'] ?? '',
      isAvailable: json['is_available'] ?? false,
      descriptionUz: json['description_uz'],
      descriptionRu: json['description_ru'],
      descriptionEn: json['description_en'],
      image: json['image'] ?? '',
      views: json['views'] ?? 0,
      ikpu: json['ikpu'] ?? '',
      unitsId: json['units_id']?.toString() ?? '',
      unitsUz: json['units_uz'] ?? '',
      unitsEn: json['units_en'] ?? '',
      unitsRu: json['units_ru'] ?? '',
      category: json['category'] ?? 0,
      variants: (json['variants'] as List<dynamic>?)
              ?.map((e) => ProductVariant.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class ProductVariant {
  final int id;
  final String? colorUz;
  final String? colorRu;
  final String? colorEn;
  final String? sizeUz;
  final String? sizeRu;
  final String? sizeEn;
  final double price;
  final bool isAvailable;
  final String image;
  final double monthlyPayment3;
  final double monthlyPayment6;
  final double monthlyPayment12;
  final double monthlyPayment24;
  final int product;

  ProductVariant({
    required this.id,
    this.colorUz,
    this.colorRu,
    this.colorEn,
    this.sizeUz,
    this.sizeRu,
    this.sizeEn,
    required this.price,
    required this.isAvailable,
    required this.image,
    required this.monthlyPayment3,
    required this.monthlyPayment6,
    required this.monthlyPayment12,
    required this.monthlyPayment24,
    required this.product,
  });

  factory ProductVariant.fromJson(Map<String, dynamic> json) {
    return ProductVariant(
      id: json['id'] ?? 0,
      colorUz: json['color_uz'],
      colorRu: json['color_ru'],
      colorEn: json['color_en'],
      sizeUz: json['size_uz']?.toString(),
      sizeRu: json['size_ru']?.toString(),
      sizeEn: json['size_en']?.toString(),
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      isAvailable: json['is_available'] ?? false,
      image: json['image'] ?? '',
      monthlyPayment3: double.tryParse(json['monthly_payment_3'].toString()) ?? 0.0,
      monthlyPayment6: double.tryParse(json['monthly_payment_6'].toString()) ?? 0.0,
      monthlyPayment12: double.tryParse(json['monthly_payment_12'].toString()) ?? 0.0,
      monthlyPayment24: double.tryParse(json['monthly_payment_24'].toString()) ?? 0.0,
      product: json['product'] ?? 0,
    );
  }
}
