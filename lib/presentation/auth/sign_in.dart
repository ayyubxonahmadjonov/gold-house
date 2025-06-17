import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gold_house/presentation/auth/otp.dart';
import 'package:gold_house/presentation/auth/sign_up.dart';
import 'package:gold_house/presentation/widgets/custom_intel_phone.dart';
import 'package:gold_house/presentation/widgets/custom_button.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

final TextEditingController phoneController = TextEditingController();
String phoneNumber = '';

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 50.h),

            Text(
              "Tizimga kiring!",
              style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 70.h),

            CustomPhoneForm(
              controller: phoneController,
              onPhoneChanged: (phone) {
                phoneNumber = phone.completeNumber;
                print("bu phone $phoneNumber");
              },
            ),
            SizedBox(height: 30.h),

            CustomButton(
              title: "Kirish",
              bacColor: Colors.yellow,
              textColor: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 20,
              borderRadius: 5,
              width: 340.w,
              height: 50.h,
              onPressed:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OtpScreen(phoneNumber: phoneNumber),
                    ),
                  ),
            ),

            const Spacer(),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpScreen()),
                );
              },
              child: Text(
                "Akkaunt yo'qmi",
                style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }
}
