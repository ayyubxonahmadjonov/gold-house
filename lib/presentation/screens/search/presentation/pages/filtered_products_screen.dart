import 'package:gold_house/core/constants/app_imports.dart';
import 'package:gold_house/data/models/favorite_product_model.dart';
import 'package:gold_house/data/models/product_model.dart';

class FilteredProductsScreen extends StatefulWidget {
  final String branchId;
  const FilteredProductsScreen({super.key, required this.branchId});

  @override
  State<FilteredProductsScreen> createState() => _FilteredProductsScreenState();
}

class _FilteredProductsScreenState extends State<FilteredProductsScreen> {
  Set<int> favoriteProducts = {};

  bool isMore = false;
  @override
  void initState() {
    super.initState();
    _loadFavorites();
    BlocProvider.of<GetProductsBloc>(
      context,
    ).add(GetProductsByBranchIdEvent(branchId: widget.branchId));
  }

  Future<void> _loadFavorites() async {
    final favList =
        SharedPreferencesService.instance.getStringList("favorites") ?? [];
    setState(() {
      favoriteProducts = favList.map((e) => int.parse(e)).toSet();
    });
  }

  Future<void> _toggleFavorite(Product product) async {
    setState(() {
      if (favoriteProducts.contains(product.id)) {
        favoriteProducts.remove(product.id);
      } else {
        favoriteProducts.add(product.id);
      }
    });

    // SharedPreferences ga yozish
    await SharedPreferencesService.instance.saveStringList(
      "favorites",
      favoriteProducts.map((e) => e.toString()).toList(),
    );

    if (HiveBoxes.favoriteProduct.containsKey(product.id)) {
      HiveBoxes.favoriteProduct.delete(product.id);
    } else {
      HiveBoxes.favoriteProduct.put(
        product.id,
        FavoriteProductModel.fromProduct(product),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BlocConsumer<GetProductsBloc, GetProductsState>(
                    listener: (context, state) {
                      if (state is GetProductsError) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(state.message)));
                      }
                    },
                    builder: (context, state) {
                      if (state is GetProductsSuccess) {
                        return Padding(
                          padding: EdgeInsets.only(top: 50.h),
                          child: GridView.builder(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 8.h,
                              
                            ),
                            itemCount: state.products.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                  childAspectRatio: 0.77,
                                ),
                            itemBuilder: (context, index) {
                              final product = state.products[index];
                              final isFavorite = favoriteProducts.contains(
                                product.id,
                              );

                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => ProductDescriptionPage(
                                            branchName: product.branch.toString(),
                                            variantId: product.variants[0].id,
                                            productId: product.id.toString(),
                                            isAvailable:
                                                product.variants[0].isAvailable,
                                            images:
                                                product.variants
                                                    .map((e) => e.image)
                                                    .toList(),
                                            title: product.nameUz,
                                            color:
                                                product.variants[0].colorUz ??
                                                "",
                                            size:
                                                [product.variants[0].sizeUz ??
                                                ""],
                                            description:
                                                product.descriptionUz ?? "",
                                            price:
                                                product.variants[0].price
                                                    .toString(),
                                            monthlyPrice3:
                                                product
                                                    .variants[0]
                                                    .monthlyPayment3
                                                    .toString(),
                                            monthlyPrice6:
                                                product
                                                    .variants[0]
                                                    .monthlyPayment6
                                                    .toString(),
                                            monthlyPrice12:
                                                product
                                                    .variants[0]
                                                    .monthlyPayment12
                                                    .toString(),
                                            monthlyPrice24:
                                                product
                                                    .variants[0]
                                                    .monthlyPayment24
                                                    .toString(),
                                          ),
                                    ),
                                  );
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Rasm
                                      ClipRRect(
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(16.r),
                                        ),
                                        child: Image.network(
                                          "https://backkk.stroybazan1.uz${product.image}",
                                          height: 140.h,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                          loadingBuilder: (ctx, child, prog) {
                                            if (prog == null) return child;
                                            return _buildShimmerBox(
                                              height: 140.h,
                                              width: double.infinity,
                                            );
                                          },
                                          errorBuilder: (ctx, err, st) {
                                            return _buildShimmerBox(
                                              height: 140.h,
                                              width: double.infinity,
                                            );
                                          },
                                        ),
                                      ),

                                      // Nomi
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 8.w,
                                          vertical: 10.h,
                                        ),
                                        child: Text(
                                          product.nameUz,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),

                                      //  const Spacer(),

                                      // Narx
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 8.w,
                       
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "${product.variants[0].price} UZS",
                                              style: TextStyle(
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.yellow,
                                              ),
                                            ),
                                            IconButton(
                                              icon: Icon(
                                                isFavorite
                                                    ? Icons.favorite
                                                    : Icons.favorite_border,
                                                size: 18.w,
                                              ),
                                              onPressed:
                                                  () =>
                                                      _toggleFavorite(product),
                                              color:
                                                  isFavorite
                                                      ? Colors.red
                                                      : AppColors.yellow,
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
                        // Loading shimmer
                        return Padding(
                          padding: EdgeInsets.only(top: 50.h),
                          child: GridView.builder(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 8.h,
                            ), // 🔥 padding
                            itemCount: 4,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                  childAspectRatio: 0.72,
                                ),
                            itemBuilder: (context, index) {
                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(
                                    10.r,
                                  ), // 🔥 burchak radius 10
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
                                    // Rasm shimmer
                                    ClipRRect(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(10.r),
                                      ),
                                      child: _buildShimmerBox(
                                        height: 140.h,
                                        width: double.infinity,
                                      ),
                                    ),

                                    // Title shimmer
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

                                    // Narx shimmer
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8.w,
                                        vertical: 8.h,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
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

                  SizedBox(height: 30.h),
                ],
              ),
            ),
          ),
        ],
      ),
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
