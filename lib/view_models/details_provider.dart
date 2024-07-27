import 'package:flutter/foundation.dart';
import 'package:recipe_app/data/models/details.dart';
import 'package:recipe_app/data/repositories/recipe_repositrory.dart';

class DetailsProvider extends ChangeNotifier {
  RecipeDetail? recipeDetail;
  bool isLoading = true;
  final recipeRepository = RecipeRepository();

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
