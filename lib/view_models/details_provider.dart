import 'package:flutter/foundation.dart';
import 'package:recipe_app/data/models/details.dart';
import 'package:recipe_app/data/repositories/recipe_repositrory.dart';
import 'package:recipe_app/db/db.dart';
import 'package:recipe_app/main.dart';

class DetailsProvider extends ChangeNotifier {
  RecipeDetail? recipeDetail;
  bool isLoading = true;
  final recipeRepository = RecipeRepository();
  final recipeDb = getIt<RecipeDatabase>();

  Future<void> getDetails(String id) async {
    isLoading = true;
    notifyListeners();
    try {
      recipeDetail = await recipeRepository.getRecipeDetails(id);
      notifyListeners();
    } catch (error) {
      print(error.toString());
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
