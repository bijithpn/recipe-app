import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/main.dart';

import '../../../core/core.dart';
import '../../../data/data.dart';
import '../../../data/services/notification_service.dart';
import '../../../db/db.dart';
import '../../../view_models/view_models.dart';
import '../../../widgets/widgets.dart';
import '../../view.dart';

class SavedRecipeCard extends StatefulWidget {
  final RecipeDB recipe;
  final VoidCallback? callBack;

  const SavedRecipeCard({
    super.key,
    required this.recipe,
    this.callBack,
  });

  @override
  State<SavedRecipeCard> createState() => _SavedRecipeCardState();
}

class _SavedRecipeCardState extends State<SavedRecipeCard> {
  bool isSaved = true;

  @override
  void initState() {
    super.initState();
  }

  final notificationService = getIt<NotificationService>();
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HomeProvider>(context, listen: false);
    final recipe = Recipe.fromJson(jsonDecode(widget.recipe.toPrettyJson()));
    return OpenContainerWrapper(
        recipe: recipe,
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
                              await provider.recipeDb
                                  .deleteRecipe(widget.recipe.id);
                              if (context.mounted) {
                                notificationService.showSnackBar(
                                    context: context,
                                    message: "Recipe removed");
                              }
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
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}
