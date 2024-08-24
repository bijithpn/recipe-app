import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';
import '../../utils/utils.dart';

import '../../core/core.dart';
import '../../data/data.dart';
import '../../db/db.dart';
import '../../view_models/view_models.dart';
import '../../widgets/widgets.dart';
import 'widget/widget.dart';

class RecipeDetailsPage extends StatefulWidget {
  // final String recipeId;
  final Recipe recipe;

  const RecipeDetailsPage({super.key, required this.recipe});

  @override
  State<RecipeDetailsPage> createState() => _RecipeDetailsPageState();
}

class _RecipeDetailsPageState extends State<RecipeDetailsPage> {
  @override
  void initState() {
    super.initState();
  }

  final notificationService = NotificationService();
  bool isSaved = false;
  ValueNotifier<double> scrollOffset = ValueNotifier(0.0);
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));
    return Consumer<DetailsProvider>(builder: (_, detailProvider, __) {
      return NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          if (scrollNotification is ScrollUpdateNotification) {
            scrollOffset.value = scrollNotification.metrics.pixels;
          }
          return true;
        },
        child: Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 250.0,
                floating: false,
                pinned: true,
                leading: IconButton(
                  style: IconButton.styleFrom(
                    shape: const CircleBorder(),
                    backgroundColor: Colors.white,
                  ),
                  icon: Icon(
                    Icons.arrow_back,
                    color: ColorPalette.primary,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                actions: [
                  IconButton(
                    style: IconButton.styleFrom(
                      shape: const CircleBorder(),
                      backgroundColor: Colors.white,
                    ),
                    icon: Icon(
                      isSaved ? Icons.bookmark : Icons.bookmark_outline,
                      color: ColorPalette.primary,
                    ),
                    onPressed: () async {
                      try {
                        if (isSaved) {
                          await detailProvider.recipeDb.deleteRecipe(
                              int.parse(widget.recipe.id.toString()));
                          if (context.mounted) {
                            notificationService.showSnackBar(
                                context: context, message: "Recipe removed");
                          }
                        } else {
                          var json = widget.recipe.toJson();
                          await detailProvider.recipeDb
                              .addOrUpdateRecipe(RecipeDB.fromJson(json));
                          if (context.mounted) {
                            notificationService.showSnackBar(
                                context: context, message: "Recipe added");
                          }
                        }
                        isSaved = await detailProvider.recipeDb
                            .recipeExists(widget.recipe.id);
                      } catch (error) {
                        if (context.mounted) {
                          notificationService.showSnackBar(
                              context: context, message: error.toString());
                        }
                      }
                      setState(() {});
                    },
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  title: ValueListenableBuilder(
                    valueListenable: scrollOffset,
                    builder: (_, value, child) {
                      if (value > 165) {
                        return child!;
                      }
                      return const SizedBox();
                    },
                    child: Text(
                      widget.recipe.title,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      ImageWidget(
                        width: double.infinity,
                        height: double.infinity,
                        imageUrl: widget.recipe.image,
                        fit: BoxFit.cover,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withOpacity(0.3),
                              Colors.transparent,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.recipe.title,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                  )),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Text(
                                "source: ${widget.recipe.sourceName}",
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              const Spacer(),
                              Icon(
                                Icons.recommend,
                                color: ColorPalette.primary,
                                size: 30,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                "${widget.recipe.healthScore}",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text('Description',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                  )),
                          const SizedBox(height: 4),
                          HtmlWidget(
                            Utils.clearSummaryText(widget.recipe.summary),
                            textStyle: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(height: 16),
                          Text('Ingredients',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                  )),
                          const SizedBox(height: 10),
                          IncredientsViewer(
                            ingredients: widget.recipe.extendedIngredients,
                          ),
                          const SizedBox(height: 16),
                          Text('Instructions',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                  )),
                          const SizedBox(height: 10),
                          ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              itemCount:
                                  widget.recipe.analyzedInstructions.length,
                              itemBuilder: (_, i) {
                                return InstructionViewer(
                                  instruction:
                                      widget.recipe.analyzedInstructions[i],
                                );
                              }),
                          const SizedBox(height: 16),
                          // CookingTipsScreen(
                          //   tips:  widget.recipe!.tips,
                          // )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: ElevatedButton.icon(
              onPressed: () async {
                await detailProvider.shareRecipe(widget.recipe);
              },
              style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  backgroundColor: ColorPalette.primary),
              icon: const Icon(
                Icons.share,
                color: Colors.white,
              ),
              label: Text(
                "Share Recipe",
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontWeight: FontWeight.bold, color: Colors.white),
              )),
        ),
      );
    });
  }
}

