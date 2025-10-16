import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gold_house/core/constants/app_imports.dart';
import 'package:gold_house/core/utils/langugage_notifier.dart';
import 'package:gold_house/data/models/favorite_product_model.dart';
import 'package:gold_house/data/models/product_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class FilteredProductsScreen extends StatefulWidget {
  final String branchId;
  final String categoryId;
  const FilteredProductsScreen({
    super.key,
    required this.branchId,
    required this.categoryId,
  });

  @override
  State<FilteredProductsScreen> createState() => _FilteredProductsScreenState();
}

class _FilteredProductsScreenState extends State<FilteredProductsScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<GetProductsBloc>(context).add(
      GetProductsByBranchIdEvent(branchId: widget.branchId),
    );
  }

  Future<void> _toggleFavorite(Product product) async {
    final key = product.id.toString();
    if (HiveBoxes.favoriteProduct.containsKey(key)) {
      await HiveBoxes.favoriteProduct.delete(key);
    } else {
      await HiveBoxes.favoriteProduct.put(key, FavoriteProductModel.fromProduct(product));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: LanguageNotifier.selectedLanguage,
      builder: (context, language, child) {
        return Scaffold(
          backgroundColor: AppColors.white,
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: BlocConsumer<GetProductsBloc, GetProductsState>(
                    listener: (context, state) {
                      if (state is GetProductsError) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(state.message.tr())),
                        );
                      }
                    },
                    builder: (context, state) {
                      if (state is GetProductsSuccess) {
                        final filteredProducts = state.products.where((p) {
                          return p.category.toString() == widget.categoryId;
                        }).toList();

                        if (filteredProducts.isEmpty) {
                          return Center(
                            child: Padding(
                              padding: EdgeInsets.only(top: 100.h),
                              child: Text(
                                "no_products_found".tr(),
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          );
                        }
                        return Padding(
                          padding: EdgeInsets.only(top: 50.h),
                          child: GridView.builder(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 8.h,
                            ),
                            itemCount: filteredProducts.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 0.77,
                            ),
                            itemBuilder: (context, index) {
                              final product = filteredProducts[index];
                              return InkWell(
                                onTap: () {
                                  if (product.isAvailable) {
                                    // Filter color and size lists to exclude null/empty values
                                    List<String> getFilteredList(List<String?> sourceList) {
                                      return sourceList
                                          .where((item) => item != null && item.isNotEmpty)
                                          .cast<String>()
                                          .toList();
                                    }

                                    final colorList = language == "uz"
                                        ? getFilteredList(product.variants.map((e) => e.colorUz).toList())
                                        : language == "ru"
                                            ? getFilteredList(product.variants.map((e) => e.colorRu).toList())
                                            : getFilteredList(product.variants.map((e) => e.colorEn).toList());

                                    final sizeList = language == "uz"
                                        ? getFilteredList(product.variants.map((e) => e.sizeUz).toList())
                                        : language == "ru"
                                            ? getFilteredList(product.variants.map((e) => e.sizeRu).toList())
                                            : getFilteredList(product.variants.map((e) => e.sizeEn).toList());

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ProductDescriptionPage(
                                          branchName: product.branch.toString(),
                                          variantId: product.variants[0].id,
                                          productId: product.id.toString(),
                                          isAvailable: product.variants[0].isAvailable,
                                          images: product.variants.map((e) => e.image).toList(),
                                          title: language == "uz"
                                              ? product.nameUz
                                              : language == "ru"
                                                  ? product.nameRu
                                                  : product.nameEn,
                                          color: colorList,
                                          size: sizeList,
                                          description: language == "uz"
                                              ? product.descriptionUz ?? ""
                                              : language == "ru"
                                                  ? product.descriptionRu ?? ""
                                                  : product.descriptionEn ?? "",
                                          price: product.variants.map((e) => e.price.toString()).toList(),
                                          monthlyPrice3: product.variants[0].monthlyPayment3.toString(),
                                          monthlyPrice6: product.variants[0].monthlyPayment6.toString(),
                                          monthlyPrice12: product.variants[0].monthlyPayment12.toString(),
                                          monthlyPrice24: product.variants[0].monthlyPayment24.toString(),
                                        ),
                                      ),
                                    );
                                  } else {
                                    CustomAwesomeDialog.showInfoDialog(
                                      context,
                                      title: "product_not_available".tr(),
                                      desc: "product_not_in_stock".tr(),
                                    );
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16.r),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Image
                                      ClipRRect(
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(16.r),
                                        ),
                                        child: CachedNetworkImage(
                                          imageUrl: "https://backkk.stroybazan1.uz${product.image}",
                                          height: 140.h,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                          placeholder: (ctx, url) => _buildShimmerBox(
                                            height: 140.h,
                                            width: double.infinity,
                                          ),
                                          errorWidget: (ctx, url, err) => _buildShimmerBox(
                                            height: 140.h,
                                            width: double.infinity,
                                          ),
                                        ),
                                      ),

                                      // Name
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 8.w,
                                          vertical: 10.h,
                                        ),
                                        child: Text(
                                          language == "uz"
                                              ? product.nameUz
                                              : language == "ru"
                                                  ? product.nameRu
                                                  : product.nameEn,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),

                                      // Price and favorite
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 8.w,
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "${"price".tr()}: ${product.variants[0].price} UZS",
                                              style: TextStyle(
                                                fontSize: 11.sp,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.yellow,
                                              ),
                                            ),
                                            ValueListenableBuilder(
                                              valueListenable: HiveBoxes.favoriteProduct.listenable(),
                                              builder: (context, Box<FavoriteProductModel> box, _) {
                                                final isFavorite = box.containsKey(product.id.toString());
                                                return IconButton(
                                                  icon: Icon(
                                                    isFavorite ? Icons.favorite : Icons.favorite_border,
                                                    size: 18.w,
                                                    color: isFavorite ? Colors.red : AppColors.yellow,
                                                  ),
                                                  onPressed: () => _toggleFavorite(product),
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      } else {
                        // Shimmer loading
                        return Padding(
                          padding: EdgeInsets.only(top: 50.h),
                          child: GridView.builder(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 8.h,
                            ),
                            itemCount: 4,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 0.77,
                            ),
                            itemBuilder: (context, index) {
                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10.r),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 6,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(10.r),
                                      ),
                                      child: _buildShimmerBox(
                                        height: 140.h,
                                        width: double.infinity,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8.w,
                                        vertical: 6.h,
                                      ),
                                      child: _buildShimmerBox(
                                        height: 14.h,
                                        width: 100.w,
                                      ),
                                    ),
                                    const Spacer(),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8.w,
                                        vertical: 8.h,
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          _buildShimmerBox(
                                            height: 12.h,
                                            width: 60.w,
                                          ),
                                          _buildShimmerBox(
                                            height: 12.h,
                                            width: 20.w,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildShimmerBox({required double height, required double width}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.grey[500],
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
    );
  }
}