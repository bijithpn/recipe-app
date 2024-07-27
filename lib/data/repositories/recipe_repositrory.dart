import 'package:recipe_app/data/services/api_service.dart';
import 'package:recipe_app/main.dart';

class RecipeRepository {
  final apiClient = getIt<ApiClient>();

  RecipeRepository();

  Future<List<dynamic>> getRecipes() async {
    try {
      final res = await apiClient.get('/recipes/random', queryParameters: {
        "limitLicense": true,
        "number": 12,
        "include-tags": "meat"
      });
      return res.data['recipes'];
    } catch (e) {
      throw Exception('Failed to load recipe');
    }
  }
}
