import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../view/home/widget/recipe_card.dart';

import '../core/core.dart';

class RecipeViewBuilder extends StatefulWidget {
  final List<dynamic> recipeList;
  const RecipeViewBuilder({super.key, required this.recipeList});

  @override
  State<RecipeViewBuilder> createState() => _RecipeViewBuilderState();
}

class _RecipeViewBuilderState extends State<RecipeViewBuilder> {
  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(10),
      sliver: widget.recipeList.isEmpty
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
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        letterSpacing: .6, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            )
          : SliverMasonryGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  var recipe = widget.recipeList[index];
                  return GridTile(
                    child: RecipeCard(recipe: recipe),
                  );
                },
                childCount: widget.recipeList.length,
              ),
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              gridDelegate:
                  const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
            ),
    );
  }
}
