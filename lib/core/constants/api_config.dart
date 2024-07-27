class ApiConfig {
  static const String baseUrl = 'https://api.spoonacular.com/';
}

class ApiEndpoint {
  static const String search = 'recipes/findByIngredients';
  static const String details = 'recipes/informationBulk';
  static const String getRecipes = 'recipes/random';
}
