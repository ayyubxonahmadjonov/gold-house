import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gold_house/core/constants/app_colors.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey),
              ),
              child: ListTile(
                leading: Icon(Icons.person),
                title: Text('Nuraliyev Muhammad Sodiq'),
                subtitle: Text('+998 90 762 92 82'),
              ),
            ),
            SizedBox(height: 20.h),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey),
              ),
              child: Column(
                children: [
                  SizedBox(height: 15.h),

                  _buildCategories("Buyurtmalar", () {}, Icons.store),
                  SizedBox(height: 10.h),

                  _buildCategories(
                    "Keshbek",
                    () {},
                    Icons.account_balance_wallet,
                  ),

                  SizedBox(height: 10.h),

                  _buildCategories("Sevimlilar", () {}, Icons.favorite),

                  SizedBox(height: 15.h),
                ],
              ),
            ),
            SizedBox(height: 20.h),

            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  SizedBox(height: 15.h),

                  _buildCategories(
                    "Shahar tanlash",
                    () {},
                    Icons.location_city,
                  ),

                  SizedBox(height: 15.h),
                  _buildCategories("Til tanlash", () {}, Icons.language),
                  SizedBox(height: 15.h),
                ],
              ),
            ),
            SizedBox(height: 20.h),

            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  SizedBox(height: 15.h),

                  _buildCategories("Qo'llab-quvvatlash", () {}, Icons.info),

                  SizedBox(height: 15.h),
                  InkWell(
                    onTap: () {},
                    child: ListTile(
                      leading: Icon(Icons.exit_to_app, color: Colors.red),
                      title: Text(
                        'Chiqish',
                        style: TextStyle(color: Colors.red, fontSize: 20.sp),
                      ),
                      trailing: Icon(
                        Icons.chevron_right,
                        color: Colors.red,
                        size: 24.sp,
                      ),
                    ),
                  ),
                  SizedBox(height: 15.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategories(String title, VoidCallback? onTap, IconData icon) {
    return InkWell(
      onTap: onTap,
      child: ListTile(
        leading: Icon(icon),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
        ),

        trailing: Icon(Icons.chevron_right, size: 24.sp),
      ),
    );
  }
}
