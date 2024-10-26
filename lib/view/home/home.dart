import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:recipe_app/core/constants/strings.dart';
import 'package:recipe_app/utils/utils.dart';
import '../view.dart';

import '../../view_models/home_provider.dart';
import '../../widgets/widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final userData = Utils.getFomLocalStorage(key: StorageStrings.userData);

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // String? includeTag =
      //     (userData['dietaryPreferences'] ?? []).join(",").toLowerCase() +
      //         "," +
      //         (userData['mealTypes'] ?? []).join(",").toLowerCase() +
      //         "," +
      //         (userData['tastePreferences'] ?? []).join(",").toLowerCase() +
      //         "," +
      //         (userData['cuisineList'] ?? []).join(",").toLowerCase();
      // String? excludeTag =
      //     (userData['dietaryRestrictions'] ?? []).join(", ").toLowerCase();
      // excludeTag =
      //     excludeTag!.replaceAll(",", "").trim().isEmpty ? null : excludeTag;
      // includeTag =
      //     includeTag!.replaceAll(",", "").trim().isEmpty ? null : includeTag;
      final provider = Provider.of<HomeProvider>(context, listen: false);

      provider.getRecipes(
          // includeTags: includeTag,
          // excludeTags: excludeTag,
          );
    });
    super.initState();
  }

  String profileSvg = '';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: true,
      child: Consumer<HomeProvider>(
        builder: (_, homeProvider, __) {
          return Scaffold(
            body: RefreshIndicator(
              onRefresh: () => homeProvider.getRecipes(),
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
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
                                      'Hello, ${userData?['name'] ?? "username"}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .copyWith(
                                              fontWeight: FontWeight.bold),
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
                              ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: RandomAvatar(
                                  userData?['profileImg'] ?? "User",
                                  height: 50,
                                  width: 52,
                                ),
                              )
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
                        child: Center(child: LottieLoader()),
                      )
                    else if (homeProvider.homeState == HomeState.search)
                      RecipeViewBuilder(
                          recipeList: homeProvider.searchRecipeList)
                    else if (homeProvider.homeState == HomeState.home)
                      RecipeViewBuilder(recipeList: homeProvider.recipeList)
                    else if (homeProvider.homeState == HomeState.filter)
                      RecipeViewBuilder(
                          recipeList: homeProvider.filteredRecipeList),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
