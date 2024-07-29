import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../../core/core.dart';
import '../../view_models/home_provider.dart';

import '../saved_recipe/saved_recipe.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              rippleColor: Colors.grey[300]!,
              hoverColor: Colors.grey[100]!,
              gap: 8,
              activeColor: ColorPalette.primary,
              iconSize: 24,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: const Duration(milliseconds: 400),
              tabBackgroundColor: Colors.grey[100]!,
              color: Colors.black,
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
                  icon: Icons.notifications,
                  text: 'Notifications',
                ),
                GButton(
                  icon: Icons.person,
                  text: 'Profile',
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
    double result = (width / 2) / (width / 2);
    double minValue = min;
    double maxValue = max;
    if (result < minValue) {
      result = minValue;
    } else if (result > maxValue) {
      result = maxValue;
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
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
                          SearchWidget(
                            diets: homeProvider.dietTypes,
                            dishTypes: homeProvider.dishTypes,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            homeProvider.homeState == HomeState.search
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
                  if (homeProvider.homeState == HomeState.isLoading)
                    const SliverFillRemaining(
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (homeProvider.homeState == HomeState.search)
                    SliverPadding(
                      padding: const EdgeInsets.all(10),
                      sliver: homeProvider.searchRecipeList.isEmpty
                          ? SliverToBoxAdapter(
                              child: Column(
                                children: [
                                  Image.asset(
                                    AssetsImages.emptyState,
                                    height: 250,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    AppStrings.noRecipe,
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                            letterSpacing: .6,
                                            fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            )
                          : SliverGrid(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 15.0,
                                mainAxisSpacing: 15.0,
                                childAspectRatio: size.width > 400 ? 0.66 : 0.6,
                              ),
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  var recipe =
                                      homeProvider.searchRecipeList[index];
                                  return GridTile(
                                    child: RecipeCard(recipe: recipe),
                                  );
                                },
                                childCount:
                                    homeProvider.searchRecipeList.length,
                              ),
                            ),
                    )
                  else if (homeProvider.homeState == HomeState.home)
                    SliverPadding(
                      padding: const EdgeInsets.all(10),
                      sliver: homeProvider.recipeList.isEmpty
                          ? SliverToBoxAdapter(
                              child: Column(
                                children: [
                                  Image.asset(
                                    AssetsImages.emptyState,
                                    height: 250,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    AppStrings.noRecipe,
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                            letterSpacing: .6,
                                            fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            )
                          : SliverGrid(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 15.0,
                                mainAxisSpacing: 15.0,
                                childAspectRatio: size.width > 400 ? 0.77 : 0.7,
                              ),
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  var recipe = homeProvider.recipeList[index];
                                  return GridTile(
                                    child: RecipeCard(recipe: recipe),
                                  );
                                },
                                childCount: homeProvider.recipeList.length,
                              ),
                            ),
                    )
                  else if (homeProvider.homeState == HomeState.filter)
                    SliverPadding(
                      padding: const EdgeInsets.all(10),
                      sliver: homeProvider.filteredRecipeList.isEmpty
                          ? SliverToBoxAdapter(
                              child: Column(
                                children: [
                                  Image.asset(
                                    AssetsImages.emptyState,
                                    height: 250,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    AppStrings.noRecipe,
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                            letterSpacing: .6,
                                            fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            )
                          : SliverGrid(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 15.0,
                                mainAxisSpacing: 15.0,
                                childAspectRatio: size.width > 400 ? 0.77 : 0.7,
                              ),
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  var recipe =
                                      homeProvider.filteredRecipeList[index];
                                  return GridTile(
                                    child: RecipeCard(recipe: recipe),
                                  );
                                },
                                childCount:
                                    homeProvider.filteredRecipeList.length,
                              ),
                            ),
                    ),
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
      appBar: AppBar(
        title: Text(
          title,
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Text(
          title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }
}
