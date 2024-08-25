import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/main.dart';
import 'package:share_plus/share_plus.dart';
import '../../utils/utils.dart';
import 'package:http/http.dart' as http;
import '../../core/core.dart';
import '../../data/data.dart';
import '../../db/db.dart';
import '../../view_models/view_models.dart';
import '../../widgets/widgets.dart';
import 'widget/widget.dart';

class RecipeDetailsPage extends StatefulWidget {
  const RecipeDetailsPage({super.key, this.recipe, this.recipeId});

  final Recipe? recipe;
  final String? recipeId;

  @override
  State<RecipeDetailsPage> createState() => _RecipeDetailsPageState();
}

class _RecipeDetailsPageState extends State<RecipeDetailsPage> {
  bool isSaved = false;
  final notificationService = NotificationService();
  final recipeDb = getIt<RecipeDatabase>();
  ValueNotifier<double> scrollOffset = ValueNotifier(0.0);
  late Future<Recipe?> _futureDetails;
  @override
  void initState() {
    super.initState();
    if (widget.recipe != null || widget.recipeId != null) {
      _futureDetails = RecipeRepository().getRecipeDetails(
          widget.recipeId?.toString() ?? widget.recipe?.id.toString() ?? "");
    }
  }

  Future<void> shareRecipe(Recipe recipeDetail) async {
    try {
      final imageResponse = await http.get(Uri.parse(recipeDetail.image));
      final documentDirectory = (await getTemporaryDirectory()).path;
      final imagePath = '$documentDirectory/${recipeDetail.title}_image.png';
      final imageFile = File(imagePath);
      if (!imageFile.existsSync()) {
        imageFile.writeAsBytesSync(imageResponse.bodyBytes);
      }
      String recipeDetails = 'Recipe: ${recipeDetail.title}\n\n'
          'Summary:\n${Utils.removeHtmlTags(Utils.clearSummaryText(recipeDetail.summary))}\n\n'
          'Steps:\n';
      for (var instruction in recipeDetail.analyzedInstructions) {
        for (var step in instruction.steps) {
          recipeDetails += '${step.number}. ${step.step}\n';
        }
      }
      recipeDetails += '\nIngredient\n';
      for (var ingredient in recipeDetail.extendedIngredients) {
        recipeDetails += '${ingredient.name}, ';
      }
      Share.shareXFiles([XFile(imagePath)], text: recipeDetails);
    } catch (e) {
      if (mounted) {
        notificationService.showSnackBar(
            context: context, message: AppStrings.error);
      }
    }
  }

  Future<void> onSavePress(Recipe recipe) async {
    try {
      if (isSaved) {
        await recipeDb.deleteRecipe(int.parse(recipe.id.toString()));
        if (mounted) {
          notificationService.showSnackBar(
              context: context, message: "Recipe removed");
        }
      } else {
        var json = recipe.toJson();
        await recipeDb.addOrUpdateRecipe(RecipeDB.fromJson(json));
        if (mounted) {
          notificationService.showSnackBar(
              context: context, message: "Recipe added");
        }
      }
      isSaved = await recipeDb.recipeExists(recipe.id);
    } catch (error) {
      if (mounted) {
        notificationService.showSnackBar(
            context: context, message: error.toString());
      }
    }
    setState(() {});
  }

  Widget buildDetailsView(Recipe recipe) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HomeProvider>(context, listen: false)
          .recipeDb
          .recipeExists(recipe.id)
          .then((value) => setState(() {
                isSaved = value;
              }));
    });
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        if (scrollNotification is ScrollUpdateNotification) {
          scrollOffset.value = scrollNotification.metrics.pixels;
        }
        return true;
      },
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: ValueListenableBuilder(
              valueListenable: scrollOffset,
              builder: (_, value, child) {
                return AppBar(
                  backgroundColor:
                      value > 170 ? Colors.white : Colors.transparent,
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
                      Navigator.pop(context);
                    },
                  ),
                  title: Text(
                    recipe.title,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: value > 170 ? Colors.black : Colors.white),
                  ),
                  centerTitle: true,
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
                      onPressed: () => onSavePress(recipe),
                    ),
                  ],
                );
              }),
        ),
        body: ListView(
          padding: EdgeInsets.zero,
          children: [
            Stack(
              children: [
                ImageWidget(
                  height: 300,
                  width: double.infinity,
                  imageUrl: recipe.image,
                  imagePlaceholder: (context, imageProvider) => Container(
                    width: double.infinity,
                    height: 300,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: imageProvider, fit: BoxFit.cover)),
                  ),
                  fit: BoxFit.cover,
                ),
                Container(
                  width: double.infinity,
                  height: 300,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.5),
                        Colors.transparent,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Description',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    HtmlWidget(
                      Utils.clearSummaryText(recipe.summary),
                      textStyle: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    if (recipe.extendedIngredients.isNotEmpty)
                      Text(
                        'Ingredients',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    const SizedBox(
                      height: 10,
                    ),
                    IncredientsViewer(
                      ingredients: recipe.extendedIngredients,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    if (recipe.analyzedInstructions.isNotEmpty)
                      Text(
                        'Instructions',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    const SizedBox(
                      height: 10,
                    ),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: recipe.analyzedInstructions.length,
                      itemBuilder: (_, i) {
                        return InstructionViewer(
                          instruction: recipe.analyzedInstructions[i],
                        );
                      },
                    ),
                    const SizedBox(
                      height: 55,
                    ),
                  ],
                )),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: ElevatedButton.icon(
            onPressed: () async {
              await shareRecipe(recipe);
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
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));

    if (widget.recipe != null) {
      return buildDetailsView(widget.recipe!);
    } else if (widget.recipeId != null) {
      return Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: FutureBuilder<Recipe?>(
          future: _futureDetails,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: LottieLoader());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              return buildDetailsView(snapshot.data!);
            } else {
              return Center(
                  child: Text(
                'No details available.',
                style: Theme.of(context).textTheme.bodyLarge,
              ));
            }
          },
        ),
      );
    } else {
      return Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Center(
            child: Text(
          'No product ID provided.',
          style: Theme.of(context).textTheme.bodyLarge,
        )),
      );
    }
  }
}
