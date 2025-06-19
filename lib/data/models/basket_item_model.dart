class BasketItemModel {
  final String name;
  final String image;
  final int price;
  int quantity;
  bool isSelected;

  BasketItemModel({
    required this.name,
    required this.image,
    required this.price,
    this.quantity = 1,
    this.isSelected = true,
  });
}
