import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gold_house/core/constants/app_colors.dart';
import 'package:gold_house/presentation/widgets/custom_searchbar.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<String> categories = [
    "Penopleks",
    "Teplesk",
    "Kley",
    "Oboy va kraskalar",
    "Bazat",
    "Steklovata",
    "knauf",
    "Folgaizoloyatsiya",
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          Container(
            color: AppColors.primaryColor,
            padding: EdgeInsets.only(top: 60.h, bottom: 10.h),
            child: CustomSearchbar(
              hintText: "Qidirish",
              prefixicon: Icon(Icons.search),
            ),
          ),
          // Bu yerda Faqat Expanded + ListView
          Expanded(
            child: ListView.builder(
              itemCount: categories.length,

              itemBuilder: (context, index) {
                return _buildCategories(categories[index], () {});
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategories(String title, VoidCallback? onTap) {
    return InkWell(
      onTap: onTap,
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
        ),

        trailing: Icon(Icons.navigate_next_outlined, size: 24.sp),
      ),
    );
  }
}
