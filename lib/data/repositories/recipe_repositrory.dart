import 'package:recipe_app/data/data.dart';

import '../../core/constants/api_config.dart';
import '../../main.dart';

class RecipeRepository {
  RecipeRepository();
  final apiClient = getIt<ApiClient>();

  Future<List<Recipe>> getRecipes(
      {String tags = "breakfast,lunch,dinner"}) async {
    try {
      List<Recipe> recipeList = [];
      final res = await apiClient.get(ApiEndpoint.getRecipes, queryParameters: {
        "limitLicense": true,
        "number": 45,
        "include-tags": tags.toLowerCase()
      });
      res.data['recipes']
          .map((e) => recipeList.add(Recipe.fromJson(e)))
          .toList();
      return recipeList;
    } catch (e) {
      rethrow;
    }
  }

  Future<Recipe?> getRecipeDetails(String id) async {
    try {
      final res = await apiClient
          .get(ApiEndpoint.details, queryParameters: {"ids": id});
      return Recipe.fromJson(res.data[0]);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<dynamic>> searchByIngredients(String ingredients) async {
    try {
      final res = await apiClient.get(ApiEndpoint.search, queryParameters: {
        "ingredients": ingredients,
        "number": 16,
        "limitLicense": true,
        "ranking": 1,
      });
      return res.data ?? <dynamic>[];
    } catch (e) {
      rethrow;
    }
  }

  Future<List<dynamic>> searchAutoComplete(String query) async {
    try {
      final res = await apiClient.get(ApiEndpoint.autoComplete,
          queryParameters: {"query": query, "number": 20});
      return res.data ?? <dynamic>[];
    } catch (e) {
      rethrow;
    }
  }
}
