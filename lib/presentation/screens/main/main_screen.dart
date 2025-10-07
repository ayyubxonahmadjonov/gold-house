import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gold_house/bloc/business_selection/business_selection_bloc.dart';
import 'package:gold_house/core/basket_notifier.dart';
import 'package:gold_house/core/constants/app_imports.dart';

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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BusinessSelectionBloc, BusinessSelectionState>(
      builder: (context, state) {
        String selectedBusiness = "Stroy Baza №1";
        if (state is BusinessSelectedState) {
          selectedBusiness = state.selectedBusiness;
        }

        return Scaffold(
          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.05),
          body: IndexedStack(
            index: _currentIndex,
            children: [
              _buildNavigator(0, HomeScreen()),
              _buildNavigator(1, SearchScreen()),
              _buildNavigator(2, OrderHistoryScreen()),
              _buildNavigator(3, BasketPage()),
              _buildNavigator(4, ProfileScreen()),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            selectedItemColor: AppColors.whiteOpacity1,
            unselectedItemColor: AppColors.whiteOpacity2,
            onTap: (index) {
              if (index == _currentIndex) {
                _navigatorKeys[index].currentState?.popUntil((route) => route.isFirst);
              } else {
                setState(() => _currentIndex = index);
              }
            },
            items: [
              BottomNavigationBarItem(
                backgroundColor: AppColors.navbarColor,
                icon: ImageIcon(AssetImage('assets/icons/home_icon.png')),
                label: 'home'.tr(),
              ),
              BottomNavigationBarItem(
                backgroundColor: AppColors.navbarColor,
                icon: ImageIcon(AssetImage('assets/icons/search.png')),
                label: 'catalog'.tr(),
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
                    ValueListenableBuilder<int>(
                      valueListenable: BasketNotifier.basketProductCount,
                      builder: (context, value, _) {
                        if (value == 0) return const SizedBox.shrink();
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
                label: 'profile'.tr(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNavigator(int index, Widget screen) {
    return Navigator(
      key: _navigatorKeys[index],
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => screen,
          settings: settings,
        );
      },
    );
  }
}