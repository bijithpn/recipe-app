import 'package:flutter/material.dart';
import 'package:recipe_app/data/models/recipe.dart';

import '../data/repositories/recipe_repositrory.dart';

class HomeProvider extends ChangeNotifier {
  List<Recipe> recipeList = [];
  bool isLoading = false;
  final recipeRepository = RecipeRepository();

  Future<void> getRecipes() async {
    isLoading = true;
    notifyListeners();
    try {
      final temp = await recipeRepository.getRecipes();
      temp.map((e) => recipeList.add(Recipe.fromJson(e))).toList();
      notifyListeners();
    } catch (error) {
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
