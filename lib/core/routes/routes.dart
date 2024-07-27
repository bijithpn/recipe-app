import 'package:flutter/material.dart';

import '../../view/view.dart';

class RouteGenerator {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case '/details':
        if (args is String) {
          return MaterialPageRoute(
            builder: (_) => RecipeDetailsPage(recipeId: args),
          );
        }
        return MaterialPageRoute(
          builder: (_) =>
              const ErrorScreen(errorMessage: 'Invalid arguments for details'),
        );
      default:
        return MaterialPageRoute(
          builder: (_) =>
              ErrorScreen(errorMessage: 'Route not found: ${settings.name}'),
        );
    }
  }
}
