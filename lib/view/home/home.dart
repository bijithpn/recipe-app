import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/core/constants/colors.dart';
import 'package:recipe_app/core/constants/image.dart';
import 'package:recipe_app/view/saved_recipe/saved_recipe.dart';

import 'package:recipe_app/view_models/home_provider.dart';

import 'widget/widget.dart';

class HomeNavigation extends StatefulWidget {
  const HomeNavigation({super.key});

  @override
  State<HomeNavigation> createState() => _HomeNavigationState();
}

class _HomeNavigationState extends State<HomeNavigation> {
  int _selectedIndex = 0;
  final List<Widget> _screens = [
    const HomeScreen(),
    const SavedRecipe(),
    const Screens(
      title: "Notifications",
    ),
    const Screens(
      title: "Profile",
    ),
    const Screens(
      title: "Settings",
    ),
  ];

  final List<BottomNavigationBarItem> _bottomNavigationBarItems = [
    const BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
    const BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: ''),
    const BottomNavigationBarItem(icon: Icon(Icons.notifications), label: ''),
    const BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
    const BottomNavigationBarItem(icon: Icon(Icons.settings), label: ''),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: _bottomNavigationBarItems,
        backgroundColor: ColorPalette.primary,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: ColorPalette.white,
        unselectedItemColor: Colors.black,
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<HomeProvider>(context, listen: false);
      provider.getRecipes();
    });
    super.initState();
  }

  double calculateAspectRatio(double width, double height,
      {double min = 0.7, double max = .71}) {
    double result = (width / 2) / (width / 2 * 1.5);
    // double minValue = min;
    // double maxValue = max;

    // if (result < minValue) {
    //   result = minValue;
    // } else if (result > maxValue) {
    //   result = maxValue;
    // }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    // var size = MediaQuery.of(context).size;
    return SafeArea(
      top: true,
      child: Consumer<HomeProvider>(
        builder: (_, homeProvider, __) {
          return Scaffold(
            body: RefreshIndicator(
              onRefresh: () => homeProvider.getRecipes(),
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: 110.0,
                    pinned: false,
                    floating: true,
                    flexibleSpace: FlexibleSpaceBar(
                      expandedTitleScale: 2,
                      background: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Hello, Anne',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'What would you like to cook today?',
                                    maxLines: 2,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(
                                            letterSpacing: .8,
                                            fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            const CircleAvatar(
                              radius: 25,
                              backgroundImage: CachedNetworkImageProvider(
                                  'https://www.devicemag.com/wp-content/uploads/2022/12/Apple-Bitmoji-4.jpg'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SearchWidget(),
                          const SizedBox(height: 16),
                          Text(
                            homeProvider.isSearch
                                ? "Search Results"
                                : 'Recommendations',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 6),
                        ],
                      ),
                    ),
                  ),
                  homeProvider.isLoading
                      ? const SliverFillRemaining(
                          child: Center(child: CircularProgressIndicator()),
                        )
                      : homeProvider.isSearch
                          ? SliverPadding(
                              padding: const EdgeInsets.all(10),
                              sliver: homeProvider.filteredRecipeList.isEmpty
                                  ? SliverToBoxAdapter(
                                      child: Column(
                                        children: [
                                          Image.asset(
                                            AssetsImages.empty,
                                            height: 250,
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            'No recipes available right now. We\'re working on adding more recipes soon!',
                                            textAlign: TextAlign.center,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge!
                                                .copyWith(
                                                    letterSpacing: .6,
                                                    fontWeight:
                                                        FontWeight.bold),
                                          )
                                        ],
                                      ),
                                    )
                                  : SliverList.builder(
                                      itemCount: homeProvider
                                          .filteredRecipeList.length,
                                      itemBuilder: (_, i) {
                                        var recipe =
                                            homeProvider.filteredRecipeList[i];
                                        return RecipeCard(recipe: recipe);
                                      }))
                          : SliverPadding(
                              padding: const EdgeInsets.all(10),
                              sliver: homeProvider.recipeList.isEmpty
                                  ? SliverToBoxAdapter(
                                      child: Column(
                                        children: [
                                          Image.asset(
                                            AssetsImages.empty,
                                            height: 250,
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            'No recipes available right now. We\'re working on adding more recipes soon!',
                                            textAlign: TextAlign.center,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge!
                                                .copyWith(
                                                    letterSpacing: .6,
                                                    fontWeight:
                                                        FontWeight.bold),
                                          )
                                        ],
                                      ),
                                    )
                                  : SliverList.builder(
                                      itemCount: homeProvider.recipeList.length,
                                      itemBuilder: (_, i) {
                                        var recipe = homeProvider.recipeList[i];
                                        return GridTile(
                                          child: RecipeCard(recipe: recipe),
                                        );
                                      },
                                    )),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class Screens extends StatelessWidget {
  final String title;
  const Screens({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }
}
