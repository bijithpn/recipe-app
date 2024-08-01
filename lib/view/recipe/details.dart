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
  final String recipeId;

  const RecipeDetailsPage({super.key, required this.recipeId});

  @override
  State<RecipeDetailsPage> createState() => _RecipeDetailsPageState();
}

class _RecipeDetailsPageState extends State<RecipeDetailsPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<DetailsProvider>(context, listen: false);
      provider.recipeDb
          .recipeExists(int.parse(widget.recipeId))
          .then((value) => isSaved = value);
      provider.getDetails(widget.recipeId);
    });
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
          body: detailProvider.isLoading
              ? const Center(
                  child: LottieLoader(),
                )
              : detailProvider.recipeDetail == null
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 30, horizontal: 25),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: IconButton(
                                style: IconButton.styleFrom(
                                    backgroundColor: ColorPalette.primary),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                icon: const Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                )),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 50),
                            child: Column(
                              children: [
                                Image.asset(AssetsImages.noInternet),
                                Text(
                                  "Unable to load details. Please check your internet connection or try again later.",
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: .6),
                                ),
                                const SizedBox(height: 10),
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: ColorPalette.primary),
                                    onPressed: () {
                                      Provider.of<DetailsProvider>(context,
                                              listen: false)
                                          .getDetails(widget.recipeId);
                                    },
                                    child: Text(
                                      "Try again",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                    )),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  : CustomScrollView(
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
                                isSaved
                                    ? Icons.bookmark
                                    : Icons.bookmark_outline,
                                color: ColorPalette.primary,
                              ),
                              onPressed: () async {
                                try {
                                  if (isSaved) {
                                    await detailProvider.recipeDb.deleteRecipe(
                                        int.parse(widget.recipeId));
                                    if (context.mounted) {
                                      notificationService.showSnackBar(
                                          context: context,
                                          message: "Recipe removed");
                                    }
                                  } else {
                                    var json =
                                        detailProvider.recipeDetail?.toJson();
                                    await detailProvider.recipeDb
                                        .addOrUpdateRecipe(
                                            RecipeDB.fromJson(json ?? {}));
                                    if (context.mounted) {
                                      notificationService.showSnackBar(
                                          context: context,
                                          message: "Recipe added");
                                    }
                                  }
                                  isSaved = await detailProvider.recipeDb
                                      .recipeExists(int.parse(widget.recipeId));
                                } catch (error) {
                                  if (context.mounted) {
                                    notificationService.showSnackBar(
                                        context: context,
                                        message: error.toString());
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
                                detailProvider.recipeDetail?.title ?? "test",
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                            background: Stack(
                              fit: StackFit.expand,
                              children: [
                                ImageWidget(
                                  width: double.infinity,
                                  height: double.infinity,
                                  imageUrl:
                                      detailProvider.recipeDetail?.image ?? "",
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
                                    Text(
                                        detailProvider.recipeDetail?.title ??
                                            "test",
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
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge,
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
                                              .copyWith(
                                                  fontWeight: FontWeight.bold),
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
                                      textStyle:
                                          Theme.of(context).textTheme.bodyLarge,
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
                                    ListView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      padding: EdgeInsets.zero,
                                      itemCount: detailProvider.recipeDetail!
                                          .extendedIngredients.length,
                                      itemBuilder: (_, i) {
                                        var ingredient = detailProvider
                                            .recipeDetail!
                                            .extendedIngredients[i];
                                        return ListTile(
                                          leading: ImageWidget(
                                            width: 60,
                                            height: 60,
                                            padding: const EdgeInsets.all(3),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Colors.white),
                                            imageUrl:
                                                'https://img.spoonacular.com/ingredients_100x100/${ingredient.image}',
                                            fit: BoxFit.cover,
                                          ),
                                          title: Text(
                                            ingredient.name,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge!
                                                .copyWith(
                                                    fontWeight:
                                                        FontWeight.bold),
                                          ),
                                          subtitle: Text(
                                            ingredient.original,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(
                                                    color:
                                                        Colors.grey.shade800),
                                          ),
                                        );
                                      },
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
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        padding: EdgeInsets.zero,
                                        itemCount: detailProvider.recipeDetail!
                                            .analyzedInstructions.length,
                                        itemBuilder: (_, i) {
                                          return InstructionViewer(
                                            instruction: detailProvider
                                                .recipeDetail!
                                                .analyzedInstructions[i],
                                          );
                                        }),
                                    const SizedBox(height: 16),
                                    CookingTipsScreen(
                                      tips: detailProvider.recipeDetail!.tips,
                                    )
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
                await detailProvider.shareRecipe();
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
