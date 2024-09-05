class ApiConfig {
  ApiConfig._();
  static const String baseUrl = 'https://api.spoonacular.com/';
  static const String imageUrl = 'https://img.spoonacular.com/';
}

class ApiEndpoint {
  ApiEndpoint._();
  static const String search = 'recipes/findByIngredients';
  static const String details = 'recipes/informationBulk';
  static const String getRecipes = 'recipes/random';
  static const String nutritionLabelImg = '';
  static const String autoComplete = 'recipes/autocomplete';
  static const String genUserData = 'users/connect';
}
