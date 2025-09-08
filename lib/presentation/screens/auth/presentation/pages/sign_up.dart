
import 'package:easy_localization/easy_localization.dart';
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<AuthRegisterBloc, AuthRegisterState>(
        listener: (context, state) {
          if (state is AuthRegisterSuccess) {
            SharedPreferencesService.instance.saveString("phone", phoneNumber);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => OtpScreen(phoneNumber: phoneNumber)),
            );
          }
          if (state is AuthRegisterError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }

        },
        builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 50.h),

              Text(
                "welcome".tr(),
                style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 70.h),

              CustomPhoneForm(
                controller: phoneController,
                onPhoneChanged: (phone) {
                  phoneNumber = phone.completeNumber;
                },
              ),
              SizedBox(height: 30.h),
              CustomButton(
                title:   state is AuthRegisterLoading ? "loading".tr() : "login".tr(),
                bacColor: Colors.yellow,
                textColor: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 20,
                borderRadius: 5,
                width: 340.w,
                height: 50.h,
                onPressed:() {
                  context.read<AuthRegisterBloc>().add(AuthRegisterWithPhone(phone: phoneNumber));
                },   
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
                  "login_with".tr(),
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(height: 30.h),
            ],
          );
        },
      ),
    );
  }
}
