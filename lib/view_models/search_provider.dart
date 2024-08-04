import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../core/core.dart';
import '../data/data.dart';
import '../main.dart';

class SearchProvider extends ChangeNotifier {
  final recipeRepository = RecipeRepository();
  final notificationService = NotificationService();
  List<dynamic> searchResult = [];

  Future<Iterable<Map<String, dynamic>>> getSearchQuery(String query) async {
    List<Map<String, dynamic>> result = [];
    try {
      if (query == '') {
        return const Iterable<Map<String, dynamic>>.empty();
      }
      searchResult = await recipeRepository.searchAutoComplete(query);
      if (searchResult.isEmpty) {
        return const Iterable<Map<String, dynamic>>.empty();
      }
      result = searchResult.cast<Map<String, dynamic>>();
      return result;
    } catch (error) {
      if (error is DioException) {
        notificationService.showSnackBar(
            context: navigatorKey.currentContext!,
            message: error.response?.data['message'] ?? AppStrings.error);
      } else {
        notificationService.showSnackBar(
            context: navigatorKey.currentContext!, message: error.toString());
      }
      return const Iterable<Map<String, dynamic>>.empty();
    }
  }
}
