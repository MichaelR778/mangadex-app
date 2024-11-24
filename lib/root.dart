import 'package:flutter/material.dart';
import 'package:mangadex_app/features/favorite/favorite_page.dart';
import 'package:mangadex_app/features/home/presentation/pages/home_page.dart';
import 'package:mangadex_app/features/search/presentation/pages/search_page.dart';
import 'package:mangadex_app/theme/app_colors.dart';

class Root extends StatefulWidget {
  const Root({super.key});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  int currIndex = 0;

  final List<Widget> pages = [
    const HomePage(),
    const SearchPage(),
    const FavoritePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: pages[currIndex],
      bottomNavigationBar: NavigationBar(
        elevation: 0,
        height: 50,
        backgroundColor: AppColors.navbar,
        indicatorColor: Colors.transparent,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        selectedIndex: currIndex,
        onDestinationSelected: (int index) {
          setState(() {
            currIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_customize_outlined),
            selectedIcon: Icon(
              Icons.dashboard_customize,
              color: AppColors.primary,
            ),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.search),
            selectedIcon: Icon(
              Icons.search,
              color: AppColors.primary,
            ),
            label: 'Search',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_outline),
            selectedIcon: Icon(
              Icons.favorite,
              color: AppColors.primary,
            ),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }
}
