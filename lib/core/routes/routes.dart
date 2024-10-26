import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:recipe_app/data/api/auth_api.dart';
import 'package:recipe_app/main.dart';

import '../../utils/utils.dart';
import '../../view/view.dart';
import '../core.dart';

class RouteGenerator {
  static final authApi = getIt<AuthApi>();
  static final bool? _isFirstTime =
      Utils.getFomLocalStorage(key: StorageStrings.firstTime);
  static final GoRouter router = GoRouter(
    navigatorKey: navigatorKey,
    // refreshListenable:authApi.
    initialLocation: getIntialPath(),
    routes: [
      GoRoute(
        path: Routes.home,
        builder: (context, state) => const HomeNavigation(),
      ),
      GoRoute(
        path: Routes.onboarding,
        builder: (context, state) => const Onboarding(),
      ),
      GoRoute(
        path: Routes.login,
        builder: (context, state) => const Login(),
      ),
      GoRoute(
        path: Routes.register,
        builder: (context, state) => const Register(),
      ),
      GoRoute(
        path: Routes.authScreen,
        builder: (context, state) => const AuthScreen(),
      ),
      GoRoute(
        path: Routes.userPreference,
        builder: (context, state) => const UserPreference(),
      ),
      GoRoute(
        path: Routes.setting,
        builder: (context, state) => const SettingsPage(),
      ),
      GoRoute(
        path: Routes.details,
        builder: (context, state) {
          final recipeId = state.pathParameters['recipeId'];
          if (recipeId != null) {
            return RecipeDetailsPage(recipeId: recipeId);
          }
          return const ErrorScreen(
              errorMessage: 'Invalid arguments for details');
        },
      ),
      GoRoute(
        path: Routes.searchTile,
        builder: (context, state) {
          final tag = state.pathParameters['tag'];
          if (tag != null) {
            return SearchTileScreen(tag: tag);
          }
          return const ErrorScreen(
              errorMessage: 'Invalid arguments for searchTile');
        },
      ),
      GoRoute(
        path: Routes.cms,
        builder: (context, state) {
          final title = state.pathParameters['title'] ?? "";
          final content = state.pathParameters['content'] ?? "";
          if (title.isNotEmpty && content.isNotEmpty) {
            return CMSContent(title: title, content: content);
          }
          return const ErrorScreen(errorMessage: 'Invalid arguments for cms');
        },
      ),
    ],
    errorPageBuilder: (context, state) => MaterialPage<void>(
      child: ErrorScreen(errorMessage: 'Route not found: ${state.fullPath}'),
    ),
  );

  static String getIntialPath() {
    if (_isFirstTime == null) {
      return Routes.onboarding;
    }
    if (!authApi.isLoggedIn()) {
      return Routes.login;
    } else {
      return Routes.home;
    }
  }
}

class Routes {
  Routes._();
  static const String cms = '/cms';
  static const String details = '/details';
  static const String home = '/';
  static const String login = '/login';
  static const String onboarding = '/onBoarding';
  static const String register = '/register';
  static const String authScreen = '/authScreen';
  static const String setting = '/settings';
  static const String searchTile = '/searchTile';
  static const String userPreference = '/userPreference';
}
