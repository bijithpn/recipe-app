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
  final Recipe recipe;

  const RecipeDetailsPage({super.key, required this.recipe});

  @override
  State<RecipeDetailsPage> createState() => _RecipeDetailsPageState();
}

class _RecipeDetailsPageState extends State<RecipeDetailsPage> {
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

  Future<void> onSavePress() async {
    try {
      if (isSaved) {
        await recipeDb.deleteRecipe(int.parse(widget.recipe.id.toString()));
        if (mounted) {
          notificationService.showSnackBar(
              context: context, message: "Recipe removed");
        }
      } else {
        var json = widget.recipe.toJson();
        await recipeDb.addOrUpdateRecipe(RecipeDB.fromJson(json));
        if (mounted) {
          notificationService.showSnackBar(
              context: context, message: "Recipe added");
        }
      }
      isSaved = await recipeDb.recipeExists(widget.recipe.id);
    } catch (error) {
      if (mounted) {
        notificationService.showSnackBar(
            context: context, message: error.toString());
      }
    }
    setState(() {});
  }

  final recipeDb = getIt<RecipeDatabase>();
  final notificationService = NotificationService();
  bool isSaved = false;
  ValueNotifier<double> scrollOffset = ValueNotifier(0.0);
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));
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
                    widget.recipe.title,
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
                      onPressed: () => onSavePress,
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
                  imageUrl: widget.recipe.image,
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
                      Utils.clearSummaryText(widget.recipe.summary),
                      textStyle: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    if (widget.recipe.extendedIngredients.isNotEmpty)
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
                      ingredients: widget.recipe.extendedIngredients,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    if (widget.recipe.analyzedInstructions.isNotEmpty)
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
                      itemCount: widget.recipe.analyzedInstructions.length,
                      itemBuilder: (_, i) {
                        return InstructionViewer(
                          instruction: widget.recipe.analyzedInstructions[i],
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
              await shareRecipe(widget.recipe);
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
}
