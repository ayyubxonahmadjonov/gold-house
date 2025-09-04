class OrderOfBasket {
  final int id;
  final String totalAmount;
  final String status;
  final String deliveryAddress;
  final String paymentMethod;
  final String cashbackUsed;
  final String cashbackEarned;
  final String createdAt;
  final List<OrderItem> items;
  final Branch branch;
  final int part;

  OrderOfBasket({
    required this.id,
    required this.totalAmount,
    required this.status,
    required this.deliveryAddress,
    required this.paymentMethod,
    required this.cashbackUsed,
    required this.cashbackEarned,
    required this.createdAt,
    required this.items,
    required this.branch,
    required this.part,
  });

  factory OrderOfBasket.fromJson(Map<String, dynamic> json) {
    return OrderOfBasket(
      id: json['id'] ?? 0,
      totalAmount: json['total_amount'] ?? '',
      status: json['status'] ?? '',
      deliveryAddress: json['delivery_address'] ?? '',
      paymentMethod: json['payment_method'] ?? '',
      cashbackUsed: json['cashback_used'] ?? '',
      cashbackEarned: json['cashback_earned'] ?? '',
      createdAt: json['created_at'] ?? '',
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => OrderItem.fromJson(e))
              .toList() ??
          [],
      branch: Branch.fromJson(json['branch'] ?? {}),
      part: json['part'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "total_amount": totalAmount,
      "status": status,
      "delivery_address": deliveryAddress,
      "payment_method": paymentMethod,
      "cashback_used": cashbackUsed,
      "cashback_earned": cashbackEarned,
      "created_at": createdAt,
      "items": items.map((e) => e.toJson()).toList(),
      "branch": branch.toJson(),
      "part": part,
    };
  }
}

class OrderItem {
  final ProductVariant productVariant;
  final int quantity;
  final String price;

  OrderItem({
    required this.productVariant,
    required this.quantity,
    required this.price,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productVariant: ProductVariant.fromJson(json['product_variant'] ?? {}),
      quantity: json['quantity'] ?? 0,
      price: json['price'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "product_variant": productVariant.toJson(),
      "quantity": quantity,
      "price": price,
    };
  }
}

class ProductVariant {
  final int id;
  final String colorUz;
  final String colorRu;
  final String colorEn;
  final String sizeUz;
  final String sizeRu;
  final String sizeEn;
  final String price;
  final bool isAvailable;
  final String image;
  final String monthlyPayment3;
  final String monthlyPayment6;
  final String monthlyPayment12;
  final String monthlyPayment24;
  final int product;

  ProductVariant({
    required this.id,
    required this.colorUz,
    required this.colorRu,
    required this.colorEn,
    required this.sizeUz,
    required this.sizeRu,
    required this.sizeEn,
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
      colorUz: json['color_uz'] ?? '',
      colorRu: json['color_ru'] ?? '',
      colorEn: json['color_en'] ?? '',
      sizeUz: json['size_uz'] ?? '',
      sizeRu: json['size_ru'] ?? '',
      sizeEn: json['size_en'] ?? '',
      price: json['price'] ?? '',
      isAvailable: json['is_available'] ?? false,
      image: json['image'] ?? '',
      monthlyPayment3: json['monthly_payment_3'] ?? '',
      monthlyPayment6: json['monthly_payment_6'] ?? '',
      monthlyPayment12: json['monthly_payment_12'] ?? '',
      monthlyPayment24: json['monthly_payment_24'] ?? '',
      product: json['product'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "color_uz": colorUz,
      "color_ru": colorRu,
      "color_en": colorEn,
      "size_uz": sizeUz,
      "size_ru": sizeRu,
      "size_en": sizeEn,
      "price": price,
      "is_available": isAvailable,
      "image": image,
      "monthly_payment_3": monthlyPayment3,
      "monthly_payment_6": monthlyPayment6,
      "monthly_payment_12": monthlyPayment12,
      "monthly_payment_24": monthlyPayment24,
      "product": product,
    };
  }
}

class Branch {
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

  Branch({
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

  factory Branch.fromJson(Map<String, dynamic> json) {
    return Branch(
      id: json['id'] ?? 0,
      location: Location.fromJson(json['location'] ?? {}),
      branch: json['branch'] ?? 0,
      nameUz: json['name_uz'] ?? '',
      nameRu: json['name_ru'] ?? '',
      nameEn: json['name_en'] ?? '',
      addressUz: json['address_uz'] ?? '',
      addressRu: json['address_ru'] ?? '',
      addressEn: json['address_en'] ?? '',
      phone: json['phone'] ?? '',
      workingHoursUz: json['working_hours_uz'] ?? '',
      workingHoursRu: json['working_hours_ru'] ?? '',
      workingHoursEn: json['working_hours_en'] ?? '',
      isActive: json['is_active'] ?? false,
      order: json['order'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "location": location.toJson(),
      "branch": branch,
      "name_uz": nameUz,
      "name_ru": nameRu,
      "name_en": nameEn,
      "address_uz": addressUz,
      "address_ru": addressRu,
      "address_en": addressEn,
      "phone": phone,
      "working_hours_uz": workingHoursUz,
      "working_hours_ru": workingHoursRu,
      "working_hours_en": workingHoursEn,
      "is_active": isActive,
      "order": order,
    };
  }
}

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
      id: json['id'] ?? 0,
      latitude: json['latitude'] ?? '',
      longitude: json['longitude'] ?? '',
      addressUz: json['address_uz'] ?? '',
      addressRu: json['address_ru'] ?? '',
      addressEn: json['address_en'] ?? '',
      isActive: json['is_active'] ?? false,
      isMain: json['is_main'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "latitude": latitude,
      "longitude": longitude,
      "address_uz": addressUz,
      "address_ru": addressRu,
      "address_en": addressEn,
      "is_active": isActive,
      "is_main": isMain,
    };
  }
}
