import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/utils/utils.dart';

import '../../core/core.dart';
import '../view.dart';

class HomeNavigation extends StatefulWidget {
  const HomeNavigation({super.key});

  @override
  State<HomeNavigation> createState() => _HomeNavigationState();
}

class _HomeNavigationState extends State<HomeNavigation> {
  final Map<String, dynamic>? userData =
      Utils.getFomLocalStorage(key: StorageStrings.userData);
  int _selectedIndex = 0;
  final List<Widget> _screens = const [
    HomeScreen(),
    SavedRecipe(),
    MealsPlanner(),
    SearchRecipe(),
    SettingsPage(),
  ];

  void checkMissingKeys(Map<String, dynamic> userData) {
    final status =
        Utils.getFomLocalStorage(key: StorageStrings.userPreferenceStatus);

    if (status != null) return;

    List<String> keysToCheck = [
      'dietaryPreferences',
      'mealTypes',
      'tastePreferences',
      'cuisineList',
      'dietaryRestrictions'
    ];

    for (String key in keysToCheck) {
      if (userData.containsKey(key) || userData[key].isEmpty) {
        context.go(Routes.userPreference);
        return;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (userData != null) {
        checkMissingKeys(userData!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar:
          Consumer<ThemeManager>(builder: (context, themeData, __) {
        return Container(
          decoration: BoxDecoration(
            color: themeData.isDarkTheme ? Colors.black : Colors.white,
            boxShadow: [
              BoxShadow(
                blurRadius: 20,
                color: Colors.black.withOpacity(.1),
              )
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
              child: Theme(
                data: ThemeData(canvasColor: Colors.black),
                child: GNav(
                  rippleColor:
                      themeData.isDarkTheme ? Colors.black : Colors.grey[300]!,
                  hoverColor:
                      themeData.isDarkTheme ? Colors.black : Colors.grey[100]!,
                  tabBackgroundColor: themeData.isDarkTheme
                      ? ColorPalette.blackLight
                      : Colors.grey[100]!,
                  color: ColorPalette.primary,
                  gap: 8,
                  activeColor: ColorPalette.primary,
                  iconSize: 24,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                  duration: const Duration(milliseconds: 400),
                  tabs: const [
                    GButton(
                      icon: Icons.home,
                      text: 'Home',
                    ),
                    GButton(
                      icon: Icons.bookmark,
                      text: 'Saved',
                    ),
                    GButton(
                      icon: Icons.restaurant,
                      text: 'Diet',
                    ),
                    GButton(
                      icon: Icons.search,
                      text: 'Search',
                    ),
                    GButton(
                      icon: Icons.settings,
                      text: 'Setting',
                    ),
                  ],
                  selectedIndex: _selectedIndex,
                  onTabChange: (index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
