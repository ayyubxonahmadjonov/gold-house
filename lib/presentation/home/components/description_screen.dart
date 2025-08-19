import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gold_house/core/constants/app_colors.dart';
import 'package:gold_house/presentation/home/components/monthly_payment.dart';

class ProductDescriptionPage extends StatelessWidget {
  final String title;
  final String color;
  final String size;
  final String description;
  final String price;
  final String monthlyPrice3;
  final String monthlyPrice6;
  final String monthlyPrice12;
  final String monthlyPrice24;
  final String image;
  final bool isAvailable;

  const ProductDescriptionPage({
    super.key,
    required this.image,
    required this.isAvailable,
    required this.title,
    required this.color,
    required this.size,
    required this.description,
    required this.price,
    required this.monthlyPrice3,
    required this.monthlyPrice6,
    required this.monthlyPrice12,
    required this.monthlyPrice24,

  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
surfaceTintColor: AppColors.white,
        backgroundColor: AppColors.white,
        leading: const BackButton(),
        title: Text(title),
        actions: const [Icon(Icons.favorite_border), SizedBox(width: 16)],
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
                  Image.network('https://backkk.stroybazan1.uz$image', height: 200.h, fit: BoxFit.contain,),
                  SizedBox(height: 10.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.circle, size: 10.sp, color: Colors.black),
                      SizedBox(width: 4.w),
                      Icon(
                        Icons.circle_outlined,
                        size: 10.sp,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.h),

            // Color
            Text(
              isAvailable ? 'Mavjud' : 'Mavjud emas',
              style: TextStyle(color: Colors.green, fontSize: 14.sp),
            ),
            SizedBox(height: 6.h),
            Text(
              title,
              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 6.h),
          if(color.isNotEmpty)  Text("Rang : $color", style: TextStyle(fontSize: 14.sp)),

            SizedBox(height: 12.h),
            // Thumbnails
            SizedBox(
              height: 60.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (_, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Image.asset(
                      'assets/images/penopleks.png',
                      width: 60.w,
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 12.h),
            Text("O‘lchami (Metr²): $size"),

            SizedBox(height: 12.h),
            // Sizes
Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 10.h,
                    horizontal: 14.w,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black26),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(size),
                ),
            
            SizedBox(height: 20.h),
            Text(
              "Tasnif",
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.h),
            Text(description, style: TextStyle(fontSize: 14.sp)),

            SizedBox(height: 16.h),
            Text(
              "$price so’m",
              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 12.h),
MonthlyPaymentWidget(
  monthlyPrice3: monthlyPrice3,
  monthlyPrice6: monthlyPrice6,
  monthlyPrice12: monthlyPrice12,
  monthlyPrice24: monthlyPrice24,
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
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(16.h),
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFDCB04B),
            padding: EdgeInsets.symmetric(vertical: 16.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          child: Text(
            "Savatchaga qo‘shish",
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
