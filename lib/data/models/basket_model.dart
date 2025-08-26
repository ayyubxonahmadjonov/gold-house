import 'package:gold_house/data/datasources/local/hive_helper/adapters.dart';
import 'package:hive/hive.dart';

part 'basket_model.g.dart'; 

@HiveType(typeId: 0,adapterName: HiveAdapters.basketAdapter) // har bir model uchun unique typeId bering
class BasketModel extends HiveObject {
  @HiveField(0)
  final String productId;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String color;

  @HiveField(3)
  final String size;

  @HiveField(4)
  final String description;

  @HiveField(5)
  final String price;

  @HiveField(6)
  final String monthlyPrice3;

  @HiveField(7)
  final String monthlyPrice6;

  @HiveField(8)
  final String monthlyPrice12;

  @HiveField(9)
  final String monthlyPrice24;

  @HiveField(10)
  final String image;

  @HiveField(11)
  final bool isAvailable;
    @HiveField(12)
  String? quantity;

  BasketModel({
    required this.productId,
    required this.title,
    required this.color,
    required this.size,
    required this.description,
    required this.price,
    required this.monthlyPrice3,
    required this.monthlyPrice6,
    required this.monthlyPrice12,
    required this.monthlyPrice24,
    required this.image,
    required this.isAvailable,
    this.quantity,
  });
}
