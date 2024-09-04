class ApiConfig {
  ApiConfig._();
  static const String baseUrl = 'https://api.spoonacular.com/recipes/';
  static const String imageUrl = 'https://img.spoonacular.com/';
}

class ApiEndpoint {
  ApiEndpoint._();
  static const String search = 'findByIngredients';
  static const String details = 'informationBulk';
  static const String getRecipes = 'random';
  static const String nutritionLabelImg = '';
  static const String autoComplete = 'autocomplete';
}
