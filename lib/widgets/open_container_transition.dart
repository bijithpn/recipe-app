import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:recipe_app/data/models/recipe.dart';
import 'package:recipe_app/view/recipe/details.dart';

class OpenContainerWrapper extends StatelessWidget {
  const OpenContainerWrapper({
    super.key,
    required this.recipe,
    required this.closedBuilder,
  });

  final Recipe recipe;
  final CloseContainerBuilder closedBuilder;
  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: OpenContainer(
        openElevation: 0,
        closedElevation: 0,
        openColor: Colors.transparent,
        closedColor: Colors.transparent,
        openBuilder: (BuildContext context, VoidCallback _) {
          return RecipeDetailsPage(
            recipe: recipe,
          );
        },
        tappable: true,
        closedBuilder: closedBuilder,
      ),
    );
  }
}
