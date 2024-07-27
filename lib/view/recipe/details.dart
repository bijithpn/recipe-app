import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/core/constants/colors.dart';
import 'package:recipe_app/view_models/details_provider.dart';

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
      provider.getDetails(widget.recipeId);
    });
    super.initState();
  }

  String editSummary(String summary) {
    const String targetPhrase = "liked this recipe";
    int targetIndex = summary.indexOf(targetPhrase);
    String processedHtmlData;
    if (targetIndex != -1) {
      processedHtmlData = summary.substring(0, targetIndex);
    } else {
      processedHtmlData = summary;
    }
    return processedHtmlData;
  }

  double _scrollOffset = 0;
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
            setState(() {
              _scrollOffset = scrollNotification.metrics.pixels;
            });
          }
          return true;
        },
        child: Scaffold(
          body: detailProvider.isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
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
                            Icons.bookmark_outline,
                            color: ColorPalette.primary,
                          ),
                          onPressed: () {},
                        ),
                      ],
                      flexibleSpace: FlexibleSpaceBar(
                        collapseMode: CollapseMode.pin,
                        title: _scrollOffset > 165
                            ? Text(
                                detailProvider.recipeDetail?.title ?? "test",
                                style: Theme.of(context).textTheme.bodyLarge,
                              )
                            : null,
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
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
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
                                  editSummary(
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
                                ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: detailProvider
                                      .recipeDetail!.extendedIngredients.length,
                                  itemBuilder: (_, i) {
                                    var ingredient = detailProvider
                                        .recipeDetail!.extendedIngredients[i];
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
                                                fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: Text(
                                        ingredient.original,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                                color: Colors.grey.shade800),
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
        ),
      );
    });
  }
}
