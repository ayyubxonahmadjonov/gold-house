class OrderModel {
  bool isVisible;
  final String id;
  final OrderStatus status;
  final String date;
  final String? productName;
  final int productPrice;
  final String? image;
  final String? installmentText;

  OrderModel({
    required this.isVisible,
    required this.id,
    required this.status,
    required this.date,
    required this.productPrice,
    this.productName,
    this.image,
    this.installmentText,
  });
}

enum OrderStatus { delivered, processing, cancelled }
