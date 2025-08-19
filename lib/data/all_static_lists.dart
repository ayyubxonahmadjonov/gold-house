import 'package:gold_house/data/models/basket_product_model.dart';
import 'package:gold_house/data/models/order_model.dart';
class ProductModel {
  final String name;
  final double price;
  final String imageUrl;
  final String color;
  final String size;
  
  const ProductModel({
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.color,
    required this.size,
  });
}
class AllStaticLists {
  final products = [
    ProductModel(
      name: 'PENOPLEX COMFORT',
      price: 125650,
      imageUrl: 'assets/images/penopleks.png',
      color: "Qizil",
      size: '4x6',
    ),
    ProductModel(
      name: 'PENOPLEX COMFORT',
      price: 135650,
      imageUrl: 'assets/images/penopleks.png',
      color: "To'q sariq",
      size: '4x6',
    ),
    ProductModel(
      name: 'PENOPLEX COMFORT',
      price: 455650,
      imageUrl: 'assets/images/penopleks.png',
      color: "Yashil",
      size: '4x6',
    ),
  ];
  final List<OrderModel> orders = [
    OrderModel(
      isVisible: false,
      id: "63224636",
      status: OrderStatus.delivered,
      date: "Juma 10 yanvar",
      productName: "",
      productPrice: 126650,
      image: "assets/images/penopleks.png",
    ),
    OrderModel(
      isVisible: false,
      id: "63224637",
      status: OrderStatus.processing,
      date: "Juma 10 yanvar",
      productName: "PENOPEX COMFORT",
      productPrice: 125650,
      image: "assets/images/penopleks.png",
      installmentText: "1.999 so‘mdan / 12oy",
    ),
    OrderModel(
      isVisible: false,
      id: "63224638",
      status: OrderStatus.cancelled,
      date: "Juma 10 yanvar",
      productName: "",
      productPrice: 126650,
      image: "assets/images/penopleks.png",
    ),
  ];
}
