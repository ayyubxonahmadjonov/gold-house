import 'package:easy_localization/easy_localization.dart';
import 'package:gold_house/core/basket_notifier.dart';
import 'package:gold_house/data/models/favorite_product_model.dart';
import 'package:gold_house/core/constants/app_imports.dart';

class ProductDescriptionPage extends StatefulWidget {
   String productId;
   int variantId;
   String title;
   List<String?> color;
   List<String?> size;
   String description;
   List<String> price;
   String monthlyPrice3;
   String monthlyPrice6;
   String monthlyPrice12;
   String monthlyPrice24;
   List<String> images;
   bool isAvailable;
   String branchName;

  ProductDescriptionPage({
    super.key,
    required this.branchName,
    required this.productId,
    required this.isAvailable,
    required this.title,
    required this.color,
    required this.size,
    required this.description,
    required this.price,
    required this.images,
    required this.variantId,
    required this.monthlyPrice3,
    required this.monthlyPrice6,
    required this.monthlyPrice12,
    required this.monthlyPrice24,
  });

  @override
  State<ProductDescriptionPage> createState() => _ProductDescriptionPageState();
}

class _ProductDescriptionPageState extends State<ProductDescriptionPage> {
  String selectedLanguage = "";
  String selectedColor = "";
  int activeIndex = 0;
  String? selectedSize;
  int selectedPriceIndex = 0;
  int basketProductCount = 0;
  int quantity = 1;
  bool isFavorite = false;

@override
void initState() {
  super.initState();
  selectedLanguage = SharedPreferencesService.instance.getString("selected_lg") ?? "";
  widget.size = widget.size.toSet().toList();
  if (widget.size.isNotEmpty) {
    selectedSize = widget.size.first;
    selectedPriceIndex = 0;
  }
  basketProductCount = int.tryParse(
        SharedPreferencesService.instance.getString("newBasketProduct") ?? "0",
      ) ??
      0;

 
  isFavorite = HiveBoxes.favoriteProduct.containsKey(widget.productId.toString());
}

void _toggleFavorite() {
  final key = widget.productId.toString(); 

  if (isFavorite) {
    HiveBoxes.favoriteProduct.delete(key);
  } else {
    final model = FavoriteProductModel(
      id: int.parse(widget.productId),
      nameUz: widget.title,
      nameRu: widget.title,
      nameEn: widget.title,
      descriptionUz: widget.description,
      descriptionRu: widget.description,
      descriptionEn: widget.description,
      images: widget.images,
      price: widget.price,
      isAvailable: widget.isAvailable,
      variantId: widget.variantId,
      monthlyPayment3: double.tryParse(widget.monthlyPrice3) ?? 0.0,
      monthlyPayment6: double.tryParse(widget.monthlyPrice6) ?? 0.0,
      monthlyPayment12: double.tryParse(widget.monthlyPrice12) ?? 0.0,
      monthlyPayment24: double.tryParse(widget.monthlyPrice24) ?? 0.0,
      sizes: widget.size.where((s) => s != null).cast<String>().toList(),
      color: widget.color.where((c) => c != null).cast<String>().toList(),
      branch: int.parse(widget.branchName),
    );
    HiveBoxes.favoriteProduct.put(key, model);
  }

  setState(() => isFavorite = !isFavorite);
}

