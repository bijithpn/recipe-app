import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:recipe_app/data/services/notification_service.dart';
import '../main.dart';

import '../core/core.dart';
import '../data/data.dart';
import '../db/db.dart';

enum HomeState { search, home, filter, isLoading, isError }

class HomeProvider extends ChangeNotifier {
  List<String> dietTypes = [];
  List<String> dishTypes = [];
  List<Recipe> filteredRecipeList = [];
  HomeState homeState = HomeState.isLoading;
  final notificationService = getIt<NotificationService>();
  final recipeDb = getIt<RecipeDatabase>();
  List<Recipe> recipeList = [];
  final recipeRepository = RecipeRepository();
  List<Recipe> searchRecipeList = [];
  List<String> selectedDiets = [];
  List<String> selectedDishTypes = [];

  Future<List<Recipe>> getRecipes() async {
    homeState = HomeState.isLoading;
    notifyListeners();
    try {
      recipeList = await recipeRepository.getRecipes();
      dishTypes = _getDishTypes(recipeList);
      dietTypes = _getDiets(recipeList);
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
      homeState = HomeState.home;
      notifyListeners();
    }
    return recipeList;
  }

  Future<void> searchRecipe(String ingredients) async {
    homeState = HomeState.isLoading;
    notifyListeners();
    try {
      final temp = await recipeRepository.searchByIngredients(ingredients);
      temp.map((e) => searchRecipeList.add(Recipe.fromJson(e))).toList();
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
      homeState = HomeState.search;
      notifyListeners();
    }
  }

  void clearSearchData() {
    homeState = HomeState.home;
    searchRecipeList.clear();
    notifyListeners();
  }

  void clearFilterData() {
    selectedDishTypes.clear();
    selectedDiets.clear();
    homeState = HomeState.home;
    filteredRecipeList.clear();
    notifyListeners();
  }

  void filterRecipes(
      List<String> selectedDishTypes, List<String> selectedDiets) {
    homeState = HomeState.filter;
    filteredRecipeList = recipeList.where((recipe) {
      final matchesDishType = selectedDishTypes.isEmpty ||
          recipe.dishTypes.any(selectedDishTypes.contains);
      final matchesDiet =
          selectedDiets.isEmpty || recipe.diets!.any(selectedDiets.contains);
      return matchesDishType && matchesDiet;
    }).toList();
    notifyListeners();
  }

  List<String> _getDishTypes(List<Recipe> recipes) {
    return recipes.expand((recipe) => recipe.dishTypes).toSet().toList();
  }

  List<String> _getDiets(List<Recipe> recipes) {
    return recipes
        .expand((recipe) => recipe.diets ?? <String>[])
        .toSet()
        .toList();
  }
}
