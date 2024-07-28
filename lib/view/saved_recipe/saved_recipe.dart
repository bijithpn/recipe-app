import 'package:flutter/material.dart';
import 'package:recipe_app/core/constants/image.dart';
import 'package:recipe_app/core/constants/strings.dart';
import 'package:recipe_app/db/db.dart';
import 'package:recipe_app/db/model/recipe.dart';
import 'package:recipe_app/main.dart';
import 'package:recipe_app/view/saved_recipe/widgets/saved_recipe_card.dart';

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
    var size = MediaQuery.of(context).size;
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
        child: savedRecipe.isEmpty
            ? Center(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
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
              )
            : CustomScrollView(slivers: [
                SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15.0,
                    mainAxisSpacing: 15.0,
                    childAspectRatio: size.width > 400 ? 0.77 : 0.7,
                  ),
                  delegate: SliverChildBuilderDelegate((context, index) {
                    var recipe = savedRecipe[index];
                    return GridTile(
                      child: SavedRecipeCard(
                        recipe: recipe,
                        callBack: () => getSavedList(),
                      ),
                    );
                  }, childCount: savedRecipe.length),
                ),
              ]),
      ),
    );
  }
}
