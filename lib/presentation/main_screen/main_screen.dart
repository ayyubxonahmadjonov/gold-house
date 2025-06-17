import 'package:flutter/material.dart';
import 'package:gold_house/core/constants/app_colors.dart';
import 'package:gold_house/presentation/home/home_screen.dart';
import 'package:gold_house/presentation/main_screen/bottom_bar_pages/basket.dart';
import 'package:gold_house/presentation/main_screen/bottom_bar_pages/categories.dart';
import 'package:gold_house/presentation/main_screen/bottom_bar_pages/penoplex.dart';
import 'package:gold_house/presentation/main_screen/bottom_bar_pages/profile.dart';

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
    const PenoPlexScreen(),
    const BasketScreen(),
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
            icon: ImageIcon(AssetImage('assets/icons/search.png')),

            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/icons/box.png')),

            label: 'Box',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/icons/basket.png')),

            label: 'Basket',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/icons/profile.png')),

            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
