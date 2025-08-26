
import 'package:gold_house/data/models/product_model.dart';

import '../../core/constants/app_imports.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
   final Set<int> favoriteProducts = {};
  bool isMore = false;
  String searchQuery = "";
  TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    BlocProvider.of<GetProductsBloc>(context)
        .add(GetProductsByBranchIdEvent(branchId: "0"));
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
                Image.asset("assets/images/app_logo.png"),
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
                
                  hintText: "Qidirish",
                  prefixicon: Icon(Icons.search),
                ),
                SizedBox(height: 10.h),
              ],
            ),
          ),
          SelectableRow(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomCarousel(),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      "Tavsiya etilgan mahsulotlar",
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
                    return product.nameUz
                        .toLowerCase()
                        .contains(searchQuery.toLowerCase());
                  }).toList();
                        return GridView.builder(
                          itemCount: filteredProducts.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.7,
  
                            
                          ),
                          itemBuilder: (context, index) {
                            final product = filteredProducts[index];
                            final isFavorite =
                                favoriteProducts.contains(product.id);

                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductDescriptionPage(
                                      variantId: product.variants[0].id,
                                      productId: product.id.toString(),
                                      isAvailable:
                                          product.variants[0].isAvailable,
                                      images: product.variants.map((e) => e.image).toList(),
                                      title: product.nameUz,
                                      color:
                                          product.variants[0].colorUz ?? "",
                                      size: product.variants[0].sizeUz ?? "",
                                      description:
                                          product.descriptionUz ?? "",
                                      price: product.variants[0].price
                                          .toString(),
                                      monthlyPrice3: product
                                          .variants[0].monthlyPayment3
                                          .toString(),
                                      monthlyPrice6: product
                                          .variants[0].monthlyPayment6
                                          .toString(),
                                      monthlyPrice12: product
                                          .variants[0].monthlyPayment12
                                          .toString(),
                                      monthlyPrice24: product
                                          .variants[0].monthlyPayment24
                                          .toString(), 
                                    ),
                                  ),
                                );
                              },
                              child: Padding(
                                padding:  EdgeInsets.only(left: 15.w),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                 
                                  children: [
                                    Container(
                                    
                                      height: 155.h,
                                      width: 155.w,
                                      decoration: BoxDecoration(
                                        color: AppColors.white,
                                        borderRadius:
                                            BorderRadius.circular(10.r),
                                      ),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(15.r),
                                        child: Image.network(
                                          "https://backkk.stroybazan1.uz${product.image}",
                                          width: 100.w,
                                          fit: BoxFit.cover,
                                          loadingBuilder: (ctx, child, prog) {
                                            if (prog == null) return child;
                                            return _buildShimmerBox(
                                                height: 160.h, width: 160.w);
                                          },
                                          errorBuilder: (ctx, err, st) {
                                            return _buildShimmerBox(
                                                height: 160.h, width: 160.w);
                                          },
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      product.nameUz,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                                              
                                      children: [
                                        Text(
                                          "Narxi: ${product.variants[0].price} UZS",
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        IconButton(
                                          icon: Icon(
                                            isFavorite
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                            size: 18.w,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              if (isFavorite) {
                                                favoriteProducts
                                                    .remove(product.id);
                                              } else {
                                                favoriteProducts
                                                    .add(product.id);
                                              }
                                            });
                                          },
                                          color: isFavorite
                                              ? Colors.red
                                              : AppColors.yellow,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      } else {
                        // Loading shimmer
                        return GridView.builder(
                          itemCount: 4,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.7,
                          ),
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.symmetric(horizontal: 5.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildShimmerBox(
                                      height: 160.h, width: 160.w),
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
