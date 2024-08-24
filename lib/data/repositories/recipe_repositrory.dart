import 'package:recipe_app/data/data.dart';

import '../../core/constants/api_config.dart';
import '../../main.dart';
import '../services/api_service.dart';

class RecipeRepository {
  RecipeRepository();
  final apiClient = getIt<ApiClient>();

  Future<List<dynamic>> getRecipes() async {
    try {
      final res = await apiClient.get(ApiEndpoint.getRecipes, queryParameters: {
        "limitLicense": true,
        "number": 15,
        "include-tags": "lunch"
      });
      return res.data['recipes'] ?? <dynamic>[];
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
