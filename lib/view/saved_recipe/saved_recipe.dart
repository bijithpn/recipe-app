import 'package:flutter/material.dart';
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
        child: ListView.separated(
            separatorBuilder: (_, __) => const SizedBox(height: 15),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            itemCount: savedRecipe.length,
            itemBuilder: (_, i) {
              var recipe = savedRecipe[i];
              return SavedRecipeCard(
                recipe: recipe,
                callBack: () => getSavedList(),
              );
            }),
      ),
    );
  }
}
