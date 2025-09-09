import 'package:easy_localization/easy_localization.dart';
import 'package:gold_house/core/constants/app_imports.dart';
import 'package:gold_house/data/models/favorite_product_model.dart';


class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late List<FavoriteProductModel> products;
  String selectedLanguage = "";
  String selectedBusiness = "";

  @override
  void initState() {
    super.initState();
    products = HiveBoxes.favoriteProduct.values.toList();
    selectedLanguage =
        SharedPreferencesService.instance.getString("selected_lg") ?? "";
    selectedBusiness =
        SharedPreferencesService.instance.getString("selected_business") ??
            "Stroy Baza №1";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text("favorites".tr()),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      backgroundColor: AppColors.white,
      body: Column(
        children: [
       
          Expanded(
            child: products.isEmpty
                ? Center(
                    child: Text(
                      "Favorites are empty 👀",
                      style: TextStyle(
                          fontSize: 18.sp, fontWeight: FontWeight.w500),
                    ),
                  )
                : GridView.builder(
                    padding: EdgeInsets.all(15.w),
                    itemCount: products.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                    ),
                    itemBuilder: (context, index) {
                      final product = products[index];
                      final name = selectedLanguage == "uz"
                          ? product.nameUz
                          : selectedLanguage == "ru"
                              ? product.nameRu
                              : product.nameEn;

                      return Padding(
                        padding: EdgeInsets.only(left: 0.w),
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
                                borderRadius: BorderRadius.circular(10.r),
                                child: Image.network(
                                  "https://backkk.stroybazan1.uz${product.image}",
                                  fit: BoxFit.cover,
                                  loadingBuilder: (ctx, child, prog) {
                                    if (prog == null) return child;
                                    return _buildShimmerBox(
                                        height: 155.h, width: 155.w);
                                  },
                                  errorBuilder: (ctx, err, st) {
                                    return _buildShimmerBox(
                                        height: 155.h, width: 155.w);
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              "price".tr() + ": ${product.price} UZS",
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
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
