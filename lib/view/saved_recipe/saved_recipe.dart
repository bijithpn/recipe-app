import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../main.dart';
import '../../core/core.dart';
import '../../db/db.dart';
import 'widgets/saved_recipe_card.dart';

class SavedRecipe extends StatefulWidget {
  const SavedRecipe({super.key});

  @override
  State<SavedRecipe> createState() => _SavedRecipeState();
}

class _SavedRecipeState extends State<SavedRecipe> {
  List<RecipeDB> savedRecipe = [];
  final recipeDb = getIt<RecipeDatabase>();
  @override
  void initState() {
    getSavedList();
    super.initState();
  }

  getSavedList() async {
    savedRecipe = await recipeDb.getAllRecipes();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Saved",
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontWeight: FontWeight.bold)),
      ),
      body: RefreshIndicator(
        onRefresh: () => getSavedList(),
        child: CustomScrollView(slivers: [
          savedRecipe.isEmpty
              ? SliverFillRemaining(
                  child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          AssetsImages.emptySave,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          AppStrings.saveEmpty,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge,
                        )
                      ],
                    ),
                  ),
                ))
              : SliverPadding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  sliver: SliverMasonryGrid(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        var recipe = savedRecipe[index];
                        return GridTile(
                          child: SavedRecipeCard(
                            recipe: recipe,
                            callBack: () => getSavedList(),
                          ),
                        );
                      },
                      childCount: savedRecipe.length,
                    ),
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    gridDelegate:
                        const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2),
                  ),
                ),
        ]),
      ),
    );
  }
}
