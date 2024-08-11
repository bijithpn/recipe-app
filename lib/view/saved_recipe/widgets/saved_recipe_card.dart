import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/core.dart';
import '../../../data/data.dart';
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
  bool isSaved = false;

  @override
  void initState() {
    super.initState();
  }

  final notificationService = NotificationService();
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HomeProvider>(context, listen: false);
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          Routes.details,
          arguments: widget.recipe.id.toString(),
        );
      },
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                                  context: context, message: "Recipe removed");
                            }
                          } else {
                            var json = widget.recipe.toJson();
                            await provider.recipeDb
                                .addOrUpdateRecipe(RecipeDB.fromJson(json));
                            if (context.mounted) {
                              notificationService.showSnackBar(
                                  context: context, message: "Recipe added");
                            }
                          }
                          isSaved = await provider.recipeDb
                              .recipeExists(widget.recipe.id);
                        } catch (error) {
                          if (context.mounted) {
                            notificationService.showSnackBar(
                                context: context, message: error.toString());
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
                          color: isSaved ? ColorPalette.primary : Colors.white,
                        ),
                      ),
                    ),
                  ),
                  if (widget.recipe.vegetarian != null)
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
                              widget.recipe.vegetarian! ? "Veg" : "Non veg",
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
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.recipe.title,
                      maxLines: 3,
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.bold, letterSpacing: .5)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      if (widget.recipe.readyInMinutes != null)
                        Text(
                          "${widget.recipe.readyInMinutes} min",
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium!
                              .copyWith(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold),
                        ),
                      if (widget.recipe.readyInMinutes != null &&
                          widget.recipe.servings != null)
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          width: 1.5,
                          height: 15,
                          color: Colors.grey,
                        ),
                      if (widget.recipe.servings != null)
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
      ),
    );
  }
}
