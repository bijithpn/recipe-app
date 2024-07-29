import 'package:hive/hive.dart';

import 'model/recipe.dart';

class RecipeDatabase {
  RecipeDatabase._privateConstructor();

  static final RecipeDatabase instance = RecipeDatabase._privateConstructor();

  static const _boxName = 'recipes';

  Future<Box<RecipeDB>> _openBox() async {
    return await Hive.openBox<RecipeDB>(_boxName);
  }

  Future<void> addOrUpdateRecipe(RecipeDB recipe) async {
    final box = await _openBox();
    await box.put(recipe.id, recipe);
  }

  Future<RecipeDB?> getRecipeDB(int id) async {
    final box = await _openBox();
    return box.get(id);
  }

  Future<List<RecipeDB>> getAllRecipes() async {
    final box = await _openBox();
    return box.values.toList();
  }

  Future<void> deleteRecipe(int id) async {
    final box = await _openBox();
    await box.delete(id);
  }

  Future<void> deleteAllRecipes() async {
    final box = await _openBox();
    await box.clear();
  }

  Future<bool> recipeExists(int id) async {
    final box = await _openBox();
    return box.containsKey(id);
  }

  Future<void> close() async {
    final box = await _openBox();
    await box.close();
  }
}
