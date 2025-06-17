import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(254, 218, 115, 1),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            children: [
              Container(height: 430.h, color: Color.fromRGBO(254, 218, 115, 1)),
              Container(height: 385.h, color: Color.fromRGBO(252, 196, 46, 1)),
            ],
          ),

          // 🖼️ Bu rasm 430.h bilan 385.h orasiga chiqadi
          Positioned(
            top: 247.h, // moslashtir, 430 dan biroz kam
            child: Image.asset(
              "assets/images/notfound.png",
              width: 300.w,
              height: 300.h,
            ),
          ),
        ],
      ),
    );
  }
}
