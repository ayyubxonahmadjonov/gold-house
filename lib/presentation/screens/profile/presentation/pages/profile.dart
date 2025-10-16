import 'package:easy_localization/easy_localization.dart';
import 'package:gold_house/bloc/business_selection/business_selection_bloc.dart';
import 'package:gold_house/bloc/get_phone_number_bloc.dart';
import 'package:gold_house/core/constants/app_imports.dart';
import 'package:gold_house/core/utils/langugage_notifier.dart';
import 'package:gold_house/presentation/screens/favorite/favorite_screen.dart';
import 'package:gold_house/presentation/screens/profile/cashback_screen.dart';
import 'package:gold_house/presentation/screens/profile/presentation/pages/update_fullname.dart';
import 'package:gold_house/presentation/widgets/select_city_dialog.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future<void> _launchInstagramUrl(String path) async {
    final Uri url = Uri.parse(path.trim());
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("URL ni ochib bo‘lmadi")));
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> launchPhoneCall(String phoneNumber, BuildContext context) async {
    final Uri telUri = Uri(scheme: 'tel', path: phoneNumber.trim());
    try {
      await launchUrl(telUri, mode: LaunchMode.externalApplication);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Telefon raqamni ochib bo‘lmadi: $phoneNumber')),
      );
    }
  }

  ValueNotifier<String> fullname = ValueNotifier<String>(
    "${SharedPreferencesService.instance.getString("profilfullname")}",
  );
  int user_id = 0;
  String selectedCity = "";

  @override
  void initState() {
    super.initState();
    user_id = SharedPreferencesService.instance.getInt("user_id") ?? 0;
    BlocProvider.of<GetUserDataBloc>(
      context,
    ).add(GetUserAllDataEvent(id: user_id.toString()));
  }

  @override
  void dispose() {
    fullname.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: LanguageNotifier.selectedLanguage,
      builder: (context, language, child) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text('profile'.tr()),
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
                        if (state is GetUserDataSuccess) {
                          return ListTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const UpdateFullname(),
                                ),
                              );
                            },
                            leading: const Icon(Icons.person),
                            title:
                                state.user.firstName.isNotEmpty
                                    ? Text(
                                      "${state.user.firstName} ${state.user.lastName}",
                                    )
                                    : const Text(""),
                            subtitle:
                                state.user.phoneNumber.isNotEmpty
                                    ? Text("${state.user.phoneNumber}")
                                    : const Text(""),
                          );
                        } else {
                          return CustomButton(
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignUpScreen(),
                                ),
                                (route) => false,
                              );
                            },
                            title: "register".tr(),
                            bacColor: AppColors.yellow,
                            textColor: AppColors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            borderRadius: 10,
                            width: double.infinity,
                            height: 50.h,
                          );
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
                              builder: (context) => const OrderHistoryScreen(),
                            ),
                          );
                        }, Icons.store),
                        SizedBox(height: 10.h),
                        _buildCategories("cashback".tr(), () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CashbackView(),
                            ),
                          );
                        }, Icons.account_balance_wallet),
                        SizedBox(height: 10.h),
                        _buildCategories("favorites".tr(), () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const FavoritesScreen(),
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
                          showModalBottomSheet(
                            context: context,
                            backgroundColor:
                                Theme.of(context).colorScheme.surface,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(24),
                              ),
                            ),
                            builder: (context) {
                              final currentLocale = context.locale.languageCode;
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 20,
                                  horizontal: 16,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 40,
                                      height: 4,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade400,
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      "select_language".tr(),
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    _buildLanguageTile(
                                      context,
                                      langCode: "en",
                                      title: "English",
                                      flag: "🇬🇧",
                                      currentLocale: currentLocale,
                                    ),
                                    _buildLanguageTile(
                                      context,
                                      langCode: "uz",
                                      title: "Oʻzbekcha",
                                      flag: "🇺🇿",
                                      currentLocale: currentLocale,
                                    ),
                                    _buildLanguageTile(
                                      context,
                                      langCode: "ru",
                                      title: "Русский",
                                      flag: "🇷🇺",
                                      currentLocale: currentLocale,
                                    ),
                                    const SizedBox(height: 8),
                                  ],
                                ),
                              );
                            },
                          );
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
                          context.read<GetPhoneNumberBloc>().add(
                            GetPAllhoneNumbersEvent(),
                          );
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
                                Navigator.of(
                                  context,
                                  rootNavigator: true,
                                ).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (context) => const MainScreen(),
                                  ),
                                  (route) => false,
                                );
                              },
                              onCancelPress: () {},
                            );
                          },
                          child: ListTile(
                            leading: const Icon(
                              Icons.exit_to_app,
                              color: Colors.red,
                            ),
                            title: Text(
                              'logout'.tr(),
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 20.sp,
                              ),
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
      },
    );
  }

  /////////////////
  Widget _buildCategories(String title, VoidCallback? onTap, IconData icon) {
    return InkWell(
      onTap: onTap,
      child: ListTile(
        leading: Icon(icon),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
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
          initialChildSize: 0.7,
          minChildSize: 0.2,
          maxChildSize: 0.9,
          builder: (_, scrollController) {
            return BlocBuilder<GetPhoneNumberBloc, GetPhoneNumberState>(
              builder: (context, phoneState) {
                return BlocBuilder<
                  BusinessSelectionBloc,
                  BusinessSelectionState
                >(
                  builder: (context, businessState) {
                    int selectedIndex = 0;

                    if (businessState is BusinessSelectedState) {
                      selectedIndex = businessState.selectedIndex;
                    } else if (businessState is BusinessSelectionInitial) {
                      selectedIndex = 0;
                    }

                    if (phoneState is GetPhoneNumberError) {
                      return Center(child: Text(phoneState.error));
                    }
                    if (phoneState is GetPhoneNumberSuccess) {
                      final filteredList =
                          phoneState.response
                              .where((e) => e.branch == selectedIndex)
                              .toList();

                      return Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(24),
                          ),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: ListView(
                          controller: scrollController,
                          children: [
                            Center(
                              child: Container(
                                width: 40,
                                height: 4,
                                margin: const EdgeInsets.only(bottom: 16),
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
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(Icons.cancel),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            ...filteredList.map(
                              (item) => Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: ListTile(
                                  onTap:
                                      () => launchPhoneCall(
                                        item.phoneNumber,
                                        context,
                                      ),
                                  title: Text(
                                    item.phoneNumber,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  subtitle: Text(
                                    LanguageNotifier.selectedLanguage.value ==
                                            "uz"
                                        ? item.titleUz
                                        : LanguageNotifier
                                                .selectedLanguage
                                                .value ==
                                            "ru"
                                        ? item.titleRu
                                        : item.titleEn,
                                  ),
                                  trailing: IconButton(
                                    onPressed:
                                        () => launchPhoneCall(
                                          item.phoneNumber,
                                          context,
                                        ),
                                    icon: const Icon(Icons.phone),
                                  ),
                                ),
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
                                  icon: Image.asset(
                                    "assets/icons/instagram.png",
                                    width: 30,
                                    height: 30,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Icon(
                                              Icons.error,
                                              color: Colors.red,
                                              size: 30,
                                            ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () async {
                                    await _launchInstagramUrl(
                                      "https://youtube.com/@stroy_baza_n1?si=G4tMkWyveG_eiAI_",
                                    );
                                  },
                                  icon: Image.asset(
                                    "assets/icons/youtube.png",
                                    width: 30,
                                    height: 30,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Icon(
                                              Icons.error,
                                              color: Colors.red,
                                              size: 30,
                                            ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () async {
                                    await _launchInstagramUrl(
                                      "https://t.me/QurulishMollariStroyBazaN1",
                                    );
                                  },
                                  icon: Image.asset(
                                    "assets/icons/telegram.png",
                                    width: 30,
                                    height: 30,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Icon(
                                              Icons.error,
                                              color: Colors.red,
                                              size: 30,
                                            ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildLanguageTile(
    BuildContext context, {
    required String langCode,
    required String title,
    required String flag,
    required String currentLocale,
  }) {
    final isSelected = currentLocale == langCode;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: isSelected ? 4 : 1,
      child: ListTile(
        leading: Text(flag, style: const TextStyle(fontSize: 24)),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color:
                isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
        trailing:
            isSelected
                ? Icon(
                  Icons.check_circle,
                  color: Theme.of(context).colorScheme.primary,
                )
                : null,
        onTap: () {
          LanguageNotifier.updateLanguage(langCode);
          context.setLocale(Locale(langCode));
          Navigator.pop(context);
        },
      ),
    );
  }
}