  @override
  Widget build(BuildContext context) {
    final price = double.tryParse(widget.price[selectedPriceIndex]) ?? 0.0;
    final monthlyPrice3 = price > 0 ? (price * 1.19 / 3).toStringAsFixed(2) : '';
    final monthlyPrice6 = price > 0 ? (price * 1.26 / 6).toStringAsFixed(2) : '';
    final monthlyPrice12 = price > 0 ? (price * 1.42 / 12).toStringAsFixed(2) : '';
    final monthlyPrice15 = price > 0 ? (price * 1.50 / 15).toStringAsFixed(2) : '';
    final monthlyPrice18 = price > 0 ? (price * 1.56 / 18).toStringAsFixed(2) : '';
    final monthlyPrice24 = price > 0 ? (price * 1.75 / 24).toStringAsFixed(2) : '';

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        surfaceTintColor: AppColors.white,
        backgroundColor: AppColors.white,
        leading: const BackButton(),
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : Colors.grey,
            ),
            onPressed: _toggleFavorite,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 25.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  if (widget.images.length == 1)
                    Image.network(
                      'https://backkk.stroybazan1.uz${widget.images.first}',
                      height: 200.h,
                      fit: BoxFit.cover,
                    ),
                  if (widget.images.length > 1) ...[
                    CarouselSlider.builder(
                      itemCount: widget.images.length,
                      itemBuilder: (context, index, realIndex) {
                        return Image.network(
                          errorBuilder: (context, error, stackTrace) {
                            return Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: SizedBox(
                                height: 350.h,
                                width: double.infinity,
                              ),
                            );
                          },
                          'https://backkk.stroybazan1.uz${widget.images[index]}',
                          fit: BoxFit.cover,
                        );
                      },
                      options: CarouselOptions(
                        height: 220.h,
                        viewportFraction: 1,
                        enableInfiniteScroll: true,
                        autoPlay: true,
                        onPageChanged: (index, reason) {
                          setState(() => activeIndex = index);
                        },
                      ),
                    ),
                    SizedBox(height: 8.h),
                    AnimatedSmoothIndicator(
                      activeIndex: activeIndex,
                      count: widget.images.length,
                      effect: ExpandingDotsEffect(
                        dotHeight: 6,
                        dotWidth: 6,
                        activeDotColor: Colors.black,
                        dotColor: Colors.grey,
                      ),
                    ),
                  ],
                  SizedBox(height: 10.h),
                ],
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              widget.isAvailable ? 'Mavjud' : 'Mavjud emas',
              style: TextStyle(
                color: Colors.green,
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              widget.title,
              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12.h),
            SizedBox(
              height: 60.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.images.length,
                itemBuilder: (_, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Image.network(
                      'https://backkk.stroybazan1.uz${widget.images[index]}',
                      errorBuilder: (context, error, stackTrace) {
                        return Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            width: 60.w,
                            height: 60.h,
                            color: Colors.white,
                          ),
                        );
                      },
                      width: 60.w,
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 15.h),
            Text("${"size".tr()} (Metr²): ${selectedSize}"),
            SizedBox(height: 15.h),
            SizedBox(
              height: 40.h,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: widget.size.length,
                itemBuilder: (context, index) {
                  final size = widget.size[index] ?? "";
                  final isSelected = selectedSize == size;

                  return InkWell(
                    onTap: () {
                      setState(() {
                        selectedPriceIndex = index;
                        selectedSize = size;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                          color: isSelected ? AppColors.primaryColor : Colors.black26,
                          width: 2,
                        ),
                      ),
                      margin: EdgeInsets.only(right: 8.w),
                      padding: EdgeInsets.symmetric(
                        horizontal: 5.w,
                        vertical: 5.h,
                      ),
                      child: Center(
                        child: Text(
                          widget.size[index] ?? "",
                          style: TextStyle(
                            color: isSelected ? AppColors.primaryColor : Colors.black,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20.h),
            if (widget.color.isNotEmpty && widget.color.first != null) ...[
              Text(
                "Rang:",
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 8.h),
              SizedBox(
                height: 40.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.color.length,
                  itemBuilder: (context, index) {
                    final colorName = widget.color[index] ?? '';
                    final isSelected = selectedColor == colorName;

                    return InkWell(
                      onTap: () {
                        setState(() {
                          selectedColor = colorName;
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 8.w),
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(
                            color: isSelected ? AppColors.primaryColor : Colors.black26,
                            width: 2,
                          ),
                          color: isSelected ? AppColors.primaryColor.withOpacity(0.1) : Colors.white,
                        ),
                        child: Center(
                          child: Text(
                            colorName,
                            style: TextStyle(
                              color: isSelected ? AppColors.primaryColor : Colors.black,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 15.h),
            ],
            Text(
              "quantity".tr(),
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8.h),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black26),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {
                      if (quantity > 1) {
                        setState(() {
                          quantity--;
                        });
                      }
                    },
                    icon: Icon(
                      Icons.remove,
                      color: quantity > 1 ? AppColors.primaryColor : Colors.grey,
                    ),
                    style: IconButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8.r),
                          bottomLeft: Radius.circular(8.r),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Text(
                      '$quantity',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        quantity++;
                      });
                    },
                    icon: Icon(Icons.add, color: AppColors.primaryColor),
                    style: IconButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(8.r),
                          bottomRight: Radius.circular(8.r),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              "category".tr(),
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.h),
            Text(widget.description, style: TextStyle(fontSize: 14.sp)),
            SizedBox(height: 16.h),
            Text(
              "${(double.parse(widget.price[selectedPriceIndex]) * quantity).toStringAsFixed(2)} so’m",
              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12.h),
            MonthlyPaymentWidget(
              monthlyPrice6: (double.parse(monthlyPrice6) * quantity).toStringAsFixed(2),
              monthlyPrice12: (double.parse(monthlyPrice12) * quantity).toStringAsFixed(2),
              monthlyPrice15: (double.parse(monthlyPrice15) * quantity).toStringAsFixed(2),
              monthlyPrice18: (double.parse(monthlyPrice18) * quantity).toStringAsFixed(2),
              monthlyPrice24: (double.parse(monthlyPrice24) * quantity).toStringAsFixed(2),
            ),
            SizedBox(height: 12.h),
            Text("installment_info".tr(), style: TextStyle(fontSize: 12.sp)),
            SizedBox(height: 12.h),
            Container(
              padding: EdgeInsets.all(12.h),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black12),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "delivery_1_day".tr(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    "free_delivery_note".tr(),
                    style: TextStyle(fontSize: 12.sp),
                  ),
                  SizedBox(height: 6.h),
                  Divider(),
                  Text("best_offer".tr(), style: TextStyle(fontSize: 12.sp)),
                  SizedBox(height: 20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.network(
                          'https://play-lh.googleusercontent.com/3-SjBcOR1EonQYtlIkeL_a2u1nrM6c7PwoltUOxOCV_XSzTHI6c3_o1T1AOzOPK_sx4=w480-h960',
                          height: 50.h,
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.network(
                          'https://play-lh.googleusercontent.com/gpCCxx5cQuXcYP10PgmXUlbtBWPGRqmrjIjZEUsgexAvJLpvJgS-WrihNlEi4FFOgaY',
                          height: 50.h,
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.network(
                          'https://jet-back.bank.uz/uploads/avatars/513eefc4c64061c628c080655b8f54cd.png',
                          height: 50.h,
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.network(
                          'https://tafreklama-2024.marketing.uz/uploads/cases/f286c95659c8.jpg',
                          height: 50.h,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30.h),
                ],
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                basketProductCount += 1;
                BasketModel? existingBasketModel = HiveBoxes.basketData.get(widget.productId);
                if (existingBasketModel != null) {
                  int existingQuantity = int.parse(existingBasketModel.quantity!);
                  existingBasketModel.quantity = (existingQuantity + quantity).toString();
                  HiveBoxes.basketData.put(widget.productId, existingBasketModel);
                } else {
                  BasketModel basketModel = BasketModel(
                    branchName: widget.branchName,
                    productId: widget.productId,
                    variantId: widget.variantId,
                    title: widget.title,
                    color: selectedColor,
                    size: selectedSize.toString(),
                    description: widget.description,
                    price: widget.price[selectedPriceIndex],
                    monthlyPrice3: monthlyPrice3,
                    monthlyPrice6: monthlyPrice6,
                    monthlyPrice12: monthlyPrice12,
                    monthlyPrice24: monthlyPrice24,
                    image: widget.images.first,
                    isAvailable: widget.isAvailable,
                    quantity: quantity.toString(),
                  );
                  HiveBoxes.basketData.put(widget.productId, basketModel);
                }
                BasketNotifier.updateNewBasketProduct(basketProductCount.toString());
                SharedPreferencesService.instance.saveString(
                  "newBasketProduct",
                  basketProductCount.toString(),
                );
                setState(() {});
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.white,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    margin: EdgeInsets.all(12),
                    duration: Duration(seconds: 1),
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 24,
                            ),
                            SizedBox(width: 8),
                            Text(
                              "product_added".tr(),
                              style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        TextButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BasketPage(),
                              ),
                            );
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                              horizontal: 5,
                              vertical: 6,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: Icon(Icons.shopping_cart, size: 12),
                          label: Text("cart".tr()),
                        ),
                      ],
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50.h),
                backgroundColor: const Color(0xFFDCB04B),
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text(
                "add_to_cart".tr(),
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.white,
                ),
              ),
            ),
            SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}