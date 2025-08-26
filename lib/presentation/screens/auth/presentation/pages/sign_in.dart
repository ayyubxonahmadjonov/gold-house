
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
           Navigator.push(context, MaterialPageRoute(builder: (context) => OtpScreen(phoneNumber: phoneNumber),)) ;
          }
          if (state is AuthLoginError) {
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
                "Tizimga kiring!",
                style: TextStyle(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w500,
                ),
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
                title: state is AuthLoginLoading ? "Yuklanmoqda..." : "Kirish",
                bacColor: Colors.yellow,
                textColor: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 20,
                borderRadius: 5,
                width: 340.w,
                height: 50.h,
                onPressed:
                    () {
                      context.read<AuthLoginBloc>().add(AuthLoginPhoneEvent(phone: phoneNumber));
                    }
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
