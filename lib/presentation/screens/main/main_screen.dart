import 'package:easy_localization/easy_localization.dart';
import 'package:gold_house/core/basket_notifier.dart';

import '../../../core/constants/app_imports.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];
  void _onTap(int index) {
    if (index == _currentIndex) {
      _navigatorKeys[index].currentState?.popUntil((route) => route.isFirst);
    } else {
      setState(() => _currentIndex = index);
    }
  }

  final List<Widget> _pages = [
    const HomeScreen(),
    const SearchScreen(),
    OrderHistoryScreen(),
    const BasketPage(),
    ProfileScreen(),
  ];
  String selected_business = "";
  String productCount = "";
  @override
  void initState() {
    super.initState();
    selected_business =
        SharedPreferencesService.instance.getString("selected_business") ?? "";
  }

  @override
  Widget build(BuildContext context) {
    productCount =
        SharedPreferencesService.instance.getString("basketProductCount") ?? "";

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.05),
      body: Stack(
        children: [
          _buildOffstageNavigator(0, const HomeScreen()),
          _buildOffstageNavigator(1, const SearchScreen()),
          _buildOffstageNavigator(2, OrderHistoryScreen()),
          _buildOffstageNavigator(3, const BasketPage()),
          _buildOffstageNavigator(4, ProfileScreen()),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: AppColors.whiteOpacity1,
        unselectedItemColor: AppColors.whiteOpacity2,

        onTap: _onTap,
        items: [
          BottomNavigationBarItem(
            backgroundColor: AppColors.navbarColor,
            icon: ImageIcon(AssetImage('assets/icons/home_icon.png')),
            label: 'home'.tr(),
          ),
          BottomNavigationBarItem(
            backgroundColor: AppColors.navbarColor,

            icon: ImageIcon(AssetImage('assets/icons/search.png')),

            label: 'search'.tr(),
          ),

          BottomNavigationBarItem(
            backgroundColor: AppColors.navbarColor,

            icon: ImageIcon(AssetImage('assets/icons/box.png')),

            label: 'box'.tr(),
          ),
          BottomNavigationBarItem(
            backgroundColor: AppColors.navbarColor,
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const ImageIcon(AssetImage('assets/icons/basket.png')),

                // 🔥 notifier orqali real-time kuzatish
                ValueListenableBuilder<int>(
                  valueListenable: BasketNotifier.productCount,
                  builder: (context, value, _) {
                    if (value == 0)
                      return const SizedBox.shrink(); // Agar bo'sh bo'lsa — hech narsa ko‘rsatma

                    return Positioned(
                      right: -6,
                      top: -4,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Center(
                          child: Text(
                            "$value",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            label: 'basket'.tr(),
          ),

          BottomNavigationBarItem(
            backgroundColor: AppColors.navbarColor,

            icon: ImageIcon(AssetImage('assets/icons/profile.png')),

            label: "",
          ),
        ],
      ),
    );
  }

  Widget _buildOffstageNavigator(int index, Widget child) {
    return Offstage(
      offstage: _currentIndex != index,
      child: Navigator(
        key: _navigatorKeys[index],
        onGenerateRoute: (routeSettings) {
          return MaterialPageRoute(builder: (_) => child);
        },
      ),
    );
  }
}
