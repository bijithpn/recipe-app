import 'package:recipe_app/core/constants/api_config.dart';
import 'package:recipe_app/data/models/details.dart';
import 'package:recipe_app/data/services/api_service.dart';
import 'package:recipe_app/main.dart';

class RecipeRepository {
  RecipeRepository();
  final apiClient = getIt<ApiClient>();

  Future<List<dynamic>> getRecipes() async {
    try {
      final res = await apiClient.get(ApiEndpoint.getRecipes, queryParameters: {
        "limitLicense": true,
        "number": 15,
        "include-tags": "meat,vegetarian"
      });
      return res.data['recipes'];
    } catch (e) {
      rethrow;
    }
  }

  Future<RecipeDetail?> getRecipeDetails(String id) async {
    try {
      final res = await apiClient
          .get(ApiEndpoint.details, queryParameters: {"ids": id});
      return RecipeDetail.fromJson(res.data[0]);
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
      return res.data;
    } catch (e) {
      rethrow;
    }
  }
}
