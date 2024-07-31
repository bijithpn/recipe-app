import '../../core/constants/api_config.dart';
import '../models/details.dart';
import '../services/api_service.dart';
import '../../main.dart';

class RecipeRepository {
  RecipeRepository();
  final apiClient = getIt<ApiClient>();

  Future<List<dynamic>> getRecipes() async {
    try {
      final res = await apiClient.get(ApiEndpoint.getRecipes, queryParameters: {
        "limitLicense": true,
        "number": 15,
        "include-tags": "meat"
      });
      return res.data['recipes'] ?? <dynamic>[];
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
      return res.data ?? <dynamic>[];
    } catch (e) {
      rethrow;
    }
  }
}
