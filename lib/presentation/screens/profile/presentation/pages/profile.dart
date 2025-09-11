import 'package:easy_localization/easy_localization.dart';
import 'package:gold_house/presentation/screens/auth/presentation/pages/sign_in.dart';
import 'package:gold_house/presentation/screens/favorite/favorite_screen.dart';
import 'package:gold_house/presentation/screens/profile/cashback_screen.dart';
import 'package:gold_house/presentation/screens/profile/presentation/pages/show_language_bottom.dart';
import 'package:gold_house/presentation/screens/profile/presentation/pages/update_fullname.dart';
import 'package:gold_house/presentation/widgets/select_city_dialog.dart';
import '../../../../../core/constants/app_imports.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future<void> _launchInstagramUrl(String path) async {
    final Uri url = Uri.parse(path.trim());

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("URL ni ochib bo‘lmadi")));
    }
  }

  ValueNotifier<String> fullname = ValueNotifier<String>(
    "${SharedPreferencesService.instance.getString("profilfullname")}",
  );
  int user_id = 0;
  @override
  void initState() {
    super.initState();

    user_id = SharedPreferencesService.instance.getInt("user_id") ?? 0;
    BlocProvider.of<GetUserDataBloc>(
      context,
    ).add(GetUserAllDataEvent(id: user_id.toString()));
  }

  String selectedCity = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Profile'),
        backgroundColor: AppColors.primaryColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey),
                ),
                child: BlocBuilder<GetUserDataBloc, GetUserDataState>(
                  builder: (context, state) {
        
                    if(state is GetUserDataSuccess){ return ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return UpdateFullname();
                            },
                          ),
                        );
                      },
                      leading: Icon(Icons.person),
                      title: state.user.firstName.isNotEmpty ? Text("${state.user.firstName} ${state.user.lastName}") : Text(""),
                      subtitle: state.user.phoneNumber.isNotEmpty ? Text("${state.user.phoneNumber}") : Text(""),
                    );
                    }
                      else{ 
                     return CustomButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return SignUpScreen();
                            },
                          ),
                          (route) => false,
                        );
                      },
                      title: "register".tr(), bacColor: AppColors.yellow, textColor: AppColors.white, fontWeight: FontWeight.w600, fontSize: 20, borderRadius: 10, width: double.infinity, height: 50.h);
                     
                     
                
                    }
                  
                  },
                ),
              ),
              SizedBox(height: 20.h),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 15.h),
        
                    _buildCategories("orders".tr(), () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return const OrderHistoryScreen();
                          },
                        ),
                      );
                    }, Icons.store),
                    SizedBox(height: 10.h),
        
                    _buildCategories(
                      "cashback".tr(),
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return const CashbackView();
                            },
                          ),
                        );
                      },
                      Icons.account_balance_wallet,
                    ),
        
                    SizedBox(height: 10.h),
        
                    _buildCategories("favorites".tr(), () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return  FavoritesScreen();
                          },
                        ),
                      );
                    }, Icons.favorite),
        
                    SizedBox(height: 15.h),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
        
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 15.h),
        
                    BlocConsumer<GetCitiesBloc, GetCitiesState>(
                      listener: (context, state) {
                        if (state is GetCitiesSuccess) {
                          selectedCity =
                              SharedPreferencesService.instance.getString(
                                "selected_city",
                              ) ??
                              "Andijon";
        
                          showDialog(
                            context: context,
                            builder: (context) {
                              return SelectCityDialog(
                                cities: state.cities,
                                initialSelectedCity: selectedCity,
                              );
                            },
                          );
                        }
                      },
                      builder: (context, state) {
                        return _buildCategories("select_city".tr(), () {
                          BlocProvider.of<GetCitiesBloc>(
                            context,
                          ).add(GetAllCitiesEvent());
                        }, Icons.location_city);
                      },
                    ),
        
                    SizedBox(height: 15.h),
                    _buildCategories("select_language".tr(), () {
                      showLanguageBottomSheet(context);
                    }, Icons.language),
                    SizedBox(height: 15.h),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
        
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 15.h),
        
                    _buildCategories("support".tr(), () {
                      showProfileBottombSheet(context);
                    }, Icons.info),
        
                    SizedBox(height: 15.h),
                    InkWell(
                      onTap: () {
                        CustomAwesomeDialog.showInfoDialog(
                          context,
                          dialogtype: DialogType.info,
                          title: "logout".tr(),
                          desc: "logout_confirm".tr(),
                          onOkPress: () {
                            SharedPreferencesService.instance.clear();
                            HiveBoxes.basketData.clear();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MainScreen(),
                              ),
                            );
                          },
                          onCancelPress: () {},
                        );
                      },
                      child: ListTile(
                        leading: Icon(Icons.exit_to_app, color: Colors.red),
                        title: Text(
                          'logout'.tr(),
                          style: TextStyle(color: Colors.red, fontSize: 20.sp),
                        ),
                        trailing: Icon(
                          Icons.chevron_right,
                          color: Colors.red,
                          size: 24.sp,
                        ),
                      ),
                    ),
                    SizedBox(height: 15.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategories(String title, VoidCallback? onTap, IconData icon) {
    return InkWell(
      onTap: onTap,
      child: ListTile(
        leading: Icon(icon),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
        ),

        trailing: Icon(Icons.chevron_right, size: 24.sp),
      ),
    );
  }

  void showProfileBottombSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,

      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.63,
          minChildSize: 0.2,
          maxChildSize: 0.9,
          builder: (_, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: EdgeInsets.all(16),
              child: ListView(
                controller: scrollController,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "support_service".tr(),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.cancel),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  ListTile(
                    onTap: () {
                      launchPhoneCall("+998907629282");
                    },
                    title: Text(
                      "+998 90 762 92 82",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text("have_questions".tr()),
                    trailing: IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.phone),
                    ),
                  ),
                  SizedBox(height: 12),
                  ListTile(
                    onTap: () {
                      launchPhoneCall("+998901234567");
                    },
                    title: Text(
                      "+998 90 123 45 67",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text("hotline".tr()),
                    trailing: IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.phone),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: () async {
                          await _launchInstagramUrl(
                            "https://www.instagram.com/stroy_baza_n1?igsh=N2Jnd2lsZGhsZGtq",
                          );
                        },
                        icon: ImageIcon(
                          AssetImage("assets/icons/instagram.png"),
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          await _launchInstagramUrl(
                            "https://youtube.com/@stroy_baza_n1?si=G4tMkWyveG_eiAI_",
                          );
                        },
                        icon: ImageIcon(AssetImage("assets/icons/youtube.png")),
                      ),
                      IconButton(
                        onPressed: () async {
                          await _launchInstagramUrl(
                            "https://t.me/QurulishMollariStroyBazaN1",
                          );
                        },
                        icon: Icon(Icons.telegram),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void launchPhoneCall(String phoneNumber) async {
    final Uri telUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(telUri)) {
      await launchUrl(telUri);
    } else {
      throw 'Telefon raqamni ochib bo‘lmadi: $phoneNumber';
    }
  }
}
