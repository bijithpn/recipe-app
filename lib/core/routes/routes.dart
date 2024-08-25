import 'package:flutter/material.dart';
import '../../view/view.dart';

class RouteGenerator {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case Routes.home:
        return MaterialPageRoute(builder: (_) => const HomeNavigation());
      case Routes.onboarding:
        return MaterialPageRoute(builder: (_) => const Onboarding());
      case Routes.login:
        return MaterialPageRoute(builder: (_) => const Login());
      case Routes.register:
        return MaterialPageRoute(builder: (_) => const Register());
      case Routes.boarding:
        return MaterialPageRoute(builder: (_) => const AuthScreen());
      case Routes.setting:
        return MaterialPageRoute(builder: (_) => const SettingsPage());
      case Routes.details:
        if (args is String) {
          return MaterialPageRoute(
            builder: (_) => RecipeDetailsPage(
              recipeId: args,
            ),
          );
        }
        return MaterialPageRoute(
          builder: (_) =>
              const ErrorScreen(errorMessage: 'Invalid arguments for details'),
        );
      case Routes.cms:
        if (args is Map<String, String>) {
          return MaterialPageRoute(
            builder: (_) => CMSContent(
              title: args['title'] ?? "",
              content: args['content'] ?? "",
            ),
          );
        }
        return MaterialPageRoute(
          builder: (_) =>
              const ErrorScreen(errorMessage: 'Invalid arguments for cms'),
        );
      default:
        return MaterialPageRoute(
          builder: (_) =>
              ErrorScreen(errorMessage: 'Route not found: ${settings.name}'),
        );
    }
  }
}

class Routes {
  static const String cms = '/cms';
  static const String details = '/details';
  static const String home = '/';
  static const String login = '/login';
  static const String onboarding = '/onBoarding';
  static const String register = '/register';
  static const String boarding = '/boarding';
  static const String setting = '/settings';
}
