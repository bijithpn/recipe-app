import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../core/core.dart';
import '../data/data.dart';
import '../db/db.dart';
import '../main.dart';
import '../utils/utils.dart';

class DetailsProvider extends ChangeNotifier {
  RecipeDetail? recipeDetail;
  bool isLoading = true;
  final recipeRepository = RecipeRepository();
  final recipeDb = getIt<RecipeDatabase>();
  final notificationService = NotificationService();

  Future<void> getDetails(String id) async {
    isLoading = true;
    notifyListeners();
    try {
      recipeDetail = await recipeRepository.getRecipeDetails(id);
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

  Future<void> shareRecipe() async {
    try {
      if (recipeDetail != null) {
        final imageResponse = await http.get(Uri.parse(recipeDetail!.image));
        final documentDirectory = (await getTemporaryDirectory()).path;
        final imagePath =
            '$documentDirectory/${recipeDetail?.title ?? "recipe"}_image.png';
        final imageFile = File(imagePath);
        if (!imageFile.existsSync()) {
          imageFile.writeAsBytesSync(imageResponse.bodyBytes);
        }
        String recipeDetails = 'Recipe: ${recipeDetail!.title}\n\n'
            'Summary:\n${Utils.removeHtmlTags(Utils.clearSummaryText(recipeDetail!.summary))}\n\n'
            'Steps:\n';
        for (var instruction in recipeDetail!.analyzedInstructions) {
          for (var step in instruction.steps) {
            recipeDetails += '${step.number}. ${step.step}\n';
          }
        }
        recipeDetails += '\nIngredient\n';
        for (var ingredient in recipeDetail!.extendedIngredients) {
          recipeDetails += '${ingredient.name}, ';
        }
        Share.shareXFiles([XFile(imagePath)], text: recipeDetails);
      }
    } catch (e) {
      notificationService.showSnackBar(
          context: navigatorKey.currentContext!, message: AppStrings.error);
    }
  }
}
