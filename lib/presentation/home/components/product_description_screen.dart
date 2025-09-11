import 'package:easy_localization/easy_localization.dart';
import 'package:gold_house/bloc/bloc/get_productbyid_bloc.dart';
import 'package:gold_house/core/constants/app_imports.dart';

class ProductDescriptionPage2 extends StatefulWidget {
  final String productId;

  const ProductDescriptionPage2({super.key, required this.productId});

  @override
  State<ProductDescriptionPage2> createState() =>
      _ProductDescriptionPage2State();
}

class _ProductDescriptionPage2State extends State<ProductDescriptionPage2> {
  String selectedLanguage = "";
  int activeIndex = 0;

  @override
  void initState() {
    super.initState();
    selectedLanguage =
        SharedPreferencesService.instance.getString("selected_lg") ?? "";
    context
        .read<GetProductbyidBloc>()
        .add(GetProductDataEvent(productId: widget.productId));
  }

  String _getLocalizedText(String? uz, String? ru, String? en) {
    if (selectedLanguage == "uz") return uz ?? "";
    if (selectedLanguage == "ru") return ru ?? "";
    return en ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        surfaceTintColor: AppColors.white,
        backgroundColor: AppColors.white,
        leading: const BackButton(),

      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 25.h),
        child: BlocBuilder<GetProductbyidBloc, GetProductbyidState>(
          builder: (context, state) {
            if (state is GetProductbyidLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is GetProductbyidError) {
              return Center(child: Text(state.message));
            }
            if (state is GetProductbyidSuccess) {
              final product = state.product;
              final variants = product.variants;


              final mainVariant = variants.isNotEmpty ? variants.first : null;

              List<String> images = [];
              for (var v in variants) {
                images.add(v.image);
              }
              if (images.isEmpty && product.image.isNotEmpty) {
                images.add(product.image);
              }

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Images
                    if (images.isNotEmpty) ...[
                      CarouselSlider.builder(
                        itemCount: images.length,
                        itemBuilder: (context, index, realIndex) {
                          return Image.network(
                            'https://backkk.stroybazan1.uz${images[index]}',
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  height: 200.h,
                                  width: double.infinity,
                                  color: Colors.white,
                                ),
                              );
                            },
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
                        count: images.length,
                        effect: ExpandingDotsEffect(
                          dotHeight: 6,
                          dotWidth: 6,
                          activeDotColor: Colors.black,
                          dotColor: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 12.h),
                    ],

                    // Availability
                    Text(
                      product.isAvailable ? "Mavjud" : "Mavjud emas",
                      style: TextStyle(
                        color: product.isAvailable ? Colors.green : Colors.red,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 6.h),

                    // Name
                    Text(
                      _getLocalizedText(
                        product.nameUz,
                        product.nameRu,
                        product.nameEn,
                      ),
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 6.h),

                    // Color
                    if (mainVariant?.colorEn != null &&
                        mainVariant!.colorEn!.isNotEmpty)
                      Text(
                        "Rang: ${_getLocalizedText(mainVariant.colorUz, mainVariant.colorRu, mainVariant.colorEn)}",
                        style: TextStyle(fontSize: 14.sp),
                      ),
                    SizedBox(height: 12.h),

                    // Size
                    if (mainVariant?.sizeEn != null &&
                        mainVariant!.sizeEn!.isNotEmpty)
                      Text(
                        "O‘lcham: ${_getLocalizedText(mainVariant.sizeUz, mainVariant.sizeRu, mainVariant.sizeEn)}",
                        style: TextStyle(fontSize: 14.sp),
                      ),
                    SizedBox(height: 12.h),

                    // Description
                    Text(
                      _getLocalizedText(
                        product.descriptionUz,
                        product.descriptionRu,
                        product.descriptionEn,
                      ),
                      style: TextStyle(fontSize: 14.sp),
                    ),
                    SizedBox(height: 16.h),

                    // Price
                    if (mainVariant != null) ...[
                      Text(
                        "${mainVariant.price.toStringAsFixed(0)} so‘m",
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 12.h),

                      // Monthly payment
                      MonthlyPaymentWidget(
                        monthlyPrice3: mainVariant.monthlyPayment3.toString(),
                        monthlyPrice6: mainVariant.monthlyPayment6.toString(),
                        monthlyPrice12: mainVariant.monthlyPayment12.toString(),
                        monthlyPrice24: mainVariant.monthlyPayment24.toString(),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        "installment_info".tr(),
                        style: TextStyle(fontSize: 12.sp),
                      ),
                                  SizedBox(height: 12.h),
            // Delivery Info
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
                  Text(
                    "best_offer".tr(),
                    style: TextStyle(fontSize: 12.sp),
                  ),

                  SizedBox(height: 20.h),
                  // Payment Logos
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
                          'https://tse4.mm.bing.net/th?id=OIP.tDvvuWpJKpafO_tOMB-Y6QAAAA&pid=Api&P=0&h=220',
                          height: 50.h,
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),

                        child: Image.network(
                          'https://play-lh.googleusercontent.com/9nfyAySpxZMk01BxNNSMfir6UUW5PJ3aLlYx_ysmCtTwTpRQrMCJwfyFuHA5-Sf4fw',
                          height: 50.h,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 30.h),
     
                ],
              ),
            ),
      SizedBox(height: 30,),
              
                    ElevatedButton(
          onPressed: () {
        BasketModel basketModel = BasketModel(
          branchName: "",
          productId: widget.productId,
          variantId: state.product.variants.first.id,
          title: state.product.nameUz,
          color: state.product.variants.first.colorUz??"",
          size: state.product.variants.first.sizeUz??"",
          description: state.product.descriptionUz??"",
          price: state.product.variants.first.price.toString(),
          monthlyPrice3: state.product.variants.first.monthlyPayment3.toString(),
          monthlyPrice6: state.product.variants.first.monthlyPayment6.toString(),
          monthlyPrice12: state.product.variants.first.monthlyPayment12.toString(),
          monthlyPrice24: state.product.variants.first.monthlyPayment24.toString(),
          image: state.product.variants.first.image,
          isAvailable: state.product.variants.first.isAvailable,
        );
        HiveBoxes.basketData.put(widget.productId, basketModel);
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
            Icon(Icons.check_circle, color: Colors.green, size: 24),
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
           Navigator.push(context, MaterialPageRoute(builder: (context) => const BasketPage()));
          },
          style: TextButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 6),
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
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700,color: AppColors.white),
          ),
        ),
    
      SizedBox(height: 50,),
     
                    ],
                  ],
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
