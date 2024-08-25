import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:random_avatar/random_avatar.dart';
import '../view.dart';

import '../../view_models/home_provider.dart';
import '../../widgets/widgets.dart';

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
    getProfile();
    super.initState();
  }

  String profileSvg = '';
  getProfile() {
    profileSvg = RandomAvatarString(
      DateTime.now().toIso8601String(),
      trBackground: false,
    );
    setState(() {});
  }

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
                                      'Hello, Bijith',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
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
                                  "bijith",
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
