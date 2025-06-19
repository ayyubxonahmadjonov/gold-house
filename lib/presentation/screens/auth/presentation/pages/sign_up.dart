import 'package:gold_house/presentation/screens/auth/presentation/pages/sign_in.dart';

import '../../../../../core/constants/app_imports.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

final TextEditingController phoneController = TextEditingController();
String phoneNumber = '';

class _SignUpScreenState extends State<SignUpScreen> {
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
              "Xush kelibsiz!",
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
                  MaterialPageRoute(builder: (context) => SignInScreen()),
                );
              },
              child: Text(
                "Login orqali kirish",
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
