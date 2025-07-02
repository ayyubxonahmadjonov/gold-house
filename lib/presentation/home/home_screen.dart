import 'package:gold_house/presentation/home/description_screen.dart';

import '../../core/constants/app_imports.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: AppColors.primaryColor,
            child: Column(
              children: [
                SizedBox(height: 60.h),
                SvgPicture.asset("assets/images/app_logo.png"),
                CustomSearchbar(
                  hintText: "Qidirish",
                  prefixicon: Icon(Icons.search),
                ),
                SizedBox(height: 10.h),
              ],
            ),
          ),
          SelectableRow(),

          /// Scroll bo‘lishi kerak bo‘lgan qism
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Carousel
                  CustomCarousel(
                    images: [
                      "https://windows10spotlight.com/wp-content/uploads/2023/01/81a6e74c8adbf7f55406e8c4b80669d5.jpg",
                      "https://i.pinimg.com/originals/dc/55/a7/dc55a7baa9cbd457221ae6d12d9b1b51.jpg",
                      "https://cdn.wallpapersafari.com/30/62/jHBzTk.jpg",
                    ],
                  ),

                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "Tavsiya etilgan mahsulotlar",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  /// GridView.builder scroll emas, faqat ichidan joy oladi
                  GridView.builder(
                    itemCount: 8,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,

                      childAspectRatio: 0.7,
                    ),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => ProductDescriptionPage(
                                    title: "Penopleks",
                                    color: "Ko'k",
                                    size: "4x6",
                                    description:
                                        "Lorem Ipsum matbaa va matn terish sanoatining oddiygina soxta matnidir. Lorem Ipsum 1500-yillardan beri sanoatning standart qo'g'irchoq matni bo'lib kelgan, o'shandan beri noma'lum printer galleyni olib, kitob namunasini yaratish uchun shifrlagan. U nafaqat besh asr davomida, balki elektron terishga sakrashdan ham omon qoldi va deyarli o'zgarishsiz qoldi. U 1960-yillarda Lorem Ipsum parchalarini oʻz ichiga olgan Letraset varaqlarining chiqarilishi va yaqinda ",
                                    price: "1,116,500",
                                    monthlyPrice: "135,650",
                                    months: "24 oy",
                                  ),
                            ),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 10.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 160.h,
                                width: 160.w,
                                decoration: BoxDecoration(
                                  color: AppColors.whitegrey,
                                  borderRadius: BorderRadius.circular(10.r),
                                  border: Border.all(
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                ),
                                child: Image.asset(
                                  "assets/images/penopleks.png",
                                  width: 120.w,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                "PENOPLEKS",
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 10.h),
                              Row(
                                children: [
                                  Text(
                                    "Narxi:9.999 UZS",
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(width: 10.w),
                                  ImageIcon(
                                    AssetImage("assets/icons/basket.png"),
                                    size: 16.w,
                                    color: AppColors.yellow,
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      isFavorite
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      size: 16.w,
                                    ),
                                    onPressed: () {},
                                    color:
                                        isFavorite
                                            ? Colors.red
                                            : AppColors.yellow,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 30.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
