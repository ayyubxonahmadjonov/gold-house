import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gold_house/core/constants/app_colors.dart';
import 'package:gold_house/presentation/widgets/custom_carousel.dart';
import 'package:gold_house/presentation/widgets/custom_searchbar.dart';
import 'package:gold_house/presentation/widgets/selected_row.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          /// Tepadagi qism scroll bo‘lmasligi kerak
          Container(
            color: AppColors.primaryColor,
            child: Column(
              children: [
                SizedBox(height: 70.h),
                Image.asset("assets/images/app_logo.png"),
                CustomSearchbar(
                  hintText: "Qidirish",
                  prefixicon: Icon(Icons.search),
                ),
              ],
            ),
          ),
          SelectableRow(),

          /// Scroll bo‘lishi kerak bo‘lgan qism
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Carousel
                  CustomCarousel(
                    images: [
                      "https://windows10spotlight.com/wp-content/uploads/2023/01/81a6e74c8adbf7f55406e8c4b80669d5.jpg",
                      "https://i.pinimg.com/originals/dc/55/a7/dc55a7baa9cbd457221ae6d12d9b1b51.jpg",
                      "https://cdn.wallpapersafari.com/30/62/jHBzTk.jpg",
                    ],
                  ),

                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "Tavsiya etilgan mahsulotlar",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  /// GridView.builder scroll emas, faqat ichidan joy oladi
                  GridView.builder(
                    itemCount: 8,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,

                      childAspectRatio: 0.7,
                    ),
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 10.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 160.h,
                              width: 160.w,
                              decoration: BoxDecoration(
                                color: AppColors.whitegrey,
                                borderRadius: BorderRadius.circular(10.r),
                                border: Border.all(
                                  color: Colors.black.withOpacity(0.5),
                                ),
                              ),
                              child: Image.asset(
                                "assets/images/penopleks.png",
                                width: 120.w,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "PENOPLEKS",
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 10.h),
                            Row(
                              children: [
                                Text(
                                  "Narxi:9.999 UZS",
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                ImageIcon(
                                  AssetImage("assets/icons/basket.png"),
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
                                  color:
                                      isFavorite
                                          ? Colors.red
                                          : AppColors.yellow,
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
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
}
