
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:gold_house/data/models/favorite_product_model.dart';
import 'package:gold_house/data/models/product_model.dart';

import '../../core/constants/app_imports.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
    Set<int> favoriteProducts = {};
  bool isMore = false;
  String searchQuery = "";
  TextEditingController searchController = TextEditingController();
  String selectedBusiness ="";
  String selectedlanguage ="";
    Key carouselKey = UniqueKey();
    int itemsToShow = 20;
  void _onBusinessChanged() {
    setState(() {
      carouselKey = UniqueKey();
    });
  }
  @override
  void initState() {
    super.initState();
    selectedlanguage = SharedPreferencesService.instance.getString("selected_lg") ?? "";
    selectedBusiness = SharedPreferencesService.instance.getString("selected_business") ?? "Stroy Baza №1";
    _loadFavorites();
    BlocProvider.of<GetProductsBloc>(context)
        .add(GetProductsByBranchIdEvent(branchId: selectedBusiness=="Stroy Baza №1" ? "0" : selectedBusiness=="Giaz Mebel" ? "1" : "2"));
  }
    Future<void> _loadFavorites() async {
    final favList = SharedPreferencesService.instance.getStringList("favorites") ?? [];
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
          Container(
            color: AppColors.primaryColor,
            child: Column(
              children: [
                SizedBox(height: 60.h),
                Image.asset(
                  selectedBusiness == "Stroy Baza №1"
                      ? "assets/images/app_logo.png"
                      : selectedBusiness == "Giaz Mebel"
                          ? "assets/images/giaz_mebel.png"
                          : "assets/images/gold_klinker.jpg",
                  width: 80.w,
                  height: 80.h,
                ),
                CustomSearchbar(
                  controller: searchController,
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                  onClear: () {
                    setState(() {
                      searchQuery = "";
                      searchController.clear();
                    });
                  },
                  hintText: "search".tr(),
                  prefixicon: Icon(Icons.search),
                ),
                SizedBox(height: 10.h),
              ],
            ),
          ),
          SelectableRow(
            onBusinessChanged: (business) {
              setState(() {
                selectedBusiness = business;
              });
            },
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   CustomCarousel(branchId: selectedBusiness=="Stroy Baza №1"?"0":selectedBusiness=="Giaz Mebel"?"1":selectedBusiness=="Goldklinker"?"2":"0"),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      "recommended_products".tr(),
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  BlocConsumer<GetProductsBloc, GetProductsState>(
                    listener: (context, state) {
                      if (state is GetProductsError) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(state.message)),
                        );
                      }
                    },
                    builder: (context, state) {
                      if (state is GetProductsSuccess) {
                        List<Product> filteredProducts = state.products.where((product) {
                          if (searchQuery.isEmpty) return true;
                          return selectedlanguage == "uz"
                              ? product.nameUz.toLowerCase().contains(searchQuery.toLowerCase())
                              : selectedlanguage == "ru"
                                  ? product.nameRu.toLowerCase().contains(searchQuery.toLowerCase())
                                  : product.nameEn.toLowerCase().contains(searchQuery.toLowerCase());
                        }).toList();

                        final productsToDisplay = filteredProducts.take(itemsToShow).toList();

                        return Column(
                          children: [
                            GridView.builder(
                              itemCount: productsToDisplay.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.7,
                              ),
                              itemBuilder: (context, index) {
                                final product = productsToDisplay[index];
                                final isFavorite = favoriteProducts.contains(product.id);

                                return InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ProductDescriptionPage(
                                          branchName: product.branch.toString(),
                                          variantId: product.variants[0].id,
                                          productId: product.id.toString(),
                                          isAvailable: product.variants[0].isAvailable,
                                          images: product.variants.map((e) => e.image).toList(),
                                          title: selectedlanguage == "uz"
                                              ? product.nameUz
                                              : selectedlanguage == "ru"
                                                  ? product.nameRu
                                                  : product.nameEn,
                                          color: selectedlanguage == "uz"
                                              ? product.variants[0].colorUz ?? ""
                                              : selectedlanguage == "ru"
                                                  ? product.variants[0].colorRu ?? ""
                                                  : product.variants[0].colorEn ?? "",
                                          size: selectedlanguage == "uz"
                                              ? product.variants.map((e) => e.sizeUz).toList()
                                              : selectedlanguage == "ru"
                                                  ? product.variants.map((e) => e.sizeRu).toList()
                                                  : product.variants.map((e) => e.sizeEn).toList(),
                                          description: selectedlanguage == "uz"
                                              ? product.descriptionUz!
                                              : selectedlanguage == "ru"
                                                  ? product.descriptionRu!
                                                  : product.descriptionEn!,
                                          price: product.variants.map((e) => e.price.toString()).toList(),
                                          monthlyPrice3: product.variants.first.monthlyPayment3.toString(),
                                          monthlyPrice6: product.variants.first.monthlyPayment6.toString(),
                                          monthlyPrice12: product.variants.first.monthlyPayment12.toString(),
                                          monthlyPrice24: product.variants.first.monthlyPayment24.toString(),
                                        ),
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 15.w),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 155.h,
                                          width: 155.w,
                                          decoration: BoxDecoration(
                                            color: AppColors.white,
                                            borderRadius: BorderRadius.circular(10.r),
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(15.r),
                                            child: CachedNetworkImage( // 🚀 cached network image
                                              imageUrl: "https://backkk.stroybazan1.uz${product.image}",
                                              placeholder: (ctx, url) => _buildShimmerBox(height: 160.h, width: 160.w),
                                              errorWidget: (ctx, url, err) =>
                                                  _buildShimmerBox(height: 160.h, width: 160.w),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          selectedlanguage == "uz"
                                              ? product.nameUz
                                              : selectedlanguage == "ru"
                                                  ? product.nameRu
                                                  : product.nameEn,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "price".tr() + ": ${product.variants[0].price} UZS",
                                              style: TextStyle(
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            SizedBox(width: 5),
                                            IconButton(
                                              icon: Icon(
                                                isFavorite ? Icons.favorite : Icons.favorite_border,
                                                size: 18.w,
                                              ),
                                              onPressed: () => _toggleFavorite(product),
                                              color: isFavorite ? Colors.red : AppColors.yellow,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                            if (itemsToShow < filteredProducts.length)
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    itemsToShow += 20;
                                  });
                                },
                                child: Text("Yana 20 ta ko'rish"),
                              ),
                          ],
                        );
                      } else {
                        // loading
                        return GridView.builder(
                          itemCount: 4,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.7,
                          ),
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.symmetric(horizontal: 5.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildShimmerBox(height: 160.h, width: 160.w),
                                  const SizedBox(height: 10),
                                  _buildShimmerBox(height: 15.h, width: 80.w),
                                  const SizedBox(height: 5),
                                  _buildShimmerBox(height: 12.h, width: 120.w),
                                ],
                              ),
                            );
                          },
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
