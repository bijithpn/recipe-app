import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/core/constants/colors.dart';
import 'package:recipe_app/core/constants/image.dart';
import 'package:recipe_app/data/services/notification_service.dart';
import 'package:recipe_app/db/model/recipe.dart';
import 'package:recipe_app/view_models/home_provider.dart';

import '../view.dart';

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

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HomeProvider>(context, listen: false);
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/details',
          arguments: widget.recipe.id.toString(),
        );
      },
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          width: 230,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
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
                      child: CachedNetworkImage(
                        width: double.infinity,
                        imageUrl: widget.recipe.image,
                        fit: BoxFit.cover,
                        imageBuilder: (context, imageProvider) =>
                            Image(image: imageProvider),
                        placeholder: (context, url) => const SizedBox(
                          height: 115,
                          child: Center(child: CircularProgressIndicator()),
                        ),
                        errorWidget: (context, url, error) => Container(
                          height: 115,
                          color: Colors.grey.shade300,
                          child: const Icon(Icons.error_outline),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 10,
                      top: 10,
                      child: GlassDropEffect(
                        sigma: 10,
                        shape: BoxShape.circle,
                        child: IconButton(
                          onPressed: () async {
                            try {
                              await provider.recipeDb
                                  .deleteRecipe(widget.recipe.id);
                              widget.callBack!();
                            } catch (error) {
                              if (context.mounted) {
                                NotificationService().showSnackBar(
                                    context: context,
                                    message: error.toString());
                              }
                            }
                            setState(() {});
                          },
                          icon: Icon(
                            Icons.bookmark,
                            size: 22,
                            color: ColorPalette.primary,
                          ),
                        ),
                      ),
                    ),
                    if (widget.recipe.aggregateLikes != null)
                      Positioned(
                          left: 10,
                          top: 10,
                          child: GlassDropEffect(
                            sigma: 10,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.recommend,
                                  color: ColorPalette.primary,
                                  size: 22,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  "${widget.recipe.aggregateLikes}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                ),
                              ],
                            ),
                          )),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 50,
                      alignment: Alignment.topCenter,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(widget.recipe.title,
                                maxLines: 2,
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: .5)),
                          ),
                          if (widget.recipe.vegetarian != null)
                            Image.asset(
                              AssetsImages.veg,
                              width: 25,
                              height: 25,
                              color: widget.recipe.vegetarian!
                                  ? ColorPalette.primary
                                  : ColorPalette.red,
                            )
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text("Source: ${widget.recipe.sourceName}",
                        maxLines: 1,
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: Colors.grey)),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        if (widget.recipe.readyInMinutes != null)
                          Row(
                            children: [
                              const Icon(Icons.timer_outlined),
                              const SizedBox(width: 4),
                              Text(
                                "${widget.recipe.readyInMinutes}m",
                                style: Theme.of(context).textTheme.bodyLarge,
                              )
                            ],
                          ),
                        if (widget.recipe.servings != null)
                          Row(
                            children: [
                              const Icon(Icons.local_dining),
                              const SizedBox(width: 4),
                              Text(
                                "${widget.recipe.servings}",
                                style: Theme.of(context).textTheme.bodyLarge,
                              )
                            ],
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
                    const SizedBox(height: 5)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
