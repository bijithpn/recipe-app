import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:recipe_app/view/view.dart';

import '../../../core/core.dart';
import '../../../data/data.dart';
import '../../../db/db.dart';
import '../../../view_models/view_models.dart';
import '../../../widgets/image_widget.dart';
import 'widget.dart';

class RecipeCard extends StatefulWidget {
  const RecipeCard({
    super.key,
    required this.recipe,
  });

  final Recipe recipe;

  @override
  State<RecipeCard> createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard> {
  bool isSaved = false;
  final notificationService = NotificationService();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HomeProvider>(context, listen: false)
          .recipeDb
          .recipeExists(widget.recipe.id)
          .then((value) => setState(() {
                isSaved = value;
              }));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HomeProvider>(context, listen: false);
    return OpenContainerWrapper(
        recipe: widget.recipe,
        closedBuilder: (BuildContext _, VoidCallback openContainer) {
          return Card(
            elevation: 3,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12)),
                        child: ImageWidget(
                          width: double.infinity,
                          imageUrl: widget.recipe.image,
                          height: 145,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        right: 10,
                        top: 10,
                        child: InkWell(
                          onTap: () async {
                            try {
                              if (isSaved) {
                                await provider.recipeDb
                                    .deleteRecipe(widget.recipe.id);
                                if (context.mounted) {
                                  notificationService.showSnackBar(
                                      context: context,
                                      message: "Recipe removed");
                                }
                              } else {
                                var json = widget.recipe.toJson();
                                await provider.recipeDb
                                    .addOrUpdateRecipe(RecipeDB.fromJson(json));
                                if (context.mounted) {
                                  notificationService.showSnackBar(
                                      context: context,
                                      message: "Recipe added");
                                }
                              }
                              isSaved = await provider.recipeDb
                                  .recipeExists(widget.recipe.id);
                            } catch (error) {
                              if (context.mounted) {
                                notificationService.showSnackBar(
                                    context: context,
                                    message: error.toString());
                              }
                            }
                            setState(() {});
                          },
                          child: GlassDropEffect(
                            sigma: 10,
                            shape: BoxShape.circle,
                            child: Icon(
                              isSaved ? Icons.bookmark : Icons.bookmark_outline,
                              size: 22,
                              color:
                                  isSaved ? ColorPalette.primary : Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                          left: 5,
                          top: -2,
                          child: Chip(
                              side: BorderSide.none,
                              labelPadding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100)),
                              backgroundColor: ColorPalette.primary,
                              label: Text(
                                widget.recipe.vegetarian ? "Veg" : "Non veg",
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall!
                                    .copyWith(
                                        fontSize: 11,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                              ))),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.recipe.title,
                          maxLines: 3,
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: .5)),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "${widget.recipe.readyInMinutes} min",
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .copyWith(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            width: 1.5,
                            height: 15,
                            color: Colors.grey,
                          ),
                          Text(
                            "${widget.recipe.servings} serving",
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .copyWith(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      if (widget.recipe.usedIngredientCount != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Row(
                            children: [
                              Icon(Icons.check_box_outlined,
                                  color: ColorPalette.primary),
                              const SizedBox(width: 4),
                              Text(
                                "Owned: ${widget.recipe.usedIngredientCount}",
                                style: Theme.of(context).textTheme.bodyMedium,
                              )
                            ],
                          ),
                        ),
                      if (widget.recipe.missedIngredientCount != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.disabled_by_default_outlined,
                                color: Colors.red,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "Missing: ${widget.recipe.missedIngredientCount}",
                                style: Theme.of(context).textTheme.bodyMedium,
                              )
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}

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
        transitionDuration: const Duration(milliseconds: 250),
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
