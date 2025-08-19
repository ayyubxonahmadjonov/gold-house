import 'package:gold_house/presentation/screens/profile/presentation/pages/update_fullname.dart';
import 'package:url_launcher/url_launcher.dart';
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

  @override
  Widget build(BuildContext context) {
    final prefs = SharedPreferencesService.instance;

    ValueNotifier<String> fullname = ValueNotifier<String>(
      "${prefs.getString("profilfullname")}",
    );

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Profile'),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey),
              ),
              child: ValueListenableBuilder(
                valueListenable: fullname,
                builder: (context, value, child) {
                  return ListTile(
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
                    title: Text(fullname.value),
                    subtitle: Text("+998 88 739 11"),
                  );
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

                  _buildCategories("Buyurtmalar", () {}, Icons.store),
                  SizedBox(height: 10.h),

                  _buildCategories(
                    "Keshbek",
                    () {},
                    Icons.account_balance_wallet,
                  ),

                  SizedBox(height: 10.h),

                  _buildCategories("Sevimlilar", () {}, Icons.favorite),

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

                  _buildCategories(
                    "Shahar tanlash",
                    () {},
                    Icons.location_city,
                  ),

                  SizedBox(height: 15.h),
                  _buildCategories("Til tanlash", () {}, Icons.language),
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

                  _buildCategories("Qo'llab-quvvatlash", () {
                    showProfileBottombSheet(context);
                  }, Icons.info),

                  SizedBox(height: 15.h),
                  InkWell(
                    onTap: () {},
                    child: ListTile(
                      leading: Icon(Icons.exit_to_app, color: Colors.red),
                      title: Text(
                        'Chiqish',
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
                        "Qo'llab quvvatlash xizmati",
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
                    subtitle: Text("Savolingiz bormi? Qo'ng'iroq qiling"),
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
                    subtitle: Text("Ishonch telefoni"),
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
                            "https://www.instagram.com",
                          );
                        },
                        icon: ImageIcon(
                          AssetImage("assets/icons/instagram.png"),
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          await _launchInstagramUrl("https://www.youtube.com");
                        },
                        icon: ImageIcon(AssetImage("assets/icons/youtube.png")),
                      ),
                      IconButton(
                        onPressed: () async {
                          await _launchInstagramUrl("https://www.youtube.com");
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
