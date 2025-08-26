import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gold_house/core/constants/app_colors.dart';
import 'package:gold_house/data/datasources/local/hive_helper/hive_names.dart';
import 'package:gold_house/data/models/basket_model.dart';
import 'package:gold_house/presentation/home/components/monthly_payment.dart';
import 'package:gold_house/presentation/screens/basket/presentation/pages/basket.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ProductDescriptionPage extends StatefulWidget {
  final String productId;
  final String title;
  final String color;
  final String size;
  final String description;
  final String price;
  final String monthlyPrice3;
  final String monthlyPrice6;
  final String monthlyPrice12;
  final String monthlyPrice24;
  List<String> images;
  final bool isAvailable;

   ProductDescriptionPage({    

    super.key,
    required this.productId,
    required this.isAvailable,
    required this.title,
    required this.color,
    required this.size,
    required this.description,
    required this.price,
    required this.images,

    required this.monthlyPrice3,
    required this.monthlyPrice6,
    required this.monthlyPrice12,
    required this.monthlyPrice24,

  });

  @override
  State<ProductDescriptionPage> createState() => _ProductDescriptionPageState();
}

class _ProductDescriptionPageState extends State<ProductDescriptionPage> {
  int activeIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
surfaceTintColor: AppColors.white,
        backgroundColor: AppColors.white,
        leading: const BackButton(),
        title: Text(widget.title),
        actions: [IconButton(
          onPressed: (){
            
          },
          icon: Icon(Icons.favorite_border),), SizedBox(width: 16)],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 25.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image slider
            Center(
              child: Column(

                children: [
                if(widget.images.length == 1) Image.network('https://backkk.stroybazan1.uz${widget.images.first}', height: 200.h, fit: BoxFit.contain,),
                
                if(widget.images.length > 1) ...[
                  CarouselSlider.builder(
                    itemCount: widget.images.length,
                    itemBuilder: (context, index, realIndex) {
                      return Image.network(
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
                        'https://backkk.stroybazan1.uz${widget.images[index]}',
                        fit: BoxFit.contain,
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

            // Color
            Text(
              widget.isAvailable ? 'Mavjud' : 'Mavjud emas',
              style: TextStyle(color: Colors.green, fontSize: 15.sp,fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 6.h),
            Text(
              widget.title,
              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 6.h),
          if(widget.color.isNotEmpty)  Text("Rang : ${widget.color}", style: TextStyle(fontSize: 14.sp)),

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
            SizedBox(height: 12.h),
            Text("O‘lchami (Metr²): ${widget.size}"),
            SizedBox(height: 12.h),
            // Sizes
Container(              padding: EdgeInsets.symmetric(
                    vertical: 10.h,
                    horizontal: 14.w,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black26),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(widget.size),
                ),
            
            SizedBox(height: 20.h),
            Text(
              "Tasnif",
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.h),
            Text(widget.description, style: TextStyle(fontSize: 14.sp)),

            SizedBox(height: 16.h),
            Text(
              "${widget.price} so’m",
              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 12.h),
MonthlyPaymentWidget(
  monthlyPrice3: widget.monthlyPrice3,
  monthlyPrice6: widget.monthlyPrice6,
  monthlyPrice12: widget.monthlyPrice12,
  monthlyPrice24: widget.monthlyPrice24,
),
            SizedBox(height: 12.h),
            Text(
              "Siz buyurtmani 3 oydan 24 oygacha muddatli to‘lov evaziga xarid qilishingiz mumkin.",
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
                    "Yetkazib berish 1 kun ichida",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    "Agar 5mln so‘mdan ortiq mahsulotga buyurtma bersangiz yetkazib berish VODIY bo‘ylab bepul.",
                    style: TextStyle(fontSize: 12.sp),
                  ),
                  SizedBox(height: 6.h),
                  Divider(),
                  Text(
                    "Muddatli to‘lovni rasmiylashtirayotganingizda bizdan va hamkorlarimizdan eng maqbul takliflarga ega bo‘lishingiz mumkin.",
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
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
          minimum: EdgeInsets.all(16.h),
        child: ElevatedButton(
          onPressed: () {
        BasketModel basketModel = BasketModel(
          productId: widget.productId,
          title: widget.title,
          color: widget.color,
          size: widget.size,
          description: widget.description,
          price: widget.price,
          monthlyPrice3: widget.monthlyPrice3,
          monthlyPrice6: widget.monthlyPrice6,
          monthlyPrice12: widget.monthlyPrice12,
          monthlyPrice24: widget.monthlyPrice24,
          image: widget.images.first,
          isAvailable: widget.isAvailable,
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
              "Mahsulot savatga qo'shildi",
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
          label: Text("Savatga o'tish"),
        ),
                ],
          ),
        ),
                );
                
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFDCB04B),
            padding: EdgeInsets.symmetric(vertical: 16.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          child: Text(
            "Savatchaga qo‘shish",
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700,color: AppColors.white),
          ),
        ),
      ),
    );
  }
}
