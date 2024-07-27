import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/core/constants/image.dart';

import 'package:recipe_app/view_models/home_provider.dart';

import 'widget/widget.dart';

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
                                  : SliverGrid(
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              crossAxisSpacing: 15.0,
                                              mainAxisSpacing: 15.0,
                                              childAspectRatio: min(
                                                  (size.width /
                                                      (size.height / 1.68)),
                                                  0.6)),
                                      delegate: SliverChildBuilderDelegate(
                                        (context, index) {
                                          var recipe = homeProvider
                                              .filteredRecipeList[index];
                                          return GridTile(
                                            child: RecipeCard(recipe: recipe),
                                          );
                                        },
                                        childCount: homeProvider
                                            .filteredRecipeList.length,
                                      ),
                                    ),
                            )
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
                                  : SliverGrid(
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              crossAxisSpacing: 15.0,
                                              mainAxisSpacing: 15.0,
                                              childAspectRatio: min(
                                                (size.width /
                                                    (size.height / 1.68)),
                                                0.7,
                                              )),
                                      delegate: SliverChildBuilderDelegate(
                                        (context, index) {
                                          var recipe =
                                              homeProvider.recipeList[index];
                                          return GridTile(
                                            child: RecipeCard(recipe: recipe),
                                          );
                                        },
                                        childCount:
                                            homeProvider.recipeList.length,
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
