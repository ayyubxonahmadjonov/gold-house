import 'package:easy_localization/easy_localization.dart';
import 'package:pinput/pinput.dart';

import '../../../../../core/constants/app_imports.dart';

class OtpScreen extends StatefulWidget {
   final String phoneNumber;
   OtpScreen({super.key, required this.phoneNumber});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  TextEditingController otpController = TextEditingController();
String phone_number = '';

  @override
  void initState() {
    super.initState();
    phone_number = SharedPreferencesService.instance.getString("phone") ?? '';
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white),
      body: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            child: BlocConsumer<OtpVerificationBloc, OtpVerificationState>(
              listener: (context, state) {
            if(state is OtpVerificationSuccess){
              Navigator.pushAndRemoveUntil(

                context,
                MaterialPageRoute(
                  builder: (context) => const  MainScreen(),
                  
                ),
                (route) => false,
              
              );
            }
            if(state is OtpVerificationError){
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
            }
              },
              builder: (context, state) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 50.h),
                    Text(
                      "${'sms_sent'.tr()}:\n ${phone_number}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15.sp,
                        color: Color(0xFF757575),
                      ),
                    ),
                    // const SizedBox(height: 16),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                    ),
                    Pinput(
                    
                      length: 6,
                      controller: otpController,
                    ),
                    SizedBox(height: 50.h),
                    CustomButton(
                    
                      title: "verify".tr(),
                      onPressed: () {
                        BlocProvider.of<OtpVerificationBloc>(context).add(OtpVerificationWithPhone(phone_number: phone_number, verification_code: otpController.text));
                      }, bacColor: Colors.yellow, textColor: Colors.black, fontWeight: FontWeight.w600, fontSize: 20, borderRadius: 5, width: 330.w, height: 50.h,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.2,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignUpScreen(),
                          ),
                        );
                      },
                      child: Text(
                        "change_number".tr(),
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15.sp,
                          color: Color(0xFF757575),
                        ),
                      ),
                    ),
                
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

const authOutlineInputBorder = OutlineInputBorder(
  borderSide: BorderSide(color: Color(0xFF757575)),
  borderRadius: BorderRadius.all(Radius.circular(12)),
);

