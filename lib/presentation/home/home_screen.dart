import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gold_house/core/constants/app_imports.dart';
import 'package:gold_house/core/langugage_notifier.dart';
import 'package:gold_house/data/models/favorite_product_model.dart';
import 'package:gold_house/data/models/product_model.dart';
import 'package:gold_house/presentation/screens/favorite/favorite_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isMore = false;
  String searchQuery = "";
  TextEditingController searchController = TextEditingController();
  String selectedBusiness = "";
  Key carouselKey = UniqueKey();
  int itemsToShow = 20;

  @override
  void initState() {
    super.initState();
    selectedBusiness = SharedPreferencesService.instance.getString("selected_business") ?? "Stroy Baza №1";
    BlocProvider.of<GetProductsBloc>(context).add(
      GetProductsByBranchIdEvent(
        branchId: selectedBusiness == "Stroy Baza №1"
            ? "0"
            : selectedBusiness == "Giaz Mebel"
                ? "1"
                : "2",
      ),
    );
  }

Future<void> _toggleFavorite(Product product) async {
  final key = product.id.toString(); 
  if (HiveBoxes.favoriteProduct.containsKey(key)) {
    HiveBoxes.favoriteProduct.delete(key);
  } else {
    HiveBoxes.favoriteProduct.put(key, FavoriteProductModel.fromProduct(product));
  }
  setState(() {}); // UI yangilanadi
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
              Container(
                color: AppColors.primaryColor,
                child: Column(
                  children: [
                    SizedBox(height: 40.h),
                    Image.asset(
                      selectedBusiness == "Stroy Baza №1"
                          ? "assets/images/applogo1.jpg"
                          : selectedBusiness == "Giaz Mebel"
                              ? "assets/images/giazmebel1.jpg"
                              : "assets/images/goldklinker1.jpg",
                      width: 70.w,
                      height: 70.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: CustomSearchbar(
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
                            prefixicon: const Icon(Icons.search),
                          ),
                        ),
                        IconButton(
                          iconSize: 30,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const FavoritesScreen(),
                              ),
                            );
                          },
                          color: AppColors.red,
                          icon: const Icon(Icons.favorite_border),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SelectableRow(
                onBusinessChanged: (business) {
                  setState(() {
                    selectedBusiness = business;
                    carouselKey = UniqueKey(); // Refresh carousel on business change
                    itemsToShow = 20; // Reset items to show
                    BlocProvider.of<GetProductsBloc>(context).add(
                      GetProductsByBranchIdEvent(
                        branchId: selectedBusiness == "Stroy Baza №1"
                            ? "0"
                            : selectedBusiness == "Giaz Mebel"
                                ? "1"
                                : "2",
                      ),
                    );
                  });
                },
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomCarousel(
                        key: carouselKey,
                        branchId: selectedBusiness == "Stroy Baza №1"
                            ? "0"
                            : selectedBusiness == "Giaz Mebel"
                                ? "1"
                                : selectedBusiness == "Goldklinker"
                                    ? "2"
                                    : "0",
                      ),
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
                              return LanguageNotifier.selectedLanguage.value == "uz"
                                  ? product.nameUz.toLowerCase().contains(searchQuery.toLowerCase())
                                  : LanguageNotifier.selectedLanguage.value == "ru"
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
                                    final isFavorite = HiveBoxes.favoriteProduct.containsKey(product.id.toString());

                                    return InkWell(
                                      onTap: () {
                                        if (product.isAvailable) {
                                          Navigator.of(context, rootNavigator: false).push(
                                            MaterialPageRoute(
                                              builder: (context) => ProductDescriptionPage(
                                                branchName: product.branch.toString(),
                                                variantId: product.variants[0].id,
                                                productId: product.id.toString(),
                                                isAvailable: product.variants[0].isAvailable,
                                                images: product.variants.map((e) => e.image).toList(),
                                                title: LanguageNotifier.selectedLanguage.value == "uz"
                                                    ? product.nameUz
                                                    : LanguageNotifier.selectedLanguage.value == "ru"
                                                        ? product.nameRu
                                                        : product.nameEn,
                                                color: LanguageNotifier.selectedLanguage.value == "uz"
                                                    ? product.variants.map((e) => e.colorUz).toList()
                                                    : LanguageNotifier.selectedLanguage.value == "ru"
                                                        ? product.variants.map((e) => e.colorRu).toList()
                                                        : product.variants.map((e) => e.colorEn).toList(),
                                                size: LanguageNotifier.selectedLanguage.value == "uz"
                                                    ? product.variants.map((e) => e.sizeUz).toList()
                                                    : LanguageNotifier.selectedLanguage.value == "ru"
                                                        ? product.variants.map((e) => e.sizeRu).toList()
                                                        : product.variants.map((e) => e.sizeEn).toList(),
                                                description: LanguageNotifier.selectedLanguage.value == "uz"
                                                    ? product.descriptionUz!
                                                    : LanguageNotifier.selectedLanguage.value == "ru"
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
                                        } else {
                                          CustomAwesomeDialog.showInfoDialog(
                                            context,
                                            title: "Mahsulot mavjud emas".tr(),
                                            desc: "Afsuski bu mahsulot Omborda qolmadi. Tez orada biz uni olib kelamiz".tr(),
                                          );
                                        }
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
                                                child: CachedNetworkImage(
                                                  imageUrl: "https://backkk.stroybazan1.uz${product.image}",
                                                  placeholder: (ctx, url) => _buildShimmerBox(height: 160.h, width: 160.w),
                                                  errorWidget: (ctx, url, err) => _buildShimmerBox(height: 160.h, width: 160.w),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              LanguageNotifier.selectedLanguage.value == "uz"
                                                  ? product.nameUz
                                                  : LanguageNotifier.selectedLanguage.value == "ru"
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
                                                  "${"price".tr()}: ${product.variants[0].price} UZS",
                                                  style: TextStyle(
                                                    fontSize: 12.sp,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                const SizedBox(width: 5),
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
      )
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
                                    child: Text("Yana 20 ta ko'rish".tr()),
                                  ),
                              ],
                            );
                          } else {
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