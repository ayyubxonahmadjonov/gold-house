import 'package:flutter/material.dart';
import 'package:gold_house/presentation/auth/otp.dart';
import 'package:gold_house/presentation/auth/sign_in.dart';
import 'package:gold_house/presentation/widgets/custom_intel_phone.dart';
import 'package:gold_house/presentation/widgets/custom_button.dart';

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
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomPhoneForm(
            controller: phoneController,
            onPhoneChanged: (phone) {
              phoneNumber = phone.completeNumber;
              print("bu phone $phoneNumber");
            },
          ),
          SizedBox(height: 50),

          CustomButton(
            title: "Kirish",
            bacColor: Colors.yellow,
            textColor: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16,
            borderRadius: 5,
            width: 300,
            height: 50,
            onPressed:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OtpScreen(phoneNumber: phoneNumber),
                  ),
                ),
          ),

          SizedBox(height: 100),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SignInScreen()),
              );
            },
            child: Text("Login orqali kirish"),
          ),
        ],
      ),
    );
  }
}
