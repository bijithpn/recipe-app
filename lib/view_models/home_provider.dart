import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:recipe_app/core/constants/strings.dart';
import 'package:recipe_app/data/models/recipe.dart';
import 'package:recipe_app/data/services/notification_service.dart';
import 'package:recipe_app/main.dart';

import '../data/repositories/recipe_repositrory.dart';

class HomeProvider extends ChangeNotifier {
  List<Recipe> recipeList = [];
  final notificationService = NotificationService();
  List<Recipe> filteredRecipeList = [];
  bool isLoading = false;
  bool isSearch = false;
  final recipeRepository = RecipeRepository();

  Future<void> getRecipes() async {
    isLoading = true;
    notifyListeners();
    try {
      final temp = await recipeRepository.getRecipes();
      temp.map((e) => recipeList.add(Recipe.fromJson(e))).toList();
      notifyListeners();
    } catch (error) {
      if (error is DioException) {
        notificationService.showSnackBar(
            context: navigatorKey.currentContext!,
            message: error.response?.data['message'] ?? AppStrings.error);
      } else {
        notificationService.showSnackBar(
            context: navigatorKey.currentContext!, message: error.toString());
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchRecipe(String ingredients) async {
    isLoading = true;
    isSearch = true;
    notifyListeners();
    try {
      final temp = await recipeRepository.searchByIngredients(ingredients);
      temp.map((e) => filteredRecipeList.add(Recipe.fromJson(e))).toList();
      notifyListeners();
    } catch (error) {
      if (error is DioException) {
        notificationService.showSnackBar(
            context: navigatorKey.currentContext!,
            message: error.message ?? AppStrings.error);
      } else {
        notificationService.showSnackBar(
            context: navigatorKey.currentContext!, message: error.toString());
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
