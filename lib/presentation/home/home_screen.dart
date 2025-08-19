import 'package:shimmer/shimmer.dart';
import 'package:gold_house/presentation/home/components/description_screen.dart';

import '../../core/constants/app_imports.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isFavorite = false;
  bool isMore = false;

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
                
                        return GridView.builder(
                          itemCount: state.products.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.7,
                          ),
                          itemBuilder: (context, index) {
                            state.products[index].variants.length>1?isMore=true:isMore=false;
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductDescriptionPage(
                                      isAvailable: state.products[index].isAvailable,
                                      image: state.products[index].image,
                                      title: state.products[index].nameUz,
                                      color: state.products[index]
                                              .variants[0].colorUz ?? "",
                                        
                                      size: state.products[index]
                                              .variants[0].sizeUz ??
                                          "",
                                      description: state
                                              .products[index].descriptionUz ??
                                          "",
                                      price: state.products[index]
                                          .variants[0].price
                                          .toString(),
                                      monthlyPrice3: state.products[index]
                                          .variants[0].monthlyPayment3
                                          .toString(),
                                      monthlyPrice6: state.products[index]
                                          .variants[0].monthlyPayment6
                                          .toString(),
                                      monthlyPrice12: state.products[index]
                                          .variants[0].monthlyPayment12
                                          .toString(),
                                      monthlyPrice24: state.products[index]
                                          .variants[0].monthlyPayment24
                                          .toString(),
                                      
                                       
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 5.w),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 160.h,
                                      width: 160.w,
                                      decoration: BoxDecoration(
                                        color: AppColors.white,
                                        borderRadius:
                                            BorderRadius.circular(10.r),
                                      ),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(15.r),
                                        child: Image.network(
                                          "https://backkk.stroybazan1.uz${state.products[index].image}",
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
                                    const SizedBox(height: 10),
                                    Text(
                                      state.products[index].nameUz,
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Narxi: ${state.products[index].variants[0].price} UZS",
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        SizedBox(width: 10.w),
                                        ImageIcon(
                                          const AssetImage(
                                              "assets/icons/basket.png"),
                                          size: 16.w,
                                          color: AppColors.yellow,
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            isFavorite
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                            size: 16.w,
                                          ),
                                          onPressed: () {},
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
