import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:flutter/foundation.dart';
import 'package:recipe_app/core/constants/strings.dart';
import 'package:recipe_app/data/models/details.dart';
import 'package:recipe_app/data/repositories/recipe_repositrory.dart';
import 'package:recipe_app/data/services/notification_service.dart';
import 'package:recipe_app/db/db.dart';
import 'package:recipe_app/main.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:recipe_app/utils/utils.dart';
import 'package:share_plus/share_plus.dart';

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
        final imagePath = '$documentDirectory/recipe_image.png';
        final imageFile = File(imagePath);
        imageFile.writeAsBytesSync(imageResponse.bodyBytes);
        String recipeDetails = 'Recipe: ${recipeDetail!.title}\n\n'
            'Instructions:\n${removeHtmlTags(recipeDetail!.instructions)}\n\n'
            'Steps:\n';
        for (var instruction in recipeDetail!.analyzedInstructions) {
          for (var step in instruction.steps) {
            recipeDetails += '${step.number}. ${step.step}\n';
          }
        }
        Share.shareXFiles([XFile(imagePath)], text: recipeDetails);
      }
    } catch (e) {
      notificationService.showSnackBar(
          context: navigatorKey.currentContext!, message: AppStrings.error);
    }
  }
}
