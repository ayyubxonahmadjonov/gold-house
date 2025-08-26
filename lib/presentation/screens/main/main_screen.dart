import 'package:gold_house/bloc/branches/branches_bloc.dart';

import '../../../core/constants/app_imports.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    const SearchScreen(),
    OrderHistoryScreen(),
    const BasketPage(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.05),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: AppColors.whiteOpacity1,
        unselectedItemColor: AppColors.whiteOpacity2,

        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            backgroundColor: AppColors.navbarColor,
            icon: ImageIcon(AssetImage('assets/icons/home_icon.png')),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            backgroundColor: AppColors.navbarColor,

            icon: ImageIcon(AssetImage('assets/icons/search.png')),

            label: 'Search',
          ),
          BottomNavigationBarItem(
            backgroundColor: AppColors.navbarColor,

            icon: ImageIcon(AssetImage('assets/icons/box.png')),

            label: 'Box',
          ),
          BottomNavigationBarItem(
            backgroundColor: AppColors.navbarColor,

            icon: ImageIcon(AssetImage('assets/icons/basket.png')),

            label: 'Basket',
          ),
          BottomNavigationBarItem(
            backgroundColor: AppColors.navbarColor,

            icon: ImageIcon(AssetImage('assets/icons/profile.png')),

            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