/*
 appBar: AppBar(
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: ColorPalette.primary,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            title: Text(
              detailProvider.recipeDetail?.title ?? "test",
              maxLines: 2,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            actions: [
              IconButton(
                style: IconButton.styleFrom(
                  shape: const CircleBorder(),
                  backgroundColor: Colors.white,
                ),
                icon: Icon(
                  isSaved ? Icons.bookmark : Icons.bookmark_outline,
                  color: ColorPalette.primary,
                ),
                onPressed: () async {
                  try {
                    if (isSaved) {
                      await detailProvider.recipeDb
                          .deleteRecipe(int.parse(widget.recipeId));
                      if (context.mounted) {
                        notificationService.showSnackBar(
                            context: context, message: "Recipe removed");
                      }
                    } else {
                      var json = detailProvider.recipeDetail?.toJson();
                      await detailProvider.recipeDb
                          .addOrUpdateRecipe(RecipeDB.fromJson(json ?? {}));
                      if (context.mounted) {
                        notificationService.showSnackBar(
                            context: context, message: "Recipe added");
                      }
                    }
                    isSaved = await detailProvider.recipeDb
                        .recipeExists(int.parse(widget.recipeId));
                  } catch (error) {
                    if (context.mounted) {
                      notificationService.showSnackBar(
                          context: context, message: error.toString());
                    }
                  }
                  setState(() {});
                },
              ),
            ],
          ),
          body: detailProvider.isLoading
              ? const Center(
                  child: LottieLoader(),
                )
              : detailProvider.recipeDetail == null
                  ? DetailsErrorWidget(recipeId: widget.recipeId)
                  : ListView(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          clipBehavior: Clip.hardEdge,
                          child: ImageWidget(
                            height: 250,
                            width: 200,
                            imageUrl: detailProvider.recipeDetail?.image ?? "",
                            fit: BoxFit.cover,
                            imagePlaceholder: (_, image) {
                              return Container(
                                height: 250,
                                width: 200,
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        color: Colors.grey.shade600, width: 1),
                                    borderRadius: BorderRadius.circular(15)),
                                child: Image(
                                  image: image,
                                  width: double.infinity,
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(detailProvider.recipeDetail?.title ?? "test",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                  fontWeight: FontWeight.bold,
                                )),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              "source: ${detailProvider.recipeDetail?.sourceName}",
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            const Spacer(),
                            Icon(
                              Icons.recommend,
                              color: ColorPalette.primary,
                              size: 30,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "${detailProvider.recipeDetail?.healthScore ?? 0}",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text('Description',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                  fontWeight: FontWeight.bold,
                                )),
                        const SizedBox(height: 4),
                        HtmlWidget(
                          Utils.clearSummaryText(
                              detailProvider.recipeDetail!.summary),
                          textStyle: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 16),
                        Text('Ingredients',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                  fontWeight: FontWeight.bold,
                                )),
                        const SizedBox(height: 10),
                        IncredientsViewer(
                          ingredients:
                              detailProvider.recipeDetail!.extendedIngredients,
                        ),
                        const SizedBox(height: 16),
                        Text('Instructions',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                  fontWeight: FontWeight.bold,
                                )),
                        const SizedBox(height: 10),
                        ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            itemCount: detailProvider
                                .recipeDetail!.analyzedInstructions.length,
                            itemBuilder: (_, i) {
                              return InstructionViewer(
                                instruction: detailProvider
                                    .recipeDetail!.analyzedInstructions[i],
                              );
                            }),
                        const SizedBox(height: 16),
                        CookingTipsScreen(
                          tips: detailProvider.recipeDetail!.tips,
                        )
                      ],
                    ),*/