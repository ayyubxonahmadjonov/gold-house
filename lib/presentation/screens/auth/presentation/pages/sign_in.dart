import 'package:easy_localization/easy_localization.dart';

import '../../../../../core/constants/app_imports.dart';

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
      body: BlocConsumer<AuthLoginBloc, AuthLoginState>(
        listener: (context, state) {
          if (state is AuthLoginSuccess) {
             SharedPreferencesService.instance.saveString("phone", phoneNumber);
            print('phone numbersignin: $phoneNumber');
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OtpScreen(phoneNumber: phoneNumber),
              ),
            );
          }
          if (state is AuthLoginError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 50.h),

              Text(
                "sign_in".tr(),
                style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 70.h),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: CustomPhoneForm(
                  controller: phoneController,
                  onPhoneChanged: (phone) {
                    phoneNumber = phone.completeNumber;
                  },
                ),
              ),
              SizedBox(height: 50.h),

              CustomButton(
                title:
                    state is AuthLoginLoading ? "loading".tr() : "login".tr(),
                bacColor: Colors.yellow,
                textColor: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 20,
                borderRadius: 5,
                width: 340.w,
                height: 50.h,
                onPressed: () {
                     if (phoneNumber.isEmpty) {
                    phoneNumber = phoneController.text;
                  }
                  BlocProvider.of<AuthLoginBloc>(
                    context,
                  ).add(AuthLoginPhoneEvent(phone: phoneNumber));
                },
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
                  "no_account".tr(),
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              SizedBox(height: 80.h),
            ],
          );
        },
      ),
    );
  }
}
