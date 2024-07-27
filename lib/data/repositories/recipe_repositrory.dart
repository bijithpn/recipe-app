import 'package:recipe_app/core/constants/api_config.dart';
import 'package:recipe_app/data/models/details.dart';
import 'package:recipe_app/data/services/api_service.dart';
import 'package:recipe_app/main.dart';

class RecipeRepository {
  final apiClient = getIt<ApiClient>();

  RecipeRepository();

  Future<List<dynamic>> getRecipes() async {
    try {
      final res = await apiClient.get(ApiEndpoint.getRecipes, queryParameters: {
        "limitLicense": true,
        "number": 12,
        "include-tags": "meat"
      });
      return res.data['recipes'];
    } catch (e) {
      throw Exception('Failed to load recipe');
    }
  }

  Future<RecipeDetail?> getRecipeDetails(String id) async {
    try {
      final res = await apiClient
          .get(ApiEndpoint.details, queryParameters: {"ids": id});
      return RecipeDetail.fromJson(res.data[0]);
    } catch (e) {
      print(e.toString());
      throw Exception('Failed to load recipe');
    }
  }
}
