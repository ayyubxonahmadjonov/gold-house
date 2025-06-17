import 'package:flutter/material.dart';
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
            },
          ),
          SizedBox(height: 50),
          Text(phoneNumber),
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
                MaterialPageRoute(builder: (context) => SignUpScreen()),
              );
            },
            child: Text("Accaunt yo'qmi?"),
          ),
        ],
      ),
    );
  }
}
