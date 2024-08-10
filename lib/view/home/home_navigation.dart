import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '../view.dart';

import '../../core/core.dart';

class HomeNavigation extends StatefulWidget {
  const HomeNavigation({super.key});

  @override
  State<HomeNavigation> createState() => _HomeNavigationState();
}

class _HomeNavigationState extends State<HomeNavigation> {
  ValueNotifier<bool> isDark = ValueNotifier(false);
  @override
  void initState() {
    getTheme();
    super.initState();
  }

  getTheme() {
    Hive.box(StorageStrings.settingDB)
        .watch(key: "isDarkTheme")
        .listen((event) {
      isDark.value = event.value;
      print("dark value :${isDark.value}");
    });
  }

  int _selectedIndex = 0;
  final List<Widget> _screens = const [
    HomeScreen(),
    SavedRecipe(),
    SearchRecipe(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: ValueListenableBuilder(
          valueListenable: isDark,
          builder: (context, darkTheme, _) {
            return Container(
              decoration: BoxDecoration(
                color: darkTheme ? Colors.black : Colors.white,
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
                      rippleColor: darkTheme ? Colors.black : Colors.grey[300]!,
                      hoverColor: darkTheme ? Colors.black : Colors.grey[100]!,
                      tabBackgroundColor: darkTheme
                          ? ColorPalette.blackLight
                          : Colors.grey[100]!,
                      color: ColorPalette.primary,
                      gap: 8,
                      activeColor: ColorPalette.primary,
                      iconSize: 24,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 12),
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
                          icon: Icons.search,
                          text: 'search',
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
