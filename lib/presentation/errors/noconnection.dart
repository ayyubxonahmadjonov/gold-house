import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NoConnectionScreen extends StatefulWidget {
  const NoConnectionScreen({super.key});

  @override
  State<NoConnectionScreen> createState() => _NoConnectionScreenState();
}

class _NoConnectionScreenState extends State<NoConnectionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Image.asset(
              "assets/images/noconnection.png",
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 15.h),
          Text(
            "Ulanishda xatolik yuz berdi",
            style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 15.h),

          Text(
            "Internet provayderiga ulanganligingizni \n                       tekshiring!",

            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }
}
